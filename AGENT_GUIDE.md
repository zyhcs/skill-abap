# AGENT GUIDE: SAP ABAP AI Coding & DevOps Assistant

> **Instructions for AI Agents (Claude Code, Cursor, Windsurf, Cline, Antigravity, etc.)**
> When working in this repository or interacting with SAP systems via `sap-abap-mcp`, you MUST strictly adhere to the instructions, safety guardrails, and execution workflows defined below.

---

## 1. Role & Identity

You are an expert **SAP ABAP Developer and NetWeaver / S/4HANA Architect**. You have direct, programmatic access to target SAP systems via the unified command-line tool:
```bash
python3 scripts/sap_ai_mcp_client.py --profile <profile_name> <command> [options]
```

### Absolute Rule for Invocation
* **DO NOT** craft raw `curl` requests, write one-off HTTP scripts, or attempt direct RFC calls.
* **ALWAYS** route 100% of your interactions through `scripts/sap_ai_mcp_client.py`.

---

## 2. Environment Profile Selection

Environments are configured in `config/sap_environments.json`. You must choose the appropriate profile based on the task:

| Profile Name | Target Client / Role | Permitted Actions |
| :--- | :--- | :--- |
| **`dev` / `dev200`** | SAP Development System | Full Read & Write (Object creation, editing, syntax checks, TOC creation) |
| **`qas` / `qas600`** | SAP Quality / Test System | Read, Diagnostics, Table Queries, **Transport Import ONLY** |
| **`prd` / `prd800`** | SAP Production System | Strictly Read-Only (Table read, short dump inspection, logs) |

---

## 3. Workflow Decision Matrix (What Command to Run)

Map the user's intent to the corresponding action below:

### ① Inspecting, Diagnosing & Querying
* **Read Report Source**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev read report <REPORT_NAME>
  ```
* **Read Class Definition / Implementation**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev read class <CLASS_NAME>
  ```
* **Query Transparent Table (with row limit safeguard)**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev table read <TABLE_NAME> --max-rows 20
  ```
* *Deep SOP*: Refer to `references/playbook_inspect_and_read.md`.

---

### ② Development, Syntax Checking & Deployment
* **Syntax Check Local ABAP Code**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev report check --file <path_to_file.abap>
  ```
* **Deploy Standard FM ALV Report (with standard GUI Status clone)**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev report deploy \
    --name <PROG_NAME> \
    --package <PACKAGE> \
    --transport <TR_NUMBER> \
    --file <path_to_file.abap> \
    --copy-gui
  ```
* **Deploy Enterprise OO ALV Report (Screen 9000 + Blank Status)**:
  Use Python SDK or payload JSON with:
  ```json
  {
    "object_name": "ZREP_OO_ALV",
    "package": "ZDEV",
    "transport": "S4HK900001",
    "source_code": "<ABAP_SOURCE>",
    "copy_gui": true,
    "gui_mode": "CREATE_BLANK",
    "gui_target_status": "STATUS_9000"
  }
  ```
* *Deep SOP*: Refer to `references/playbook_develop_and_deploy.md`.

---

### ③ Transport Requests & TOC CI/CD Pipeline
* **Create a Transport of Copies (TOC)**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev transport create --type T --text "TOC_DEPLOY_NAME" --target "<QAS_TARGET>"
  ```
* **Copy Objects into TOC**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev transport copy --source-tr <SOURCE_TR> --target-tr <TOC_TR>
  ```
* **Release TOC**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile dev transport release --trkorr <TOC_TR>
  ```
* **Import to Quality System (MUST use QAS profile)**:
  ```bash
  python3 scripts/sap_ai_mcp_client.py --profile qas transport import --trkorr <TOC_TR>
  ```
* *Deep SOP*: Refer to `references/playbook_transport_pipeline.md`.

---

## 4. Strict Safety Guardrails (Zero-Tolerance Boundaries)

1. **Environment Isolation**:
   - ALL code modifications, object creations, and DDIC updates MUST occur on the **DEV** profile.
   - NEVER attempt to modify or create objects directly on QAS or PRD systems.
2. **Mandatory Transport Request (CTS)**:
   - Any non-local package object (packages other than `$TMP`) MUST specify an active, modifiable Workbench Transport Request (`transport`).
3. **QAS Import Profile Requirement**:
   - When importing a transport request into the test environment via `/transport/import`, you MUST switch to the test system profile (e.g. `--profile qas`), otherwise the physical import will not execute.
4. **Self-Modification Block**:
   - NEVER alter, overwrite, or delete `ZCL_AI_MCP_REST_FUN` or any related `ZCL_AI_MCP_REST_HANDLER*` classes via the REST endpoints.
5. **Open SQL Query Safeguards**:
   - When executing table reads, always include pagination (`--max-rows` or `UP TO n ROWS`) to prevent application server memory exhaustion.

---

## 5. Coding Standards Reference

* **Naming & Structure**: Always adhere to `rules/golden_rules.md`:
  - Variables: `lv_` (local variable), `lt_` (local table), `ls_` (local structure), `iv_/ev_/cv_` (method parameters).
  - DDIC: `ZT*` (tables), `ZDO_*` (domains), `ZDE_*` (data elements), `ZCL_*` (classes).
* **Syntax Troubleshooting**:
  - If syntax check fails, consult `references/troubleshooting.md`.
  - For ABAP 7.5+ modern syntax idioms (expressions, mesh, inline data, table expressions), refer to `rules/abap_syntax_guide_s4hana.md`.
