# Calling SAP AI MCP REST

## Preferred Client

Prefer `scripts/sap_ai_mcp_client.py` for repeated read, deploy, check, and repair workflows. Use `scripts/sap_ai_mcp_call.py` only for raw HTTP debugging or endpoint experiments not yet covered by the client.

Hard stop before any write call: do not use `/object/save`, `/object/activate`, `/object/repair`, `/object/lifecycle`, or any write workflow to modify `ZCL_AI_MCP_REST_HANDLER*` through the same `zai_mcp_rest` REST handler. Use SE24/ADT or another explicitly approved independent deployment channel for handler patches.

Report syntax-check calls are expected to use fixed report attributes on the server (`SUBC = '1'`, `APPL = space`, `FIXPT = 'X'`, `UCCHECK = 'X'`). If valid new Open SQL fails with a fixed point arithmetic message, treat it as a handler deployment/configuration issue, not as proof that the SAP system lacks new syntax support.

Environment variables:

| Variable | Purpose |
|---|---|
| `sap_ai_mcp_BASE_URL` | Optional base URL override |
| `sap_ai_mcp_USER` | SAP user; defaults to `<YOUR_SAP_USER>` for this personal environment |
| `sap_ai_mcp_PASSWORD` | SAP password; required unless using `--userpass` |

Client examples:

```powershell
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_client.py --dry-run read report ZSDRPAI_MCP_EXAMPLE
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_client.py report deploy C:\work\payload.json
```

The client writes request and response logs under `work/sap-runs/<timestamp>/` by default when run from a AI_MCP workspace. Use `--log-dir` to override.

Raw wrapper examples:

```powershell
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_call.py --path /object/check --payload C:\work\payload.json
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_call.py --path /object/check --payload C:\work\payload.json --dry-run
```

The raw wrapper also writes logs, bypasses inherited proxy settings by default, and blocks base URLs outside `/sap/bc/zai_mcp_rest`.
## Read-Only Debug Wrapper

Use `scripts/sap_ai_mcp_debug.py` for common read/debug calls when you do not want to hand-write payload JSON. It exposes only read/debug endpoints, writes request/response logs under `work/sap-runs`, and prints a compact summary plus `log_dir` by default. Add `--full-source` only when full `source_code` should be printed to the console.

Examples:

```powershell
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_debug.py ddic-fields ZSDT_EXAMPLE
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_debug.py domain-values ZD_EXAMPLE
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_debug.py dynpro ZSDRP_EXAMPLE 9001
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_debug.py report ZSDRP_EXAMPLE --full-source
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_debug.py locks ZSDT_EXAMPLE
```

Important payload mappings:

- `ddic-fields <TYPE_NAME>` sends `/debug/ddic_fields` with `{ "type_name": "..." }`; do not use `table_name`.
- `ddic-type <TYPE_NAME>` sends `/debug/ddic_type` with `{ "type_name": "..." }`.
- `domain-values <DOMAIN_NAME>` sends `/debug/domain_values` with `{ "domain_name": "..." }`.
- `fm-interface <FUNC>` sends `/debug/fm_interface` with `{ "function_name": "..." }`.
- `locks <OBJECT_NAME>` sends `/debug/locks` with `{ "object_name": "..." }`.

## Payload Rules

- Write request bodies to files.
- Use ASCII for simple JSON.
- Use UTF-8 without BOM for Chinese text, ABAP source, or generated Dynpro JSON.
- Do not inline complex JSON in PowerShell commands.
- Do not pipe `Get-Content` objects into `ConvertTo-Json`; PowerShell can serialize file metadata instead of plain source text.
- For `/object/repair` class method payloads, keep ABAP method source lines short, preferably 72 characters or less. Split long JSON string templates and long argument lines before saving, then read back the method to confirm it was not truncated.

For PowerShell-generated JSON with file content:

```powershell
$source = [System.IO.File]::ReadAllText("C:\path\source.abap")
$payload = [pscustomobject]@{
  object_type = "CLAS"
  object_name = "ZCLSD_EXAMPLE"
  source_code = $source
} | ConvertTo-Json -Depth 10
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText("C:\path\payload.json", $payload, $utf8NoBom)
```

## Local Proxy Bypass

In this Windows AI_MCP environment, inherited proxy variables may point to `http://127.0.0.1:9` and cause `curl.exe` to fail with exit code 7. For SAP AI MCP REST calls with `curl.exe`, add:

```powershell
--noproxy "*"
```
## Curl Fallback

Use `curl.exe`, not the PowerShell `curl` alias. Keep the route in `PATH_INFO` and use `--data-binary` with a payload file.

```powershell
curl.exe --noproxy "*" -i -s -S `
  -u "<YOUR_SAP_USER>:your_password" `
  -H "PATH_INFO: /object/check" `
  -H "Content-Type: application/json; charset=utf-8" `
  --data-binary "@C:\work\payload.json" `
  "http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100"
```

Avoid `Invoke-WebRequest` and `Invoke-RestMethod` for final judgment; they have produced local exceptions while `curl.exe` returned valid SAP JSON.

## Message Save Payload

Use `/message/save` only for maintaining messages in an existing `Z*` message class. It does not create message classes. Write the JSON body to a payload file:

```json
{
  "message_class": "ZSD_01",
  "language": "E",
  "transport": "",
  "messages": [
    { "number": "AUTO", "text": "AI_MCP generated message one &" },
    { "number": "AUTO", "text": "AI_MCP generated message two &" },
    { "number": "998", "text": "Explicit upsert message &" }
  ]
}
```

Rules:

- `message_class` must already exist in `T100A` and must be `Z*`.
- `number` must be `AUTO` or exactly three digits, `000` to `999`.
- Explicit three-digit numbers are upserted.
- `AUTO` numbers are allocated from the current maximum `T100-MSGNR` in range `001-999`, then incremented in payload order. If allocation would exceed `999`, the handler returns `MESSAGE_NUMBER_RANGE_FULL` and saves nothing.
- `text` is required and must fit `T100-TEXT` length 73.
- `language` is single-language per call; call again for other languages.
- `transport` is optional. When supplied, the handler appends `R3TR MSAG <message_class>` through CTS before BDC.
- Multiple messages can be sent in one request. The handler validates and allocates all entries first, then saves each message separately through SE91 BDC and reads back `T100`.

## Textpool Save Payload

Use `/textpool/save` for maintaining text elements on existing `Z*` reports and function groups. Write the JSON body to a payload file:

```json
{
  "object_type": "REPORT",
  "object_name": "ZSDRP_AI_MCP_EXAMPLE",
  "language": "E",
  "transport": "",
  "texts": [
    { "id": "I", "key": "AUTO", "entry": "Generated text symbol" },
    { "id": "I", "key": "900", "entry": "Explicit text symbol" },
    { "id": "S", "key": "P_BUKRS", "entry": "Company Code" }
  ]
}
```

Rules:

- `object_type` may be `PROG`, `REPORT`, `FUGR`, or `FUNC`.
- `I` text symbols support `key = AUTO`; the assigned key is returned in `results[].key`.
- Explicit keys are upserted, so use `AUTO` for generated new text symbols when avoiding collisions matters.
- `S` and `R` entries require explicit keys.
- `transport` is optional; when supplied the handler appends `R3TR PROG <program>` or `R3TR FUGR <function_group>`.

