#!/usr/bin/env python3
"""CLI entrypoint for SAP AI MCP Hybrid SDK Lite."""

from __future__ import annotations

import argparse
import getpass
import json
from pathlib import Path
import sys

from sap_ai_mcp_lib import (
    SapAiMcpClient,
    SapAI_MCPError,
    class_deploy,
    ddic_deploy,
    function_check,
    function_deploy,
    function_repair,
    class_method_repair,
    load_json_file,
    report_deploy,
)


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
        allow_dangerous=args.allow_dangerous,
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
    parser.add_argument("--allow-dangerous", action="store_true", help="Allow raw write endpoints. Normal workflows do not need this.")
    parser.add_argument("--full-source", action="store_true", help="Print full source_code for read commands; default output keeps only summary and log path.")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="SAP AI MCP REST client.")
    add_common(parser)
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("capabilities")

    call = sub.add_parser("call")
    call.add_argument("endpoint")
    call.add_argument("payload", type=Path)

    read = sub.add_parser("read")
    read_sub = read.add_subparsers(dest="read_type", required=True)
    read_method = read_sub.add_parser("method")
    read_method.add_argument("class_name")
    read_method.add_argument("method_name")
    read_method.add_argument("--version", choices=["ACTIVE", "INACTIVE", "BOTH", "A", "I", "ALL"])
    read_class = read_sub.add_parser("class")
    read_class.add_argument("class_name")
    read_report = read_sub.add_parser("report")
    read_report.add_argument("report_name")
    read_function = read_sub.add_parser("function")
    read_function.add_argument("function_name")
    read_function_group = read_sub.add_parser("function-group")
    read_function_group.add_argument("function_group")

    ddic = sub.add_parser("ddic")
    ddic_sub = ddic.add_subparsers(dest="action", required=True)
    ddic_deploy_parser = ddic_sub.add_parser("deploy")
    ddic_deploy_parser.add_argument("payload", type=Path)

    report = sub.add_parser("report")
    report_sub = report.add_subparsers(dest="action", required=True)
    report_deploy_parser = report_sub.add_parser("deploy")
    report_deploy_parser.add_argument("payload", type=Path)

    cls = sub.add_parser("class")
    class_sub = cls.add_subparsers(dest="action", required=True)
    class_deploy_parser = class_sub.add_parser("deploy")
    class_deploy_parser.add_argument("payload", type=Path)
    class_activation_check_parser = class_sub.add_parser("activation-check")
    class_activation_check_parser.add_argument("class_name")
    class_repair_method_parser = class_sub.add_parser("repair-method")
    class_repair_method_parser.add_argument("payload", type=Path)

    func = sub.add_parser("function")
    func_sub = func.add_subparsers(dest="action", required=True)
    function_deploy_parser = func_sub.add_parser("deploy")
    function_deploy_parser.add_argument("payload", type=Path)
    function_check_parser = func_sub.add_parser("check")
    function_check_parser.add_argument("function_name")
    function_repair_parser = func_sub.add_parser("repair")
    function_repair_parser.add_argument("payload", type=Path)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        client = make_client(args)
        if args.command == "capabilities":
            result = client.capabilities(dry_run=args.dry_run)
        elif args.command == "call":
            result = client.call(args.endpoint, load_json_file(args.payload), dry_run=args.dry_run)
        elif args.command == "read" and args.read_type == "method":
            result = client.read_method(args.class_name, args.method_name, version=args.version, dry_run=args.dry_run)
            if not args.full_source:
                if "source_code" in result:
                    result["source_length"] = len(result["source_code"])
                    result.pop("source_code", None)
        elif args.command == "read" and args.read_type == "class":
            result = client.read_class(args.class_name, dry_run=args.dry_run)
            if not args.full_source:
                if "source_code" in result:
                    result["source_length"] = len(result["source_code"])
                    result.pop("source_code", None)
        elif args.command == "read" and args.read_type == "report":
            result = client.read_report(args.report_name, dry_run=args.dry_run)
            if not args.full_source:
                if "source_code" in result:
                    result["source_length"] = len(result["source_code"])
                    result.pop("source_code", None)
        elif args.command == "read" and args.read_type == "function":
            result = client.read_function(args.function_name, dry_run=args.dry_run)
            if not args.full_source:
                if "source_code" in result:
                    result["source_length"] = len(result["source_code"])
                    result.pop("source_code", None)
        elif args.command == "read" and args.read_type == "function-group":
            result = client.read_function_group(args.function_group, dry_run=args.dry_run)
            if not args.full_source:
                if "source_code" in result:
                    result["source_length"] = len(result["source_code"])
                    result.pop("source_code", None)
        elif args.command == "ddic" and args.action == "deploy":
            result = ddic_deploy(client, load_json_file(args.payload), dry_run=args.dry_run)
        elif args.command == "report" and args.action == "deploy":
            result = report_deploy(client, load_json_file(args.payload), dry_run=args.dry_run)
        elif args.command == "class" and args.action == "deploy":
            result = class_deploy(client, load_json_file(args.payload), dry_run=args.dry_run)
        elif args.command == "class" and args.action == "activation-check":
            result = client.class_activation_check(args.class_name, dry_run=args.dry_run)
        elif args.command == "class" and args.action == "repair-method":
            result = class_method_repair(client, load_json_file(args.payload), dry_run=args.dry_run)
        elif args.command == "function" and args.action == "deploy":
            result = function_deploy(client, load_json_file(args.payload), dry_run=args.dry_run)
        elif args.command == "function" and args.action == "check":
            result = function_check(client, args.function_name, dry_run=args.dry_run)
        elif args.command == "function" and args.action == "repair":
            result = function_repair(client, load_json_file(args.payload), dry_run=args.dry_run)
        else:
            parser.error("Unsupported command.")
            return 2
        print(json.dumps(result, indent=2, ensure_ascii=False))
        return 0
    except SapAI_MCPError as exc:
        print(json.dumps(exc.to_dict(), indent=2, ensure_ascii=False))
        return 2


if __name__ == "__main__":
    sys.exit(main())
