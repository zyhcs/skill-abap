#!/usr/bin/env python3
"""Call the SAP AI MCP REST handler with stable payload and logging behavior."""

from __future__ import annotations

import argparse
import base64
import datetime as _dt
import json
import os
from pathlib import Path
import sys
import urllib.error
import urllib.request
from urllib.parse import urlparse

DEFAULT_BASE_URL = os.environ.get("SAP_AI_MCP_URL") or os.environ.get("SAP_URL") or "http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100"
DEFAULT_USER = os.environ.get("SAP_AI_MCP_USER") or os.environ.get("SAP_USER") or ""
DEFAULT_PASSWORD = os.environ.get("SAP_AI_MCP_PASSWORD") or os.environ.get("SAP_PASSWORD") or ""


def read_payload(path: Path) -> bytes:
    data = path.read_bytes()
    if data.startswith(b"\xef\xbb\xbf"):
        data = data[3:]
    json.loads(data.decode("utf-8"))
    return data


def default_log_dir() -> Path:
    return Path.cwd() / "work" / "sap-runs"


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False), encoding="utf-8")


def call(base_url: str, path_info: str, payload: bytes, user: str, password: str, timeout: int) -> tuple[int, str, object]:
    token = base64.b64encode(f"{user}:{password}".encode("utf-8")).decode("ascii")
    req = urllib.request.Request(
        base_url,
        data=payload,
        method="POST",
        headers={
            "Authorization": f"Basic {token}",
            "PATH_INFO": path_info,
            "Content-Type": "application/json; charset=utf-8",
        },
    )
    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
    try:
        with opener.open(req, timeout=timeout) as resp:
            text = resp.read().decode("utf-8", errors="replace")
            status = resp.status
    except urllib.error.HTTPError as exc:
        text = exc.read().decode("utf-8", errors="replace")
        status = exc.code

    try:
        parsed: object = json.loads(text)
    except json.JSONDecodeError:
        parsed = {"raw": text}
    return status, text, parsed


def ensure_zai_mcp_rest_base_url(base_url: str) -> None:
    path = urlparse(base_url).path.rstrip("/").lower()
    if path != "/sap/bc/zai_mcp_rest":
        raise ValueError("Base URL must point to the /sap/bc/zai_mcp_rest service.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Call SAP AI MCP REST using PATH_INFO routing.")
    parser.add_argument("--path", required=True, help="Logical PATH_INFO route, for example /object/check")
    parser.add_argument("--payload", required=True, type=Path, help="JSON payload file")
    parser.add_argument("--base-url", default=os.getenv("sap_ai_mcp_BASE_URL", DEFAULT_BASE_URL))
    parser.add_argument("--user", default=os.getenv("sap_ai_mcp_USER", DEFAULT_USER))
    parser.add_argument("--password", default=os.getenv("sap_ai_mcp_PASSWORD"))
    parser.add_argument("--userpass", help="user:password override for one-off local calls")
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--log-dir", type=Path, default=default_log_dir())
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    if args.userpass:
        if ":" not in args.userpass:
            parser.error("--userpass must be in user:password form")
        args.user, args.password = args.userpass.split(":", 1)

    try:
        ensure_zai_mcp_rest_base_url(args.base_url)
    except ValueError as exc:
        parser.error(str(exc))

    payload = read_payload(args.payload)
    timestamp = _dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    run_dir = args.log_dir / timestamp
    run_dir.mkdir(parents=True, exist_ok=True)

    request_meta = {
        "base_url": args.base_url,
        "path_info": args.path,
        "payload_file": str(args.payload.resolve()),
        "user": args.user,
        "dry_run": args.dry_run,
    }
    write_json(run_dir / "request.json", request_meta)
    (run_dir / "payload.json").write_bytes(payload)

    if args.dry_run:
        print(json.dumps({"status": "DRY_RUN", "request": request_meta, "log_dir": str(run_dir)}, indent=2, ensure_ascii=False))
        return 0

    if not args.password:
        parser.error("SAP password is required via sap_ai_mcp_PASSWORD or --userpass")

    status, raw_text, parsed = call(args.base_url, args.path, payload, args.user, args.password, args.timeout)
    (run_dir / "response.raw.txt").write_text(raw_text, encoding="utf-8")
    result = {"http_status": status, "body": parsed, "log_dir": str(run_dir)}
    write_json(run_dir / "response.json", result)
    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 0 if 200 <= status < 300 else 1


if __name__ == "__main__":
    sys.exit(main())

