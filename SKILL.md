---
name: sap-ai-mcp-rest-api
description: Use when AI_MCP needs to call the custom SAP AI MCP REST interface to create, validate, save, activate, read, debug, or troubleshoot ABAP and DDIC repository objects including domains, data elements, transparent tables, reports, global classes, function groups, function modules, and generated Dynpro screens. Trigger for SAP live REST automation, PATH_INFO endpoint calls, payload-file handling, package/transport handling, object activation, existing object source reads, or SAP REST error diagnosis.
---

# SAP AI MCP REST API

Use this skill for live SAP operations through the custom `zai_mcp_rest` REST handler. Keep design work such as DDIC naming and field modeling in `abap-ddic-generator`; use this skill when objects must be checked, created, saved, activated, read, or debugged in SAP.

## Always Load First

Read these files before any live SAP call:

- `references/policy.md` for naming, package, transport, and safety boundaries.
- `rules/object_naming_rules.json` for object naming patterns and module prefixes.
- `rules/coding_variable_rules.md` for ABAP code headers, variable prefixes (lv_, lt_, ls_), and code formatting.
- `rules/syntax_guidelines.md` for lightweight top-10 high-frequency ABAP golden rules card (~500 tokens).
- `rules/data_query_execution_rules.md` for Open SQL querying limits, pagination, and execution safety.
- `references/endpoints.md` for base URL, `PATH_INFO` routing, and endpoint capability.
- `references/calling.md` for the preferred Hybrid SDK Lite client, raw wrapper fallback, and payload encoding rules.
- `references/environments.md` for multi-environment profiles (DEV, QAS, PRD) and read-only guardrails.

## On-Demand Reference Manuals (Lazy Load via view_file)

Do NOT load these large reference manuals in full. Use `view_file` to read specific line ranges indexed in `rules/syntax_guidelines.md` ONLY when specialized syntax lookup is required:

- Classic ABAP Reference: `rules/abap_syntax_guide_classic.md`
- ABAP 7.5+ / S4HANA New Features Reference: `rules/abap_syntax_guide_s4hana.md`

## Choose The Playbook

Load only the playbook needed for the task:

- DDIC validate/create/status: `references/playbook-ddic.md`
- Report check/save/activate: `references/playbook-report.md`
- Global class save/activate/verify: `references/playbook-class.md`
- Function group/module create/check/repair/execute: `references/playbook-function-module.md` & `references/playbook-function-execute.md`
- Message class message maintenance: `references/playbook-message.md`
- Report/function group textpool maintenance: `references/playbook-textpool.md`
- Existing source read workflows: `references/playbook-read-existing.md`
- Generated Dynpro import/debug/check: `references/playbook-dynpro.md`
- Transport orchestration and TOC pipelines: `references/playbook-transport.md`
- Known SAP or client-side errors: `references/troubleshooting.md`
- Payload examples and tested historical objects: `references/examples.md`

## Client Preference

- Prefer `scripts/sap_ai_mcp_client.py` for repeated read, deploy, check, and repair workflows.
- Use `scripts/sap_ai_mcp_call.py` only for raw HTTP debugging or endpoint experiments not yet covered by the client.
- Read `references/client-contract.md` when changing client behavior, adding workflows, or troubleshooting client-side blocking.

## Standard Execution Rules

- Use the base `zai_mcp_rest` URL only; pass logical routes through the `PATH_INFO` HTTP header.
- Prefer `scripts/sap_ai_mcp_client.py` for repeated read, deploy, check, and repair workflows. Use `scripts/sap_ai_mcp_call.py` only for raw HTTP debugging or endpoint experiments not yet covered by the client. Use `curl.exe` only when the wrapper is unavailable or the user asks for raw HTTP behavior.
- Never save, activate, repair, lifecycle-run, or otherwise write `ZCL_AI_MCP_REST_HANDLER*` through the same `zai_mcp_rest` REST service. Treat this as a pre-call hard stop, not a retryable failure. Patch/deploy the handler only through SE24/ADT or another explicitly approved independent channel.
- Treat fixed point arithmetic as a server-side fixed default for report syntax contexts. `/object/check`, `/object/read` syntax status, and `/object/save` for `PROG`/`REPORT` should use report directory attributes equivalent to `SUBC = '1'`, `APPL = space`, `FIXPT = 'X'`, and `UCCHECK = 'X'`; do not work around missing fixed point context by downgrading valid new Open SQL syntax.
- Write request bodies as payload files. Do not inline complex JSON, ABAP source, Chinese text, or generated Dynpro JSON into a long PowerShell command. Store temporary payload and response JSON files in a temporary folder or remove them immediately after successful execution to avoid cluttering the workspace.
- Use ASCII for simple JSON and UTF-8 without BOM for non-ASCII payloads.
- Default to `source_code` as a single string for ABAP source in requests and read results. Use `source_lines` only as an auxiliary line-number view when the handler returns it; do not send line arrays unless an endpoint explicitly documents them.
- Treat `source_code` returned by read endpoints as the source of truth when repository read status is OK.
- For function modules, use `/function/check` as the final syntax result. Do not judge a function module by standalone `/object/check` of an `LZ*Uxx` include.
- For generated function group includes, use `/include/source_save` only for `LZ*TOP`, `LZ*Fxx`, `LZ*Oxx`, and `LZ*Ixx`; use `/function/source_save` for `LZ*Uxx` function module includes.
- For non-`$TMP` package objects, pass a valid Workbench transport and verify the expected repository object is attached to the request.


## Code Comments

When generating or changing code, add concise, meaningful comments for complex business rules, risky operations, external API/REST/BDC/CTS/DDIC/Dynpro interactions, non-obvious control flow, and important assumptions. Do not add noisy comments for self-explanatory statements. Match the existing file/context language for comments.

### Collateral Change Approval

Before any live SAP write, determine whether the operation may modify objects or object parts beyond the user's requested scope.

If the operation may affect any other object, screen element, include, function module, DDIC object, transport entry, generated artifact, flow-logic section, layout attribute, activation state, or unrelated source section, stop before executing the write.

Report the requested change, intended endpoint or tool, exact target object, replacement granularity, possible collateral changes, why those collateral changes may happen, and any safer alternative.

Request explicit user approval before continuing. Do not proceed with broader writes, regeneration, auto-repair, full-screen import, lifecycle execution, or adjacent object changes unless the user explicitly grants permission for that broader scope.
## Quick Flows
DDIC:

1. Generate or receive a DDIC payload.
2. Call `/ddic/validate_names`.
3. Stop if any object already exists; do not auto-rename.
4. Call `/ddic/create`.
5. Call `/ddic/status`.

Report:

1. Call `/object/check`.
2. Call `/object/save`.
3. Call `/object/activate`.

Class:

1. Call `/object/save`.
2. Call `/object/activate`.
3. Verify with `/debug/class_methods` or a temporary caller report checked through `/object/check`.

Function module:

1. Call `/function/create`.
2. Call `/function/check`.
3. If check fails, repair source and call `/function/source_save`.
4. Repeat `/function/check` within the requested retry limit.
5. For non-`$TMP`, verify request object `R3TR FUGR <function_group>`.

Message:

1. Call `/message/save` with an existing `Z*` message class and one or more message numbers; use `number = "AUTO"` to allocate from max existing `T100-MSGNR + 1` in range `001-999`.
2. Confirm each `results[]` entry is `OK` and expected/actual text matches.
3. Verify usage with `/object/check` on a temporary report containing `MESSAGE ...(<message_class>)`.
4. When `transport` is supplied, confirm `R3TR MSAG <message_class>` append succeeds or report the SAP CTS error.

Textpool:

1. Call `/textpool/save` with `object_type` `PROG`/`REPORT`, `FUGR`, or `FUNC`.
2. Use `id = "I"` for text symbols, `id = "S"` for selection texts, and `id = "R"` for report title/list text entries.
3. Use `key = "AUTO"` only for `I` text symbols when generating new entries; the handler allocates from max existing numeric key + 1.
4. Confirm each `results[]` entry is `OK` and expected/actual entry matches.
5. Verify `I` text symbols with `/object/check` or `/function/check` using `TEXT-<key>`.


Dynpro:

1. Prefer `/dynpro/import_from_json` with `replace_existing = true` when updating an existing generated screen.
2. For OO ALV/custom-control placeholders, use `/dynpro/import_custom_control`; the handler writes `custom_controls[]` as Dynpro `CUST_CTRL` containers and the placeholder must not be duplicated in `screen_elements[]`.
3. Generated normal screens should default `next_screen` to the screen itself; pass `next_screen` only for an intentional different target.
4. For table controls, use full `flow_logic` when SE51/Wizard-compatible PBO/PAI is needed.
5. Verify with `/debug/dynpro_read`, then `/object/activate` and `/object/check` for report screens or `/function/check` for function groups.

Transport Automation (TOC Pipeline):

1. Call `/transport/search` to find unreleased developer requests.
2. Call `/transport/create` with `target` to generate a TOC shell. Naming rule: `TOC_<MODULE>_<DESCRIPTION>_BY_<USER>_<YYYYMMDD>` (or `<MODULE>_<DESCRIPTION>_BY_<USER>_<YYYYMMDD>` for Workbench requests).
3. Call `/transport/copy` to merge physical objects (skipping locks/MERG).
4. Call `/transport/release` to generate transport data files.
5. Call `/transport/import` using the target profile (e.g. `--profile qas600`) to trigger TMS push.

Read existing source:

1. Prefer the dedicated read endpoint when available.
2. Fall back to compatible `/object/read` and `/function/check` flows from `references/playbook-read-existing.md`.
3. Keep read status separate from standalone include syntax status.

## Final Response Checklist

Before answering the user after live work, report:

- Endpoints called.
- Object names touched.
- Package and transport used.
- Final SAP status or syntax/check result.
- Any payload or response log path produced by the wrapper.


