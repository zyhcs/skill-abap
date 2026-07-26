#!/usr/bin/env python3
"""Read-only debug wrapper for SAP AI MCP REST.

This CLI intentionally exposes only read/debug endpoints. It builds the correct
payload shape for each endpoint so callers do not need to hand-write JSON.
"""

from __future__ import annotations

import argparse
import getpass
import json
from pathlib import Path
import sys
from typing import Any

from sap_ai_mcp_lib import SapAiMcpClient, SapAI_MCPError

SOURCE_KEYS = ("source_code", "source")


def make_client(args: argparse.Namespace) -> SapAiMcpClient:
    user = args.user
    password = args.password
    if args.userpass:
        if ":" not in args.userpass:
            raise SapAI_MCPError("INVALID_USERPASS", "--userpass must be in user:password form.")
        user, password = args.userpass.split(":", 1)
    if args.ask_password and not password:
        if not user:
            entered = input("SAP user: ").strip()
            user = entered or None
        password = getpass.getpass("SAP password: ")
    return SapAiMcpClient(
        base_url=args.base_url,
        user=user,
        password=password,
        log_root=args.log_dir,
        no_proxy=not args.use_proxy,
        timeout=args.timeout,
        allow_dangerous=False,
        profile=args.profile,
    )


def add_common(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--profile", "-p", help="Environment profile name (e.g. dev, qas, prd). Configured in config/sap_environments.json.")
    parser.add_argument("--base-url")
    parser.add_argument("--user")
    parser.add_argument("--password")
    parser.add_argument("--userpass")
    parser.add_argument("--ask-password", action="store_true")
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--log-dir", type=Path)
    parser.add_argument("--use-proxy", action="store_true", help="Use inherited proxy environment variables.")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--full-source", action="store_true", help="Print full source_code/source fields; default output keeps only summary and log path.")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="SAP AI MCP read-only debug wrapper.")
    add_common(parser)
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("ddic-fields", help="Read active DDIC fields with payload {type_name}.")
    p.add_argument("type_name")

    p = sub.add_parser("ddic-type", help="Inspect runtime type with payload {type_name}.")
    p.add_argument("type_name")

    p = sub.add_parser("domain-values", help="Read domain fixed values with payload {domain_name}.")
    p.add_argument("domain_name")

    p = sub.add_parser("dynpro", help="Read generated Dynpro metadata.")
    p.add_argument("program")
    p.add_argument("screen")

    p = sub.add_parser("function", help="Read a function module source.")
    p.add_argument("function_name")

    p = sub.add_parser("function-group", help="Read a function group source and includes.")
    p.add_argument("function_group")

    p = sub.add_parser("fm-interface", help="Read function module interface with payload {function_name}.")
    p.add_argument("function_name")

    p = sub.add_parser("report", help="Read report/program source.")
    p.add_argument("program")

    p = sub.add_parser("include", help="Read include source through /object/read as PROG.")
    p.add_argument("include")

    p = sub.add_parser("class", help="Read global class source.")
    p.add_argument("class_name")

    p = sub.add_parser("method", help="Read a global class method source.")
    p.add_argument("class_name")
    p.add_argument("method_name")
    p.add_argument("--version", choices=["ACTIVE", "INACTIVE", "BOTH", "A", "I", "ALL"])

    p = sub.add_parser("locks", help="Read locks for an object with payload {object_name}.")
    p.add_argument("object_name")

    sub.add_parser("capabilities", help="Read handler capabilities.")
    return parser


def endpoint_and_payload(args: argparse.Namespace) -> tuple[str, dict[str, Any], str]:
    cmd = args.command
    if cmd == "ddic-fields":
        name = args.type_name.upper()
        return "debug_ddic_fields", {"type_name": name}, f"debug-ddic-fields-{name}"
    if cmd == "ddic-type":
        name = args.type_name.upper()
        return "debug_ddic_type", {"type_name": name}, f"debug-ddic-type-{name}"
    if cmd == "domain-values":
        name = args.domain_name.upper()
        return "debug_domain_values", {"domain_name": name}, f"debug-domain-values-{name}"
    if cmd == "dynpro":
        program = args.program.upper()
        screen = args.screen
        return "debug_dynpro_read", {"program": program, "screen": screen}, f"debug-dynpro-{program}-{screen}"
    if cmd == "function":
        name = args.function_name.upper()
        return "function_read", {"function_name": name, "source_format": "STRING"}, f"debug-function-{name}"
    if cmd == "function-group":
        name = args.function_group.upper()
        return "function_group_read", {"function_group": name, "source_format": "STRING"}, f"debug-function-group-{name}"
    if cmd == "fm-interface":
        name = args.function_name.upper()
        return "debug_fm_interface", {"function_name": name}, f"debug-fm-interface-{name}"
    if cmd == "report":
        name = args.program.upper()
        return "object_read", {"object_type": "PROG", "object_name": name, "source_format": "STRING"}, f"debug-report-{name}"
    if cmd == "include":
        name = args.include.upper()
        return "object_read", {"object_type": "PROG", "object_name": name, "source_format": "STRING"}, f"debug-include-{name}"
    if cmd == "class":
        name = args.class_name.upper()
        return "object_read", {"object_type": "CLAS", "object_name": name, "source_format": "STRING"}, f"debug-class-{name}"
    if cmd == "method":
        class_name = args.class_name.upper()
        method_name = args.method_name.upper()
        payload = {"class_name": class_name, "method_name": method_name, "source_format": "STRING"}
        if args.version:
            payload["version"] = args.version.upper()
        return "class_method_read", payload, f"debug-method-{class_name}-{method_name}"
    if cmd == "locks":
        name = args.object_name.upper()
        return "debug_locks", {"object_name": name}, f"debug-locks-{name}"
    if cmd == "capabilities":
        return "capabilities", {}, "debug-capabilities"
    raise SapAI_MCPError("UNSUPPORTED_COMMAND", f"Unsupported command: {cmd}")


def summarize_value(value: Any, *, full_source: bool) -> Any:
    if isinstance(value, dict):
        result: dict[str, Any] = {}
        for key, item in value.items():
            if key in SOURCE_KEYS and isinstance(item, str) and not full_source:
                result[f"{key}_length"] = len(item)
                result[f"{key}_line_count"] = len(item.splitlines())
            elif isinstance(item, list):
                result[key] = summarize_list(item, full_source=full_source)
            else:
                result[key] = summarize_value(item, full_source=full_source)
        return result
    if isinstance(value, list):
        return summarize_list(value, full_source=full_source)
    return value


def summarize_list(items: list[Any], *, full_source: bool) -> Any:
    if full_source or len(items) <= 20:
        return [summarize_value(item, full_source=full_source) for item in items]
    preview = [summarize_value(item, full_source=full_source) for item in items[:20]]
    return {"count": len(items), "preview": preview, "truncated": True}


def summarize_result(result: dict[str, Any], *, full_source: bool) -> dict[str, Any]:
    body = result.get("body")
    summary = {
        "status": result.get("status"),
        "http_status": result.get("http_status"),
        "endpoint": result.get("endpoint"),
        "path_info": result.get("path_info"),
        "log_dir": result.get("log_dir"),
    }
    if "payload" in result:
        summary["payload"] = result.get("payload")
    if isinstance(body, dict):
        for key in ("status", "object_type", "object_name", "domain_name", "type_name", "program", "screen", "function_name", "function_group", "class_name", "method_name", "message"):
            if key in body:
                summary[key] = body.get(key)
        summary["body"] = summarize_value(body, full_source=full_source)
    else:
        summary["body"] = body
    return {key: val for key, val in summary.items() if val is not None}


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        client = make_client(args)
        endpoint, payload, operation = endpoint_and_payload(args)
        from sap_ai_mcp_lib import new_run_dir
        result = client.call(endpoint, payload, run_dir=new_run_dir(client.log_root, operation), step="01-read", dry_run=args.dry_run)
        print(json.dumps(summarize_result(result, full_source=args.full_source), indent=2, ensure_ascii=False))
        return 0
    except SapAI_MCPError as exc:
        print(json.dumps(exc.to_dict(), indent=2, ensure_ascii=False))
        return 2


if __name__ == "__main__":
    sys.exit(main())