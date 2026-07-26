#!/usr/bin/env python3
"""Smoke tests for SAP AI MCP Hybrid SDK Lite.

These tests avoid live SAP calls by using --dry-run and client-side validation.
"""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CLIENT = ROOT / "scripts" / "sap_ai_mcp_client.py"
WORK = Path.cwd() / "work" / "sap-client-smoke"
WORK.mkdir(parents=True, exist_ok=True)


def run(*args: str) -> tuple[int, dict]:
    proc = subprocess.run([sys.executable, str(CLIENT), *args], text=True, capture_output=True)
    try:
        data = json.loads(proc.stdout)
    except json.JSONDecodeError:
        data = {"stdout": proc.stdout, "stderr": proc.stderr}
    return proc.returncode, data


def write_payload(name: str, payload: dict) -> Path:
    path = WORK / name
    path.write_text(json.dumps(payload), encoding="utf-8")
    return path


def main() -> int:
    rc, data = run("--dry-run", "read", "method", "ZCLSD_LGSCRO_CONTACT_IMPORT", "SUBMIT_DATA")
    assert rc == 0, data
    assert data["status"] == "DRY_RUN", data

    rc, data = run("--dry-run", "read", "function", "ZSDF_SO_SAVE_OVERVIEW")
    assert rc == 0, data
    assert data["status"] == "DRY_RUN", data

    rc, data = run("--dry-run", "read", "function-group", "ZSDG_0007")
    assert rc == 0, data
    assert data["status"] == "DRY_RUN", data

    payload = write_payload("transport_required.json", {"package": "ZPKG", "transport": "", "domains": [], "data_elements": [], "tables": []})
    rc, data = run("--dry-run", "ddic", "deploy", str(payload))
    assert rc == 2, data
    assert data["reason"] == "TRANSPORT_REQUIRED", data

    payload = write_payload("report.json", {"object_name": "ZSDRPAI_MCP_SMOKE", "source_code": "REPORT zsdrpAI_MCP_smoke."})
    rc, data = run("--dry-run", "report", "deploy", str(payload))
    assert rc == 0, data
    assert data["workflow"] == "report deploy", data
    assert data["status"] == "DRY_RUN", data

    payload = write_payload("function_full_create.json", {
        "function_group": "ZSDG_SMOKE",
        "function_name": "ZSDF_SMOKE",
        "package": "$TMP",
        "transport": "",
        "source_code": "FUNCTION zsdf_smoke.\nDATA lv_dummy TYPE i.\nENDFUNCTION.",
        "importing": [],
        "exporting": [],
        "changing": [],
        "tables": [],
    })
    rc, data = run("--dry-run", "function", "deploy", str(payload))
    assert rc == 0, data
    request = json.loads((Path(data["log_dir"]) / "01-function_create.request.json").read_text(encoding="utf-8"))
    assert not request["payload"]["source_code"].strip().upper().startswith("FUNCTION "), request
    assert request["payload"]["source_code"].strip().upper() == "DATA LV_DUMMY TYPE I.", request

    payload = write_payload("function_body_repair.json", {
        "function_name": "ZSDF_SMOKE",
        "source_code": "DATA lv_dummy TYPE i.",
    })
    rc, data = run("--dry-run", "function", "repair", str(payload))
    assert rc == 0, data
    request = json.loads((Path(data["log_dir"]) / "01-function_source_save.request.json").read_text(encoding="utf-8"))
    assert request["payload"]["source_code"].strip().upper().startswith("FUNCTION ZSDF_SMOKE."), request
    assert request["payload"]["source_code"].strip().upper().endswith("ENDFUNCTION."), request

    payload = write_payload("empty.json", {})
    rc, data = run("--base-url", "http://<your-sap-host>:<port>/sap/bc/adt?sap-client=100", "--dry-run", "capabilities")
    assert rc == 2, data
    assert data["reason"] == "NON_zai_mcp_rest_BASE_URL", data

    rc, data = run("--dry-run", "call", "/object/read", str(payload))
    assert rc == 0, data
    assert data["status"] == "DRY_RUN", data

    rc, data = run("--dry-run", "call", "/object/save", str(payload))
    assert rc == 2, data
    assert data["reason"] == "DANGEROUS_RAW_ENDPOINT", data

    rc, data = run("--dry-run", "call", "object_save", str(payload))
    assert rc == 2, data
    assert data["reason"] == "DANGEROUS_RAW_ENDPOINT", data

    payload = write_payload("standalone_include_save.json", {
        "object_type": "PROG",
        "object_name": "ZSDRP_AI_MCP_SMOKE_TOP",
        "package": "$TMP",
        "transport": "",
        "program_type": "I",
        "subc": "I",
        "source_code": "*& Include ZSDRP_AI_MCP_SMOKE_TOP",
    })
    rc, data = run("--allow-dangerous", "--dry-run", "call", "object_save", str(payload))
    assert rc == 0, data
    request = json.loads((Path(data["log_dir"]) / "call.request.json").read_text(encoding="utf-8"))
    assert request["payload"]["program_type"] == "I", request
    assert request["payload"]["subc"] == "I", request

    rc, data = run("--allow-dangerous", "--dry-run", "call", "/sap/bc/adt", str(payload))
    assert rc == 2, data
    assert data["reason"] == "UNKNOWN_RAW_ENDPOINT", data

    payload = write_payload("handler_save.json", {"object_type": "CLAS", "object_name": "ZCL_AI_MCP_REST_HANDLER", "source_code": "CLASS ZCL_AI_MCP_REST_HANDLER DEFINITION. ENDCLASS."})
    rc, data = run("--dry-run", "class", "deploy", str(payload))
    assert rc == 2, data
    assert data["reason"] == "HANDLER_SELF_MODIFICATION_BLOCKED", data

    print("contract smoke OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
