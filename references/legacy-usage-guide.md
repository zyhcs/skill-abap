# SAP AI MCP REST Interface Usage Guide

## 1. Overview

This interface lets an external program create and validate SAP ABAP repository objects through one SAP ICF endpoint.

Supported object types in the current version:

- DDIC domain (`DOMA`)
- DDIC data element (`DTEL`)
- DDIC transparent table (`TABL`)
- ABAP report/program (`PROG`)
- ABAP global class (`CLAS`)
- Function group and function module (`FUGR` / `FUNC`)

Typical automation flow:

1. Generate object payload.
2. Validate DDIC names before creation.
3. Create DDIC objects in dependency order.
4. Syntax-check ABAP source.
5. Save ABAP source to SAP repository.
6. Activate object.
7. Verify active object or compile a caller program.

## 2. Base URL And Routing

Base URL:

```text
http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100
```

Important: do not append the logical path to the URL. Always send the route through HTTP header `PATH_INFO`.

Example:

```http
POST /sap/bc/zai_mcp_rest?sap-client=100
PATH_INFO: /object/check
Content-Type: application/json; charset=utf-8
Authorization: Basic ...
```

Correct:

```text
URL:       http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100
Header:    PATH_INFO = /object/check
```

Incorrect:

```text
http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest/object/check?sap-client=100
```

Access boundary:

- Without user approval, do not access `/sap/bc/adt/*`, other SICF services, or non-`zai_mcp_rest` REST paths.
- Use only the `/sap/bc/zai_mcp_rest?sap-client=100` base URL plus documented `PATH_INFO` routes unless the user explicitly approves another path.

## 3. Authentication

The interface currently uses SAP Basic Authentication.

Python example:

```python
AUTH = ("<YOUR_SAP_USER>", "your_password")
```

Do not hardcode production passwords in source code. Prefer environment variables or a secure credential store.

## 4. Endpoints

| PATH_INFO | Purpose |
|---|---|
| `/ddic/validate_names` | Check whether DDIC object names already exist |
| `/ddic/status` | Query DDIC active status |
| `/ddic/create` | Create domains, data elements, and tables |
| `/object/check` | Dynamically syntax-check ABAP source without saving |
| `/object/read` | Read saved report/include source and return basic syntax analysis. Current handlers may support only `PROG`/`REPORT`. |
| `/object/save` | Save report or class source |
| `/object/activate` | Activate report or class |
| `/function/create` | Create a function group and function module |
| `/function/check` | Check an existing function module by compiling its function group program |
| `/function/source_save` | Update source code of an existing Z function module include |
| `/function/main_source_save` | Update a `SAPLZ*` function group main program include list for its own generated includes |
| `/dynpro/import_from_json` | Create a generated Dynpro screen from a JSON layout payload |
| `/run` | Combined DDIC create + check + save + activate flow |
| `/debug/dynpro_read` | Debug: inspect Dynpro containers, fields, and field/container mapping |
| `/debug/fm_interface` | Debug: inspect SAP function module interface |
| `/debug/ddic_fields` | Debug: inspect active DDIC table/structure fields |
| `/debug/ddic_type` | Debug: inspect runtime ABAP type structure |
| `/debug/domain_values` | Debug: inspect fixed values of a DDIC domain |
| `/debug/class_methods` | Debug: inspect class methods and parameters |
| `/debug/locks` | Debug: inspect enqueue locks |
| `/function/execute` | Dynamically execute Function Module with parameter deserialization and structured output |
| `/transport/search` | Search unreleased transport requests belonging to a user by type and status |
| `/transport/create` | Create a new SAP Transport Request (Workbench / Transport of Copies) |
| `/transport/copy` | Copy physical objects from a source request into a target TOC request |
| `/transport/release` | Release a transport request (auto-bypasses locking check for TOCs) |
| `/transport/import` | Trigger TMS import for a request in a target system/client |

Recommended future read endpoints:

| PATH_INFO | Purpose |
|---|---|
| `/function/read` | Read a function module source directly, including function group, main program, and generated include metadata |
| `/function_group/read` | Read a full function group by returning the main program and all active includes |
| `/class/read` | Read global class definition, implementation, methods, and relevant generated includes |

## 5. DDIC Creation Rules

Object creation order:

1. Domains
2. Data elements
3. Transparent tables

Naming rules:

| Object | Prefix | Example |
|---|---|---|
| Domain | `ZD_` | `ZD_FULL092_ID` |
| Data element | `ZE_` | `ZE_FULL092_ID` |
| Transparent table | `ZSDT_` | `ZSDT_FULL092` |

General rules:

- Use uppercase names.
- Do not auto-rename if a name already exists.
- Always call `/ddic/validate_names` before `/ddic/create`.
- Data elements must reference an existing or newly created domain.
- Tables must reference active data elements.
- Package and transport request may be requested from the user. If not explicitly specified, use package `$TMP` and empty transport. For non-`$TMP` package objects, pass a valid Workbench request.

Default transparent table settings:

```json
{
  "delivery_class": "A",
  "data_maintenance": "X",
  "data_class": "APPL0",
  "size_category": "0",
  "storage_type": "C",
  "enhancement_category": "3"
}
```

## 6. DDIC Payload Example

```json
{
  "package": "$TMP",
  "transport": "",
  "domains": [
    {
      "name": "ZD_FULL092_ID",
      "data_type": "CHAR",
      "length": 12,
      "decimals": 0,
      "description": "Full Test 092 ID",
      "values": []
    },
    {
      "name": "ZD_FULL092_STATUS",
      "data_type": "CHAR",
      "length": 1,
      "decimals": 0,
      "description": "Full Test 092 Status",
      "values": [
        {
          "low": "A",
          "high": "",
          "description": "Active"
        },
        {
          "low": "I",
          "high": "",
          "description": "Inactive"
        }
      ]
    }
  ],
  "data_elements": [
    {
      "name": "ZE_FULL092_ID",
      "domain": "ZD_FULL092_ID",
      "description": "Full Test 092 ID",
      "short_text": "Test ID",
      "medium_text": "Full Test ID",
      "long_text": "Full Test Identifier",
      "heading": "Test ID"
    },
    {
      "name": "ZE_FULL092_STATUS",
      "domain": "ZD_FULL092_STATUS",
      "description": "Full Test 092 Status",
      "short_text": "Status",
      "medium_text": "Full Status",
      "long_text": "Full Test Status",
      "heading": "Status"
    }
  ],
  "tables": [
    {
      "name": "ZSDT_FULL092",
      "description": "Full Test 092 Table",
      "delivery_class": "A",
      "data_maintenance": "X",
      "data_class": "APPL0",
      "size_category": "0",
      "storage_type": "C",
      "enhancement_category": "3",
      "fields": [
        {
          "name": "MANDT",
          "data_element": "MANDT",
          "key_flag": true,
          "not_null": true,
          "position": 1
        },
        {
          "name": "TEST_ID",
          "data_element": "ZE_FULL092_ID",
          "key_flag": true,
          "not_null": true,
          "position": 2
        },
        {
          "name": "STATUS",
          "data_element": "ZE_FULL092_STATUS",
          "key_flag": false,
          "not_null": false,
          "position": 3
        }
      ]
    }
  ]
}
```

## 7. Report Payload Example

```json
{
  "object_type": "PROG",
  "object_name": "ZSDRPAI_MCP_FULL092_TEST",
  "package": "$TMP",
  "transport": "",
  "source_code": "REPORT zsdrpAI_MCP_full092_test.\n\nDATA gv_id TYPE ze_full092_id.\nDATA gv_status TYPE ze_full092_status.\n\nWRITE: / gv_id, gv_status."
}
```

Recommended flow for reports:

1. `/object/check`
2. `/object/save`
3. `/object/activate`

Read and analyze an existing report:

```json
{
  "object_type": "PROG",
  "object_name": "ZSDRPAI_MCP_FULL092_TEST"
}
```

Response includes:

- `source_code`: full report source as one escaped string
- `source_lines`: line-numbered source array
- `line_count`
- 
on_empty_line_count`
- `comment_line_count`
- `syntax.status`
- `syntax.messages`

Activation payload:

```json
{
  "object_type": "PROG",
  "object_name": "ZSDRPAI_MCP_FULL092_TEST"
}
```

## Existing Object Read Matrix

Observed read behavior differs by object type and deployed handler version. Use this matrix before assuming an object cannot be read.

| Object type | Current compatible read flow | Recommended server enhancement |
|---|---|---|
| `PROG` / report | Call `/object/read` with `object_type = PROG`. | Keep `/object/read`. |
| Include | Call `/object/read` with `object_type = PROG` and the include name. | Keep `/object/read`, but return read status separately from standalone syntax status. |
| `FUNC` | Call `/function/check` to discover `function_group`, `program`, and `include`, then call `/object/read` for the include. | Add `/function/read`. |
| `FUGR` | Call `/object/read` for `SAPL<function_group>`, parse active `INCLUDE` lines, then read each include. Read UXX function module includes separately. | Add `/function_group/read`. |
| `CLAS` | Current `/object/read` handlers may return `Only PROG/REPORT source read is implemented`; `/debug/class_methods` returns metadata only. | Add `/class/read`. |

### Read Function Module Source

Compatible flow for handlers without `/function/read`:

1. POST `/function/check`:

```json
{
  "function_name": "ZFM_PD_POST"
}
```

2. Read the returned include with `/object/read`:

```json
{
  "object_type": "PROG",
  "object_name": "LZFG_FI01U05"
}
```

3. If `/object/read` returns source together with `FUNCTION cannot be used in the current environment`, treat the source read as successful and use `/function/check` as the syntax result. A function module include is not a standalone report.

### Read Function Group Source

Compatible flow for handlers without `/function_group/read`:

1. Read `SAPL<function_group>` with `/object/read`.
2. Parse uncommented `INCLUDE` statements.
3. Read includes such as `L<function_group>TOP`, `L<function_group>UXX`, `L<function_group>F01`, `L<function_group>O01`, and `L<function_group>I01`.
4. Parse `L<function_group>UXX` to find generated function module includes such as `L<function_group>U01`, then read them with `/object/read`.

### Read Global Class Source

Preferred flow:

1. Call `/object/read` with `object_type = CLAS`.
2. The handler should derive the generated class pool program name, read the class pool source, expand generated class includes, and expand Class Builder `include methods.`.
3. To expand `include methods.`, call `SEO_CLASS_GET_METHOD_INCLUDES` and read each returned `INCNAME`.
4. If `/object/read` returns `Only PROG/REPORT source read is implemented`, the deployed handler is older and needs server-side enhancement.
5. `/debug/class_methods` can confirm active method metadata, but it cannot return full class source.

Recommended `/class/read` response shape:

```json
{
  "status": "OK",
  "class_name": "ZCL_EXAMPLE",
  "definition": "CLASS ... DEFINITION ...",
  "implementation": "CLASS ... IMPLEMENTATION ...",
  "methods": [],
  "includes": []
}
```
## 8. Class Payload Example

```json
{
  "object_type": "CLAS",
  "object_name": "ZCLSD_AI_MCP_FULL092_TEST",
  "package": "$TMP",
  "transport": "",
  "source_code": "CLASS zclsd_AI_MCP_full092_test DEFINITION PUBLIC FINAL CREATE PUBLIC.\n  PUBLIC SECTION.\n    METHODS get_status_text\n      IMPORTING iv_status TYPE ze_full092_status\n      RETURNING VALUE(rv_text) TYPE string.\nENDCLASS.\n\nCLASS zclsd_AI_MCP_full092_test IMPLEMENTATION.\n  METHOD get_status_text.\n    IF iv_status = 'A'.\n      rv_text = 'Active'.\n    ELSE.\n      rv_text = 'Unknown'.\n    ENDIF.\n  ENDMETHOD.\nENDCLASS."
}
```

Class creation notes:

- The current class parser supports simple public instance methods.
- Supported method parameters:
  - `IMPORTING`
  - `EXPORTING`
  - `CHANGING`
  - `RETURNING VALUE(...)`
- The class is created through `SEO_CLASS_CREATE_COMPLETE`.
- Methods and parameters must be written as active version (`SEOVERSION = 1`), otherwise the compiler may not see public methods.
- Activation uses `SEO_CLASS_ACTIVATE`.
- Do not use direct database updates to SAP repository tables.

Recommended verification after class activation:

1. Call `/debug/class_methods`.
2. Confirm method and parameter `version = "1"`.
3. Run `/object/check` with a temporary report that calls the public methods.

## 9. Function Module Payload Examples

Function module endpoints:

| PATH_INFO | Purpose |
|---|---|
| `/function/create` | Create a function group if needed, create the function module, save source, and append `R3TR FUGR` to CTS |
| `/function/check` | Validate an existing function module by generating `SAPL<function_group>` |
| `/function/source_save` | Replace source of an existing Z function module include |
| `/function/execute` | Dynamically execute a Function Module with parameter deserialization and structured JSON return |

Creation payload fields:

| Field | Required | Notes |
|---|---:|---|
| `function_group` | Yes | Must use `ZSDG_*` |
| `function_name` | Yes | Must use `ZSDF_*` |
| `package` | No | Defaults to `$TMP` when blank |
| `transport` | Required only for non-`$TMP` | Empty when package is `$TMP`; otherwise pass a valid Workbench request |
| `short_text` | No | Function module short text |
| `importing` | No | Scalar input parameters |
| `exporting` | No | Scalar output parameters |
| `changing` | No | Scalar changing parameters |
| `tables` | No | Internal table parameters |
| `source_code` | Yes | Full source including `FUNCTION ... ENDFUNCTION` |

Function naming and package rules:

- API-created function groups must use `ZSDG_*`; function modules must use `ZSDF_*`.
- Package and transport request may be requested from the user. If not explicitly specified, use package `$TMP` and empty transport.
- If `package` is not `$TMP`, pass a valid Workbench `transport`.
- The request should contain object `R3TR FUGR <function_group>`.
- Do not use `/object/read` or `/object/check` against function module includes such as `LZ...U01` for final judgment. Standalone include checks can report the expected false error `FUNCTION cannot be used in the current environment`.

Function parameter type rules:

- `IMPORTING`, `EXPORTING`, and `CHANGING` parameter `type` must be an existing DDIC table-field reference, for example `MARA-MATNR`, `BSEG-WRBTR`, or `TLINE-TDLINE`.
- Do not pass standalone data elements such as `MATNR` for scalar function parameters.
- `TABLES` parameter `type` must be an existing DDIC table or structure, for example `MARA` or `BAPIRET2`.
- Validate function modules with `/function/check`; it uses `FUNCTION_EXISTS`, builds `SAPL<function_group>`, and runs `GENERATE REPORT`.

Example: simple importing and exporting function:

```json
{
  "function_group": "ZSDG_AI_MCP_SIMPLE",
  "function_name": "ZSDF_AI_MCP_SIMPLE",
  "package": "$TMP",
  "transport": "",
  "short_text": "Simple AI_MCP function",
  "importing": [
    {
      "name": "IV_MATNR",
      "type": "MARA-MATNR"
    }
  ],
  "exporting": [
    {
      "name": "EV_MTART",
      "type": "MARA-MTART"
    }
  ],
  "changing": [],
  "tables": [],
  "source_code": "FUNCTION zsdf_AI_MCP_simple.\n  CLEAR ev_mtart.\n  SELECT SINGLE mtart FROM mara INTO ev_mtart WHERE matnr = iv_matnr.\nENDFUNCTION."
}
```

Example: importing, exporting, and changing parameters:

```json
{
  "function_group": "ZSDG_AI_MCP_IEC",
  "function_name": "ZSDF_AI_MCP_IEC001",
  "package": "$TMP",
  "transport": "",
  "short_text": "Import export changing test",
  "importing": [
    {
      "name": "IV_MATNR",
      "type": "MARA-MATNR"
    }
  ],
  "exporting": [
    {
      "name": "EV_MTART",
      "type": "MARA-MTART"
    }
  ],
  "changing": [
    {
      "name": "CV_MATKL",
      "type": "MARA-MATKL"
    }
  ],
  "tables": [],
  "source_code": "FUNCTION zsdf_AI_MCP_iec001.\n  CLEAR ev_mtart.\n  SELECT SINGLE mtart matkl FROM mara INTO (ev_mtart, cv_matkl) WHERE matnr = iv_matnr.\nENDFUNCTION."
}
```

Example: table return parameter:

```json
{
  "function_group": "ZSDG_AI_MCP_MAT_READ",
  "function_name": "ZSDF_AI_MCP_MAT_READ",
  "package": "$TMP",
  "transport": "",
  "short_text": "Read material master",
  "importing": [
    {
      "name": "IV_MATNR",
      "type": "MARA-MATNR"
    }
  ],
  "exporting": [],
  "changing": [],
  "tables": [
    {
      "name": "ET_MARA",
      "type": "MARA"
    }
  ],
  "source_code": "FUNCTION zsdf_AI_MCP_mat_read.\n  REFRESH et_mara.\n  SELECT * FROM mara INTO TABLE et_mara WHERE matnr = iv_matnr.\nENDFUNCTION."
}
```

Example: RMB amount to uppercase function in default package `$TMP` with empty transport:

```json
{
  "function_group": "ZSDG_AI_MCP_RMB_UPPER02",
  "function_name": "ZSDF_AI_MCP_RMB_TO_UPPER02",
  "package": "$TMP",
  "transport": "",
  "short_text": "RMB amount to uppercase text",
  "importing": [
    {
      "name": "IV_AMOUNT",
      "type": "BSEG-WRBTR"
    }
  ],
  "exporting": [
    {
      "name": "EV_TEXT",
      "type": "TLINE-TDLINE"
    }
  ],
  "changing": [],
  "tables": [],
  "source_code": "FUNCTION zsdf_AI_MCP_rmb_to_upper02.\n  DATA lv_amount TYPE bseg-wrbtr.\n  lv_amount = iv_amount.\n  ev_text = |RMB { lv_amount }|.\nENDFUNCTION."
}
```

Function check payload:

```json
{
  "function_name": "ZSDF_AI_MCP_RMB_TO_UPPER02"
}
```

Function source repair payload:

```json
{
  "function_name": "ZSDF_AI_MCP_RMB_TO_UPPER02",
  "source_code": "FUNCTION zsdf_AI_MCP_rmb_to_upper02.\n  ev_text = |RMB { iv_amount }|.\nENDFUNCTION."
}
```

When saving generated `LZ*` include programs, the ABAP program type must be the letter `I`:

```abap
INSERT REPORT lv_include FROM lt_source PROGRAM TYPE 'I'.
```

Use this for generated `LZ*TOP`, `LZ*O01`, `LZ*I01`, `LZ*F01`, and function module include programs such as `LZ*Uxx`. Do not use program type `I` for `SAPLZ*` function group main programs or normal reports.

Function group main program include-list payload:

```json
{
  "main_program": "SAPLZFG_AI_MCP_GOODTYP",
  "source_code": "INCLUDE LZFG_AI_MCP_GOODTYPTOP.\nINCLUDE LZFG_AI_MCP_GOODTYPUXX.\nINCLUDE LZFG_AI_MCP_GOODTYPF01.\nINCLUDE LZFG_AI_MCP_GOODTYPO01.\nINCLUDE LZFG_AI_MCP_GOODTYPI01."
}
```

`/function/main_source_save` is restricted to `SAPLZ*` main programs and only allows includes belonging to the same generated Z function group.

Recommended flow for function modules:

1. POST `/function/create`.
2. POST `/function/check`.
3. If check fails, fix the full `source_code`.
4. POST `/function/source_save`.
5. Repeat `/function/check`, up to the caller's retry limit.
6. For non-`$TMP`, verify the request contains `R3TR FUGR <function_group>`.

## 10. Python Calling Method

Recommended Python implementation using only standard library:

```python
import base64
import json
import urllib.error
import urllib.request

BASE_URL = "http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100"
USER = "<YOUR_SAP_USER>"
PASSWORD = "your_password"

def post(path_info: str, payload: dict, timeout: int = 60) -> dict:
    raw = json.dumps(payload).encode("utf-8")
    token = base64.b64encode(f"{USER}:{PASSWORD}".encode("utf-8")).decode("ascii")

    req = urllib.request.Request(
        BASE_URL,
        data=raw,
        method="POST",
        headers={
            "Authorization": f"Basic {token}",
            "PATH_INFO": path_info,
            "Content-Type": "application/json; charset=utf-8",
        },
    )

    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            text = resp.read().decode("utf-8", errors="replace")
            return {
                "http_status": resp.status,
                "body": json.loads(text),
            }
    except urllib.error.HTTPError as exc:
        text = exc.read().decode("utf-8", errors="replace")
        try:
            body = json.loads(text)
        except json.JSONDecodeError:
            body = {"raw": text}
        return {
            "http_status": exc.code,
            "body": body,
        }
```

Example: create a local test domain:

```python
payload = {
    "package": "$TMP",
    "transport": "",
    "domains": [
        {
            "name": "ZD_PY_LOCAL_0611",
            "data_type": "CHAR",
            "length": 10,
            "decimals": 0,
            "description": "Python Local Domain Test",
            "values": []
        }
    ],
    "data_elements": [],
    "tables": []
}

print(post("/ddic/validate_names", payload))
print(post("/ddic/create", payload))
print(post("/ddic/status", payload))
```

Example: check, save, and activate a report:

```python
report_payload = {
    "object_type": "PROG",
    "object_name": "ZSDRPAI_MCP_PY_TEST",
    "package": "$TMP",
    "transport": "",
    "source_code": "REPORT zsdr_AI_MCP_py_test.\nWRITE 'Hello from Python'."
}

print(post("/object/check", report_payload))
print(post("/object/save", report_payload))

activate_payload = {
    "object_type": "PROG",
    "object_name": "ZSDRPAI_MCP_PY_TEST"
}

print(post("/object/activate", activate_payload))
```

Example: check a class after activation:

```python
check_payload = {
    "object_type": "PROG",
    "object_name": "zai_mcp_rest_CHECK_CLASS",
    "source_code": (
        "REPORT zai_mcp_rest_check_class.\n"
        "DATA lo_obj TYPE REF TO zclsd_AI_MCP_full092_test.\n"
        "DATA lv_text TYPE string.\n"
        "CREATE OBJECT lo_obj.\n"
        "lv_text = lo_obj->get_status_text( 'A' )."
    )
}

print(post("/object/check", check_payload))
```

Example: create and check a function module:

```python
function_payload = {
    "function_group": "ZSDG_AI_MCP_PY_FUNC",
    "function_name": "ZSDF_AI_MCP_PY_FUNC",
    "package": "$TMP",
    "transport": "",
    "short_text": "Python function create test",
    "importing": [
        {
            "name": "IV_MATNR",
            "type": "MARA-MATNR"
        }
    ],
    "exporting": [
        {
            "name": "EV_MTART",
            "type": "MARA-MTART"
        }
    ],
    "changing": [],
    "tables": [],
    "source_code": (
        "FUNCTION zsdf_AI_MCP_py_func.\n"
        "  CLEAR ev_mtart.\n"
        "  SELECT SINGLE mtart FROM mara INTO ev_mtart WHERE matnr = iv_matnr.\n"
        "ENDFUNCTION."
    )
}

print(post("/function/create", function_payload))
print(post("/function/check", {"function_name": "ZSDF_AI_MCP_PY_FUNC"}))
```

## 11. curl Calling Method

Use `curl.exe` on Windows for SAP REST calls. This is the default method for complex JSON, ABAP source, Chinese text, multiline strings, and generated Dynpro payloads.

Default Windows pattern:

1. Write the JSON request body to a temporary or workspace payload file using ASCII or UTF-8 without BOM.
2. Inspect or verify the payload file separately when troubleshooting.
3. Call the SAP endpoint with `curl.exe`, not PowerShell alias `curl`.
4. Pass the logical route through the `PATH_INFO` HTTP header.
5. Send the request body with `--data-binary "@<absolute-payload-file>"`.
6. Keep the URL as the base `zai_mcp_rest` SICF URL; do not append the logical route to the URL.

Do not inline complex JSON directly in the PowerShell command. Payload files avoid quoting, escaping, `@file`, and encoding issues.

Prefer separate shell calls for payload generation, payload inspection, and the `curl.exe` REST call. Avoid combining payload creation and REST invocation in one long PowerShell command because local parsing of `@`, variables, pipes, encodings, and long JSON strings can fail with an empty response before the request reaches SAP.

When a payload contains file contents such as ABAP source, read the file with `.NET` string APIs and write the payload with UTF-8 without BOM:

```powershell
$sourcePath = "C:\path\source.abap"
$payloadPath = Join-Path $env:TEMP "AI_MCP_payload.json"
$source = [System.IO.File]::ReadAllText($sourcePath)
$payload = [pscustomobject]@{
  object_type = "CLAS"
  object_name = "ZCLSD_EXAMPLE"
  source_code = $source
} | ConvertTo-Json -Depth 5
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($payloadPath, $payload, $utf8NoBom)
```

Do not pipe `Get-Content` results or PowerShell file objects directly into `ConvertTo-Json`; PowerShell can serialize metadata such as `value`, `PSPath`, and `PSParentPath` instead of a plain JSON string.

Example:

```powershell
curl.exe -i -s `
  -u "<YOUR_SAP_USER>:your_password" `
  -H "PATH_INFO: /object/check" `
  -H "Content-Type: application/json; charset=utf-8" `
  --data-binary "@outputs/AI_MCP_full_092_report_payload.json" `
  "http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100"
```

In our tests, `curl.exe` returned stable raw HTTP responses, while PowerShell `Invoke-WebRequest` sometimes threw a local `System.NullReferenceException`.

## 12. Transport And Package Rules

Package behavior:

- `$TMP`: local object, no transport required.
- Non-`$TMP` package: transport is required.

Transport behavior:

- Use a modifiable Workbench request.
- The request must be valid for the package target system.
- The request/task ownership must allow the current SAP user to append objects.
- Function modules are transported through their function group.
- For function module creation, expect request object `R3TR FUGR <function_group>`, not a separate `FUNC` object.

Known transport errors:


### JSON BOM Parsing Symptoms

Symptom:

```text
function_name is required
object_name is required
```

This can happen even when the payload file visibly contains the field. Some deployed SAP handlers parse UTF-8 files with BOM as an empty or invalid JSON object.

Client-side prevention:

```powershell
Set-Content -Path $payload -Value '{"function_name":"ZFM_PD_POST"}' -Encoding ascii
```

For non-ASCII payloads, write UTF-8 without BOM explicitly:

```powershell
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($payload, $json, $utf8NoBom)
```

Server-side fix: strip a leading UTF-8 BOM before JSON deserialization and return a clear parse error when JSON cannot be decoded.

### TK 127

```text
Changes to objects are only allowed in correction/repair
```

Meaning:

- The request type or object situation does not allow normal Workbench object append.
- Use another valid request or check request type, owner, task, and target.

### TR 589

```text
Combination of object type and function invalid
```

Observed cause:

- `E071-OBJFUNC = 'K'` was invalid for `R3TR PROG`.

Fix:

```abap
ls_e071-objfunc = space.
```

## 13. Important Implementation Notes

Do not directly update SAP repository tables:

- Do not `INSERT/UPDATE/MODIFY TADIR`.
- Do not `INSERT/UPDATE/MODIFY E071`.

Use SAP APIs:

- `DDIF_DOMA_PUT`
- `DDIF_DOMA_ACTIVATE`
- `DDIF_DTEL_PUT`
- `DDIF_DTEL_ACTIVATE`
- `DDIF_TABL_PUT`
- `DDIF_TABL_ACTIVATE`
- `TR_TADIR_INTERFACE`
- `TR_APPEND_TO_COMM_OBJS_KEYS`
- `SEO_CLASS_CREATE_COMPLETE`
- `SEO_CLASS_ACTIVATE`
- Function Builder APIs used by the deployed handler for function group/function module creation
- `INSERT REPORT` only for saving generated repository source includes, not for direct database table inserts

Type compatibility matters:

- Some SAP function modules require exact DDIC parameter types.
- Use explicit variables such as:
  - `DDOBJNAME` for DDIC object names where required.
  - `E070-TRKORR` for transport request.
  - `TRBOOLEAN` for dialog flag.
  - `E071` table for CTS object append.

Object directory matters:

- The package displayed in SE11/SE80 comes from `TADIR-DEVCLASS`.
- DDIC activation alone does not guarantee the package field is filled.
- If package is blank, TADIR registration did not complete.

Function module checks:

- Use `/function/check` after `/function/create` or `/function/source_save`.
- `/function/check` compiles the function group main program `SAPL<function_group>`.
- Do not treat include-level `FUNCTION cannot be used in the current environment` from `/object/check` as the function module result.


Read API response guidance:

- Split repository read status from standalone syntax status. Includes can be read successfully while standalone syntax analysis fails.
- For function module includes, `FUNCTION cannot be used in the current environment` should be represented as an expected include syntax result, not as a failed source read.
- For unsupported object types, return a specific capability message such as `Class source read is not implemented`; do not imply that the object name or payload is invalid.
- Normalize incoming JSON by removing a UTF-8 BOM before deserialization.
Generated Dynpro checks:

- Use `/dynpro/import_from_json` to create or update the screen from JSON.
- Use `/debug/dynpro_read` to read back containers, fields, and field/container mapping.
- There is no `/dynpro/read` endpoint in the current handler contract.
- After Dynpro generation, run `/function/check` for the target function group function module to verify the generated screen flow logic can resolve its PBO/PAI modules.

## 14. Recommended End-To-End Flow

For DDIC + class + report + function generation:

1. Generate DDIC payload.
2. POST `/ddic/validate_names`.
3. Stop if any duplicate name exists.
4. POST `/ddic/create`.
5. POST `/ddic/status`.
6. Generate class payload.
7. POST `/object/save`.
8. POST `/object/activate`.
9. POST `/debug/class_methods`.
10. Generate report payload.
11. POST `/object/check`.
12. POST `/object/save`.
13. POST `/object/activate`.
14. Generate function module payload if needed.
15. POST `/function/create`.
16. POST `/function/check`.
17. If failed, fix source and POST `/function/source_save`.
18. Repeat `/function/check`.

## 15. Tested Objects

The following full test used historical package/request values. Treat them as historical examples only; default new creation uses `$TMP` and empty transport:

```text
ZD_FULL092_ID
ZD_FULL092_STATUS
ZE_FULL092_ID
ZE_FULL092_STATUS
ZSDT_FULL092
ZCLSD_AI_MCP_FULL092_TEST
ZSDRPAI_MCP_FULL092_TEST
ZSDG_AI_MCP_RMB_UPPER02
ZSDF_AI_MCP_RMB_TO_UPPER02
ZSDF_AI_MCP_IEC001
ZSDF_AI_MCP_GOODTYP
```

Successful report activation response:

```json
{
  "status": "OK",
  "object_type": "PROG",
  "object_name": "ZSDRPAI_MCP_FULL092_TEST",
  "message": "Report generated successfully"
}
```

## 16. Transport Automation Endpoints

Transport automation endpoints for CTS/TMS management:

| PATH_INFO | Purpose | Key Payload Fields |
|---|---|---|
| `/transport/search` | Query unreleased TRs for user | `username`, `request_type`, `status` |
| `/transport/create` | Create TR / TOC request | `type` (`T`/`K`), `text`, `target` |
| `/transport/copy` | Copy objects from source TR to target TOC | `source_tr`, `target_tr` |
| `/transport/release` | Release TR (bypass lock check for TOC) | `trkorr` |
| `/transport/import` | Trigger TMS import into target system/client | `trkorr`, `system`, `client` |
