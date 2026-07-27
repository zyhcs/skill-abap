"""Hybrid SDK Lite core for the SAP AI MCP REST handler.

This module intentionally uses only the Python standard library so it can run in
minimal Windows AI_MCP environments.
"""

from __future__ import annotations

import base64
import copy
import datetime as _dt
import json
import os
from pathlib import Path
import re
import urllib.error
import urllib.request
from urllib.parse import urlparse

DEFAULT_BASE_URL = os.environ.get("SAP_AI_MCP_URL") or os.environ.get("SAP_URL") or "http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100"
DEFAULT_USER = os.environ.get("SAP_AI_MCP_USER") or os.environ.get("SAP_USER") or ""
DEFAULT_PASSWORD = os.environ.get("SAP_AI_MCP_PASSWORD") or os.environ.get("SAP_PASSWORD") or ""

ENDPOINTS = {
    "capabilities": {"path": "/capabilities", "mode": "read", "defaults": {}},
    "object_check": {"path": "/object/check", "mode": "check", "defaults": {}},
    "object_read": {"path": "/object/read", "mode": "read", "defaults": {"source_format": "STRING"}},
    "object_save": {"path": "/object/save", "mode": "write", "defaults": {}},
    "object_activate": {"path": "/object/activate", "mode": "write", "defaults": {}},
    "object_repair": {"path": "/object/repair", "mode": "write", "defaults": {}},
    "object_lifecycle": {"path": "/object/lifecycle", "mode": "write", "defaults": {}},
    "probe_run": {"path": "/probe/run", "mode": "check", "defaults": {}},
    "class_method_read": {"path": "/class/method/read", "mode": "read", "defaults": {"source_format": "STRING"}},
    "class_methods": {"path": "/debug/class_methods", "mode": "read", "defaults": {}},
    "debug_ddic_fields": {"path": "/debug/ddic_fields", "mode": "read", "defaults": {}},
    "debug_ddic_type": {"path": "/debug/ddic_type", "mode": "read", "defaults": {}},
    "debug_domain_values": {"path": "/debug/domain_values", "mode": "read", "defaults": {}},
    "debug_dynpro_read": {"path": "/debug/dynpro_read", "mode": "read", "defaults": {}},
    "debug_fm_interface": {"path": "/debug/fm_interface", "mode": "read", "defaults": {}},
    "debug_locks": {"path": "/debug/locks", "mode": "read", "defaults": {}},
    "ddic_validate": {"path": "/ddic/validate_names", "mode": "check", "defaults": {}},
    "ddic_create": {"path": "/ddic/create", "mode": "write", "defaults": {}},
    "ddic_status": {"path": "/ddic/status", "mode": "read", "defaults": {}},
    "ddic_domain_update_values": {"path": "/ddic/domain/update_values", "mode": "write", "defaults": {}},
    "function_read": {"path": "/function/read", "mode": "read", "defaults": {"source_format": "STRING"}},
    "function_group_read": {"path": "/function_group/read", "mode": "read", "defaults": {"source_format": "STRING"}},
    "function_create": {"path": "/function/create", "mode": "write", "defaults": {}},
    "function_check": {"path": "/function/check", "mode": "check", "defaults": {}},
    "function_source_save": {"path": "/function/source_save", "mode": "write", "defaults": {}},
    "include_source_save": {"path": "/include/source_save", "mode": "write", "defaults": {}},
    "dynpro_import_screen": {"path": "/dynpro/import_screen", "mode": "write", "defaults": {}},
    "dynpro_import_from_json": {"path": "/dynpro/import_from_json", "mode": "write", "defaults": {}},
    "dynpro_import_custom_control": {"path": "/dynpro/import_custom_control", "mode": "write", "defaults": {}},
    "dynpro_import_layout": {"path": "/dynpro/import_layout", "mode": "write", "defaults": {}},
    "transport_create": {"path": "/transport/create", "mode": "write", "defaults": {"type": "K"}},
    "table_read": {"path": "/table/read", "mode": "read", "defaults": {}},
}

PATH_TO_NAME = {spec["path"]: name for name, spec in ENDPOINTS.items()}
SAFE_RAW_PATHS = {spec["path"] for spec in ENDPOINTS.values() if spec.get("mode") in {"read", "check"}}
DANGEROUS_RAW_PATHS = {spec["path"] for spec in ENDPOINTS.values() if spec.get("mode") == "write"}
HANDLER_OBJECT_RE = re.compile(r"^ZCL_AI_MCP_REST_HANDLER", re.IGNORECASE)


class SapAI_MCPError(Exception):
    """Structured client-side error."""

    def __init__(self, reason: str, message: str, **details: object) -> None:
        super().__init__(message)
        self.reason = reason
        self.message = message
        self.details = details

    def to_dict(self) -> dict[str, object]:
        return {"status": "BLOCKED", "reason": self.reason, "message": self.message, **self.details}


def load_json_file(path: Path) -> dict[str, object]:
    raw = path.read_bytes()
    if raw.startswith(b"\xef\xbb\xbf"):
        raw = raw[3:]
    value = json.loads(raw.decode("utf-8"))
    if not isinstance(value, dict):
        raise SapAI_MCPError("INVALID_PAYLOAD", "Payload root must be a JSON object.", payload=str(path))
    return value


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False), encoding="utf-8")


def default_log_root() -> Path:
    return Path.cwd() / "work" / "sap-runs"


def new_run_dir(log_root: Path, operation: str) -> Path:
    safe = re.sub(r"[^A-Za-z0-9_.-]+", "_", operation).strip("_") or "sap"
    stamp = _dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    path = log_root / f"{stamp}-{safe}"
    path.mkdir(parents=True, exist_ok=True)
    return path


def normalize_package_transport(payload: dict[str, object]) -> dict[str, object]:
    result = copy.deepcopy(payload)
    package = str(result.get("package") or "").strip()
    transport = str(result.get("transport") or "").strip()
    if not package:
        package = "$TMP"
        result["package"] = package
    if package.upper() != "$TMP" and not transport:
        raise SapAI_MCPError(
            "TRANSPORT_REQUIRED",
            f"Package {package} requires an explicit Workbench transport.",
            package=package,
        )
    if package.upper() == "$TMP" and "transport" not in result:
        result["transport"] = ""
    return result


def endpoint_name_or_path(value: str) -> tuple[str, str, dict[str, object]]:
    if value in ENDPOINTS:
        spec = ENDPOINTS[value]
        return value, str(spec["path"]), spec
    if value in PATH_TO_NAME:
        name = PATH_TO_NAME[value]
        return name, value, ENDPOINTS[name]
    if value.startswith("/"):
        return "raw", value, {"path": value, "mode": "raw", "defaults": {}}
    raise SapAI_MCPError("UNKNOWN_ENDPOINT", f"Unknown endpoint or path: {value}", endpoint=value)


def ensure_zai_mcp_rest_base_url(base_url: str) -> None:
    path = urlparse(base_url).path.rstrip("/").lower()
    if path != "/sap/bc/zai_mcp_rest":
        raise SapAI_MCPError(
            "NON_zai_mcp_rest_BASE_URL",
            "Base URL must point to the /sap/bc/zai_mcp_rest service.",
            base_url=base_url,
        )


def ensure_raw_path_allowed(path: str, *, allow_dangerous: bool = False) -> None:
    if path in SAFE_RAW_PATHS:
        return
    if path in DANGEROUS_RAW_PATHS and allow_dangerous:
        return
    if path in DANGEROUS_RAW_PATHS:
        raise SapAI_MCPError(
            "DANGEROUS_RAW_ENDPOINT",
            f"Raw write endpoint {path} requires --allow-dangerous.",
            path_info=path,
        )
    raise SapAI_MCPError(
        "UNKNOWN_RAW_ENDPOINT",
        "Raw calls are limited to registered endpoints.",
        path_info=path,
    )


def ensure_not_handler_self_modification(endpoint: str, payload: dict[str, object]) -> None:
    name, path, spec = endpoint_name_or_path(endpoint)
    if spec.get("mode") != "write":
        return
    candidates = [
        payload.get("object_name"),
        payload.get("class_name"),
        payload.get("include"),
        payload.get("program"),
    ]
    object_type = str(payload.get("object_type") or "").upper()
    for candidate in candidates:
        value = str(candidate or "").upper()
        if value and HANDLER_OBJECT_RE.match(value):
            raise SapAI_MCPError(
                "HANDLER_SELF_MODIFICATION_BLOCKED",
                "Do not modify ZCL_AI_MCP_REST_HANDLER through its own REST service.",
                endpoint=name,
                path_info=path,
                object_type=object_type,
                object_name=value,
            )


def apply_defaults(endpoint: str, payload: dict[str, object]) -> dict[str, object]:
    _name, _path, spec = endpoint_name_or_path(endpoint)
    result = copy.deepcopy(payload)
    for key, val in dict(spec.get("defaults") or {}).items():
        result.setdefault(key, val)
    return result


def load_profiles(config_path: Path | None = None) -> dict[str, dict[str, object]]:
    if config_path is None:
        config_path = Path(__file__).resolve().parents[1] / "config" / "sap_environments.json"
    if config_path.exists():
        try:
            data = load_json_file(config_path)
            return data.get("profiles", {})
        except Exception:
            pass
    return {}


def resolve_profile_config(profile_name: str | None = None, config_path: Path | None = None) -> dict[str, object]:
    profile_name = profile_name or os.environ.get("SAP_AI_MCP_PROFILE") or os.environ.get("SAP_PROFILE") or "dev"
    profiles = load_profiles(config_path)
    profile_info = dict(profiles.get(profile_name.lower()) or {})

    base_url = (
        os.environ.get("SAP_AI_MCP_URL")
        or os.environ.get("SAP_URL")
        or profile_info.get("base_url")
        or DEFAULT_BASE_URL
    )

    user_env_key = profile_info.get("user_env")
    user = os.environ.get(str(user_env_key)) if user_env_key else None
    user = user or os.environ.get("SAP_AI_MCP_USER") or os.environ.get("SAP_USER") or profile_info.get("user") or DEFAULT_USER

    password_env_key = profile_info.get("password_env")
    password = os.environ.get(str(password_env_key)) if password_env_key else None
    password = password or os.environ.get("SAP_AI_MCP_PASSWORD") or os.environ.get("SAP_PASSWORD") or DEFAULT_PASSWORD

    allow_write = profile_info.get("allow_write")
    if allow_write is None:
        allow_write = True if profile_name.lower() == "dev" else False

    description = str(profile_info.get("description") or f"Profile '{profile_name}'")

    return {
        "profile": profile_name,
        "description": description,
        "base_url": str(base_url),
        "user": str(user),
        "password": str(password or ""),
        "allow_write": bool(allow_write),
    }


class SapAiMcpClient:
    def __init__(
        self,
        base_url: str | None = None,
        user: str | None = None,
        password: str | None = None,
        log_root: Path | None = None,
        no_proxy: bool = True,
        timeout: int = 60,
        allow_dangerous: bool = False,
        profile: str | None = None,
        allow_write: bool | None = None,
    ) -> None:
        p_cfg = resolve_profile_config(profile)
        self.profile = p_cfg["profile"]
        self.profile_description = p_cfg["description"]
        self.base_url = base_url or os.getenv("SAP_AI_MCP_URL") or os.getenv("SAP_URL") or str(p_cfg["base_url"])
        ensure_zai_mcp_rest_base_url(self.base_url)
        self.user = user or os.getenv("SAP_AI_MCP_USER") or os.getenv("SAP_USER") or str(p_cfg["user"])
        self.password = password if password is not None else (os.getenv("SAP_AI_MCP_PASSWORD") or os.getenv("SAP_PASSWORD") or str(p_cfg["password"]))
        self.allow_write = allow_write if allow_write is not None else bool(p_cfg["allow_write"])
        self.log_root = log_root or default_log_root()
        self.no_proxy = no_proxy
        self.timeout = timeout
        self.allow_dangerous = allow_dangerous
        self._opener = urllib.request.build_opener(urllib.request.ProxyHandler({})) if no_proxy else urllib.request.build_opener()

    def _auth_header(self) -> str:
        if not self.password:
            raise SapAI_MCPError("PASSWORD_REQUIRED", "SAP password is required via SAP_AI_MCP_PASSWORD, --password, or --userpass.")
        token = base64.b64encode(f"{self.user}:{self.password}".encode("utf-8")).decode("ascii")
        return f"Basic {token}"

    def ensure_write_allowed(self, endpoint: str) -> None:
        name, path, spec = endpoint_name_or_path(endpoint)
        if spec.get("mode") == "write" and not self.allow_write:
            raise SapAI_MCPError(
                "ENVIRONMENT_WRITE_FORBIDDEN",
                f"Write operation '{name}' ({path}) is forbidden in profile '{self.profile}' [{self.profile_description}]. Current profile is read-only.",
                profile=self.profile,
                endpoint=name,
                path_info=path,
            )

    def call(
        self,
        endpoint: str,
        payload: dict[str, object] | None = None,
        *,
        run_dir: Path | None = None,
        step: str = "call",
        dry_run: bool = False,
    ) -> dict[str, object]:
        name, path, _spec = endpoint_name_or_path(endpoint)
        self.ensure_write_allowed(endpoint)
        if endpoint.startswith("/") or step == "call":
            ensure_raw_path_allowed(path, allow_dangerous=self.allow_dangerous)
        body = apply_defaults(endpoint, payload or {})
        ensure_not_handler_self_modification(endpoint, body)
        run_dir = run_dir or new_run_dir(self.log_root, name)
        request_meta = {
            "endpoint": name,
            "path_info": path,
            "base_url": self.base_url,
            "user": self.user,
            "dry_run": dry_run,
        }
        write_json(run_dir / f"{step}.request.json", {"meta": request_meta, "payload": body})

        if dry_run:
            result = {"status": "DRY_RUN", "endpoint": name, "path_info": path, "payload": body, "log_dir": str(run_dir)}
            write_json(run_dir / f"{step}.response.json", result)
            return result

        raw = json.dumps(body, ensure_ascii=False).encode("utf-8")
        req = urllib.request.Request(
            self.base_url,
            data=raw,
            method="POST",
            headers={
                "Authorization": self._auth_header(),
                "PATH_INFO": path,
                "Content-Type": "application/json; charset=utf-8",
            },
        )
        try:
            with self._opener.open(req, timeout=self.timeout) as resp:
                text = resp.read().decode("utf-8", errors="replace")
                http_status = resp.status
        except urllib.error.HTTPError as exc:
            text = exc.read().decode("utf-8", errors="replace")
            http_status = exc.code

        try:
            parsed: object = json.loads(text)
        except json.JSONDecodeError:
            parsed = {"raw": text}

        result = {"http_status": http_status, "endpoint": name, "path_info": path, "body": parsed, "log_dir": str(run_dir)}
        (run_dir / f"{step}.raw.txt").write_text(text, encoding="utf-8")
        write_json(run_dir / f"{step}.response.json", result)
        return result

    def capabilities(self, *, dry_run: bool = False) -> dict[str, object]:
        return self.call("capabilities", {}, run_dir=new_run_dir(self.log_root, "capabilities"), step="01-capabilities", dry_run=dry_run)

    def read_method(self, class_name: str, method_name: str, *, version: str | None = None, dry_run: bool = False) -> dict[str, object]:
        run_dir = new_run_dir(self.log_root, f"read-method-{class_name}-{method_name}")
        payload = {"class_name": class_name.upper(), "method_name": method_name.upper(), "source_format": "STRING"}
        if version:
            payload["version"] = version.upper()
        result = self.call("class_method_read", payload, run_dir=run_dir, step="01-class-method-read", dry_run=dry_run)
        return summarize_source_result(result, object_name=f"{class_name.upper()}=>{method_name.upper()}")

    def read_class(self, class_name: str, *, dry_run: bool = False) -> dict[str, object]:
        run_dir = new_run_dir(self.log_root, f"read-class-{class_name}")
        payload = {"object_type": "CLAS", "object_name": class_name.upper(), "source_format": "STRING"}
        result = self.call("object_read", payload, run_dir=run_dir, step="01-object-read-clas", dry_run=dry_run)
        return summarize_source_result(result, object_name=class_name.upper())

    def class_activation_check(self, class_name: str, *, dry_run: bool = False) -> dict[str, object]:
        run_dir = new_run_dir(self.log_root, f"class-activation-check-{class_name}")
        payload = {"probe_id": "CLASS_ACTIVATION_CHECK", "class_name": class_name.upper()}
        return self.call("probe_run", payload, run_dir=run_dir, step="01-probe-class-activation-check", dry_run=dry_run)

    def repair_class_method(
        self,
        payload: dict[str, object],
        *,
        dry_run: bool = False,
    ) -> dict[str, object]:
        run_dir = new_run_dir(self.log_root, "class-method-repair")
        repair_payload = copy.deepcopy(payload)
        repair_payload.setdefault("object_type", "CLAS")
        return self.call("object_repair", repair_payload, run_dir=run_dir, step="01-object_repair", dry_run=dry_run)

    def read_report(self, report_name: str, *, dry_run: bool = False) -> dict[str, object]:
        run_dir = new_run_dir(self.log_root, f"read-report-{report_name}")
        payload = {"object_type": "PROG", "object_name": report_name.upper(), "source_format": "STRING"}
        result = self.call("object_read", payload, run_dir=run_dir, step="01-object-read-prog", dry_run=dry_run)
        return summarize_source_result(result, object_name=report_name.upper())

    def read_function(self, function_name: str, *, dry_run: bool = False) -> dict[str, object]:
        function_name = function_name.upper()
        run_dir = new_run_dir(self.log_root, f"read-function-{function_name}")
        payload = {"function_name": function_name, "source_format": "STRING"}
        result = self.call("function_read", payload, run_dir=run_dir, step="01-function-read", dry_run=dry_run)
        summary = summarize_source_result(result, object_name=function_name)
        body = result.get("body")
        if isinstance(body, dict):
            summary["function_group"] = body.get("function_group")
            summary["program"] = body.get("program")
            syntax = body.get("syntax")
            if isinstance(syntax, dict):
                summary["syntax_status"] = syntax.get("status")
        return {k: v for k, v in summary.items() if v is not None}

    def read_function_group(self, function_group: str, *, dry_run: bool = False) -> dict[str, object]:
        function_group = function_group.upper()
        run_dir = new_run_dir(self.log_root, f"read-function-group-{function_group}")
        payload = {"function_group": function_group, "source_format": "STRING"}
        result = self.call("function_group_read", payload, run_dir=run_dir, step="01-function-group-read", dry_run=dry_run)
        summary = summarize_source_result(result, object_name=function_group)
        body = result.get("body")
        if isinstance(body, dict):
            summary["program"] = body.get("program")
            syntax = body.get("syntax")
            if isinstance(syntax, dict):
                summary["syntax_status"] = syntax.get("status")
            includes = body.get("includes")
            if isinstance(includes, list):
                include_summaries = []
                for item in includes:
                    if isinstance(item, dict):
                        include_summaries.append({
                            "include": item.get("include"),
                            "status": item.get("status"),
                            "line_count": item.get("line_count"),
                        })
                summary["includes"] = include_summaries
                summary["include_count"] = len(include_summaries)
        return {k: v for k, v in summary.items() if v is not None}


def sap_status(result: dict[str, object]) -> str:
    body = result.get("body")
    if isinstance(body, dict):
        return str(body.get("status") or body.get("state") or "")
    return ""


def ensure_ok(result: dict[str, object], step: str) -> None:
    http_status = int(result.get("http_status") or 200)
    status = sap_status(result).upper()
    if http_status < 200 or http_status >= 300 or status in {"ERROR", "FAILED", "FAIL"}:
        raise SapAI_MCPError("SAP_STEP_FAILED", f"SAP step failed: {step}", step=step, result=result)


def summarize_source_result(result: dict[str, object], *, object_name: str) -> dict[str, object]:
    body = result.get("body")
    if not isinstance(body, dict):
        return result
    source_code = body.get("source_code")
    summary = {
        "status": body.get("status", "OK" if result.get("status") == "DRY_RUN" else None),
        "object": object_name,
        "endpoint": result.get("path_info"),
        "include": body.get("include"),
        "line_count": body.get("line_count"),
        "non_empty_line_count": body.get("non_empty_line_count"),
        "source_format": body.get("source_format", "STRING"),
        "log_dir": result.get("log_dir"),
    }
    if isinstance(source_code, str):
        summary["source_code"] = source_code
    elif result.get("status") == "DRY_RUN":
        summary["source_code"] = ""
    return {k: v for k, v in summary.items() if v is not None}


def strip_function_wrapper(source_code: str) -> str:
    lines = source_code.splitlines()
    if not lines:
        return source_code
    first = lines[0].strip().upper()
    last_index = len(lines) - 1
    while last_index >= 0 and not lines[last_index].strip():
        last_index -= 1
    last = lines[last_index].strip().upper() if last_index >= 0 else ""
    if first.startswith("FUNCTION ") and last == "ENDFUNCTION.":
        return "\n".join(lines[1:last_index]).strip("\n")
    return source_code


def ensure_function_wrapper(function_name: str, source_code: str) -> str:
    stripped = source_code.strip()
    if stripped.upper().startswith("FUNCTION "):
        return source_code
    body = stripped
    return "\n".join([
        f"FUNCTION {function_name.upper()}.",
        '*"----------------------------------------------------------------------',
        '*"*\"Local Interface:',
        '*"----------------------------------------------------------------------',
        body,
        "ENDFUNCTION.",
    ])


def ddic_deploy(client: SapAiMcpClient, payload: dict[str, object], *, dry_run: bool = False) -> dict[str, object]:
    run_dir = new_run_dir(client.log_root, "ddic-deploy")
    payload = normalize_package_transport(payload)
    steps: list[dict[str, object]] = []
    for idx, endpoint in enumerate(["ddic_validate", "ddic_create", "ddic_status"], start=1):
        result = client.call(endpoint, payload, run_dir=run_dir, step=f"{idx:02d}-{endpoint}", dry_run=dry_run)
        steps.append({"step": endpoint, "result": result})
        if not dry_run:
            ensure_ok(result, endpoint)
    summary = {"status": "DRY_RUN" if dry_run else "OK", "workflow": "ddic deploy", "steps": [s["step"] for s in steps], "log_dir": str(run_dir)}
    write_json(run_dir / "summary.json", summary)
    return summary


def report_deploy(client: SapAiMcpClient, payload: dict[str, object], *, dry_run: bool = False) -> dict[str, object]:
    run_dir = new_run_dir(client.log_root, "report-deploy")
    payload = normalize_package_transport(payload)
    payload.setdefault("object_type", "PROG")
    steps: list[str] = []
    for idx, endpoint in enumerate(["object_check", "object_save"], start=1):
        result = client.call(endpoint, payload, run_dir=run_dir, step=f"{idx:02d}-{endpoint}", dry_run=dry_run)
        steps.append(endpoint)
        if not dry_run:
            ensure_ok(result, endpoint)
    activate_payload = {"object_type": "PROG", "object_name": payload.get("object_name")}
    result = client.call("object_activate", activate_payload, run_dir=run_dir, step="03-object_activate", dry_run=dry_run)
    steps.append("object_activate")
    if not dry_run:
        ensure_ok(result, "object_activate")
    summary = {"status": "DRY_RUN" if dry_run else "OK", "workflow": "report deploy", "object_name": payload.get("object_name"), "steps": steps, "log_dir": str(run_dir)}
    write_json(run_dir / "summary.json", summary)
    return summary


def class_deploy(client: SapAiMcpClient, payload: dict[str, object], *, dry_run: bool = False) -> dict[str, object]:
    run_dir = new_run_dir(client.log_root, "class-deploy")
    payload = normalize_package_transport(payload)
    payload.setdefault("object_type", "CLAS")
    steps: list[str] = []
    for idx, endpoint in enumerate(["object_save", "object_activate"], start=1):
        step = f"{idx:02d}-{endpoint}"
        call_payload = payload if endpoint == "object_save" else {"object_type": "CLAS", "object_name": payload.get("object_name")}
        result = client.call(endpoint, call_payload, run_dir=run_dir, step=step, dry_run=dry_run)
        steps.append(endpoint)
        if not dry_run:
            ensure_ok(result, endpoint)
    method_payload = {"class_name": payload.get("object_name")}
    result = client.call("class_methods", method_payload, run_dir=run_dir, step="03-class_methods", dry_run=dry_run)
    steps.append("class_methods")
    summary = {"status": "DRY_RUN" if dry_run else "OK", "workflow": "class deploy", "object_name": payload.get("object_name"), "steps": steps, "log_dir": str(run_dir)}
    write_json(run_dir / "summary.json", summary)
    return summary


def function_deploy(client: SapAiMcpClient, payload: dict[str, object], *, dry_run: bool = False) -> dict[str, object]:
    run_dir = new_run_dir(client.log_root, "function-deploy")
    payload = normalize_package_transport(payload)
    function_name = str(payload.get("function_name") or "").upper()
    group_name = str(payload.get("function_group") or "").upper()
    if not group_name.startswith("ZSDG_"):
        raise SapAI_MCPError("INVALID_FUNCTION_GROUP", "Function group must use ZSDG_*.", function_group=group_name)
    if not function_name.startswith("ZSDF_"):
        raise SapAI_MCPError("INVALID_FUNCTION_NAME", "Function module must use ZSDF_*.", function_name=function_name)
    source_code = payload.get("source_code")
    if isinstance(source_code, str):
        payload["source_code"] = strip_function_wrapper(source_code)
    create_result = client.call("function_create", payload, run_dir=run_dir, step="01-function_create", dry_run=dry_run)
    if not dry_run:
        ensure_ok(create_result, "function_create")
    check_payload = {"function_name": function_name}
    check_result = client.call("function_check", check_payload, run_dir=run_dir, step="02-function_check", dry_run=dry_run)
    if not dry_run:
        ensure_ok(check_result, "function_check")
    summary = {"status": "DRY_RUN" if dry_run else "OK", "workflow": "function deploy", "function_name": function_name, "steps": ["function_create", "function_check"], "log_dir": str(run_dir)}
    write_json(run_dir / "summary.json", summary)
    return summary


def function_check(client: SapAiMcpClient, function_name: str, *, dry_run: bool = False) -> dict[str, object]:
    run_dir = new_run_dir(client.log_root, f"function-check-{function_name}")
    payload = {"function_name": function_name.upper()}
    return client.call("function_check", payload, run_dir=run_dir, step="01-function_check", dry_run=dry_run)


def function_repair(client: SapAiMcpClient, payload: dict[str, object], *, dry_run: bool = False) -> dict[str, object]:
    run_dir = new_run_dir(client.log_root, "function-repair")
    function_name = str(payload.get("function_name") or "").upper()
    source_code = payload.get("source_code")
    if not function_name:
        raise SapAI_MCPError("FUNCTION_NAME_REQUIRED", "function_name is required for function repair.")
    if not isinstance(source_code, str) or not source_code.strip():
        raise SapAI_MCPError("SOURCE_CODE_REQUIRED", "function repair requires caller-provided source_code.")
    full_source = ensure_function_wrapper(function_name, source_code)
    save_result = client.call("function_source_save", {"function_name": function_name, "source_code": full_source}, run_dir=run_dir, step="01-function_source_save", dry_run=dry_run)
    if not dry_run:
        ensure_ok(save_result, "function_source_save")
    check_result = client.call("function_check", {"function_name": function_name}, run_dir=run_dir, step="02-function_check", dry_run=dry_run)
    if not dry_run:
        ensure_ok(check_result, "function_check")
    summary = {"status": "DRY_RUN" if dry_run else "OK", "workflow": "function repair", "function_name": function_name, "steps": ["function_source_save", "function_check"], "log_dir": str(run_dir)}
    write_json(run_dir / "summary.json", summary)
    return summary


def class_method_repair(client: SapAiMcpClient, payload: dict[str, object], *, dry_run: bool = False) -> dict[str, object]:
    object_name = str(payload.get("object_name") or payload.get("class_name") or "").upper()
    source_code = payload.get("source_code")
    target = payload.get("target")
    target_name = ""
    if isinstance(target, dict):
        target_name = str(target.get("name") or "").upper()
    target_name = target_name or str(payload.get("target_name") or payload.get("method_name") or "").upper()
    if not object_name:
        raise SapAI_MCPError("CLASS_NAME_REQUIRED", "object_name or class_name is required for class method repair.")
    if not target_name:
        raise SapAI_MCPError("METHOD_NAME_REQUIRED", "target.name, target_name, or method_name is required for class method repair.")
    if not isinstance(source_code, str) or not source_code.strip():
        raise SapAI_MCPError("SOURCE_CODE_REQUIRED", "class method repair requires caller-provided method body source_code.")

    repair_payload = copy.deepcopy(payload)
    repair_payload["object_type"] = "CLAS"
    repair_payload["object_name"] = object_name
    if not isinstance(repair_payload.get("target"), dict):
        repair_payload["target"] = {}
    repair_target = repair_payload["target"]
    assert isinstance(repair_target, dict)
    repair_target.setdefault("kind", repair_payload.pop("target_kind", "METHOD"))
    repair_target.setdefault("name", repair_payload.pop("target_name", target_name))
    repair_target.setdefault("version", repair_payload.pop("target_version", "INACTIVE"))
    repair_payload.pop("class_name", None)
    repair_payload.pop("method_name", None)
    repair_payload.setdefault("check_after_save", True)
    repair_payload.setdefault("activate_after_check", False)

    result = client.repair_class_method(repair_payload, dry_run=dry_run)
    body = result.get("body")
    summary = {
        "status": "DRY_RUN" if dry_run else (body.get("status") if isinstance(body, dict) else None),
        "workflow": "class method repair",
        "class_name": object_name,
        "method_name": target_name,
        "target_version": repair_target.get("version"),
        "endpoint": result.get("path_info"),
        "log_dir": result.get("log_dir"),
    }
    if isinstance(body, dict):
        summary["save"] = body.get("save")
        check = body.get("check")
        if isinstance(check, dict):
            summary["check_status"] = check.get("status")
            summary["check_message_count"] = check.get("message_count")
            summary["check_messages"] = check.get("messages")
        activate = body.get("activate")
        if isinstance(activate, dict):
            summary["activate_status"] = activate.get("status")
    return {k: v for k, v in summary.items() if v is not None}


