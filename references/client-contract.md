# SAP AI MCP Client Contract

Use `scripts/sap_ai_mcp_client.py` as the default entrypoint for repeated SAP AI MCP REST operations. Keep `scripts/sap_ai_mcp_call.py` for raw HTTP debugging.
Use `scripts/sap_ai_mcp_debug.py` for one-off read-only debug inspection. It must not expose write endpoints, must generate payloads internally from typed commands, and must print only compact summaries plus `log_dir` unless `--full-source` is supplied.

## Authentication

- `sap_ai_mcp_BASE_URL` may override the default base URL.
- `sap_ai_mcp_USER` may override the default user `<YOUR_SAP_USER>`.
- `sap_ai_mcp_PASSWORD` supplies the password.
- `--userpass USER:PASSWORD` may be used for one-off calls.
- Passwords must not be written to logs.

## Source Handling

- All read commands request `source_format = STRING`.
- `source_code` is the canonical ABAP source representation.
- `source_lines` is display or diagnostic metadata only.
- Large source bodies should be saved to logs and summarized in chat.

## Transport Handling

- Missing or blank package defaults to `$TMP`.
- `$TMP` allows empty transport.
- Non-`$TMP` package requires an explicit Workbench transport.
- The client must not create, infer, or substitute transport requests.

## First-Version Workflows

| Command | Workflow |
|---|---|
| `capabilities` | `/capabilities` |
| `debug ddic-fields TYPE_NAME` | `/debug/ddic_fields` with `type_name`; never `table_name` |
| `debug ddic-type TYPE_NAME` | `/debug/ddic_type` with `type_name` |
| `debug domain-values DOMAIN_NAME` | `/debug/domain_values` with `domain_name` |
| `debug dynpro PROGRAM SCREEN` | `/debug/dynpro_read` with `program` and `screen` |
| `debug fm-interface FUNC` | `/debug/fm_interface` with `function_name` |
| `debug locks OBJECT_NAME` | `/debug/locks` with `object_name` |
| `read method CLASS METHOD` | `/class/method/read` |
| `read class CLASS` | `/object/read` with `CLAS` |
| `read report PROG` | `/object/read` with `PROG` |
| `read function FUNC` | `/function/read` |
| `read function-group FUGR` | `/function_group/read` |
| `ddic deploy payload.json` | `/ddic/validate_names` -> `/ddic/create` -> `/ddic/status` |
| `call ddic_domain_update_values payload.json --allow-dangerous` | `/ddic/domain/update_values` for existing domain fixed values |
| `report deploy payload.json` | `/object/check` -> `/object/save` -> `/object/activate` |
| `call object_save payload.json` for standalone includes | `/object/save` with `object_type = "PROG"` plus `program_type = "I"` or `subc = "I"`; saves the source with ABAP program type Include and does not activate the include directly |
| `class deploy payload.json` | `/object/save` -> `/object/activate` -> `/debug/class_methods` |
| `function deploy payload.json` | `/function/create` -> `/function/check` |
| `class repair-method payload.json` | `/object/repair`; source must be caller-provided method include; keep repaired ABAP lines short enough for classic method include writes |
| `call object_lifecycle payload.json` | `/object/lifecycle`; orchestrates check/repair/check/activate/verify with default 3 repair rounds and hard limit 5 |
| `function check NAME` | `/function/check` |
| `function repair payload.json` | `/function/source_save` -> `/function/check`; source must be caller-provided |
| `call /include/source_save payload.json` | `/include/source_save`; saves generated Z function group includes `TOP/Fxx/Oxx/Ixx`, rejects `Uxx`; optional `check_function` runs `/function/check` after save |
| `call dynpro_import_screen payload.json --allow-dangerous` | `/dynpro/import_screen`; creates or replaces a generated Dynpro screen from `screen_elements[]` plus optional `flow_logic`, without `table_control` or `custom_controls`; optional `screen_type = "I"` creates a true subscreen, omitted/default remains normal type `N` |
| `call dynpro_import_custom_control payload.json --allow-dangerous` | `/dynpro/import_custom_control`; creates or replaces a generated Dynpro screen with Dynpro `CUST_CTRL` containers for OO ALV/custom controls without changing `/dynpro/import_from_json` table-control behavior; custom controls must not be duplicated in `screen_elements[]` |
| `call dynpro_import_layout payload.json --allow-dangerous` | `/dynpro/import_layout`; creates or replaces a generated Dynpro screen with explicit `containers[]` and `screen_elements[]`, including `SUBSCREEN` and `STRIP_CTRL` tabstrip layouts, without changing existing Dynpro import endpoints; optional `screen_type = "I"` creates a true subscreen, omitted/default remains normal type `N` |
| `call function_execute payload.json --allow-dangerous` | `/function/execute`; dynamically calls a Function Module with parameter deserialization and structured result |
| `call transport_search payload.json` | `/transport/search`; searches unreleased TRs for user |
| `call transport_create payload.json --allow-dangerous` | `/transport/create`; creates a new Workbench TR or Transport of Copies (TOC) |
| `call transport_copy payload.json --allow-dangerous` | `/transport/copy`; copies physical objects from source TR into target TOC |
| `call transport_release payload.json --allow-dangerous` | `/transport/release`; releases TR and auto-bypasses locking check for TOCs |
| `call transport_import payload.json --allow-dangerous` | `/transport/import`; triggers TMS import into target system/client |


Generated include save payloads must include `function_group`, `include_name`, and full `source_code`; pass `check_function` when a function group syntax check should run after saving. `/include/source_save` intentionally rejects `Uxx` includes so function module source changes keep using `/function/source_save` and its `function_name`-based validation.

Standalone report includes such as `Z*_TOP`, `Z*_F01`, `Z*_O01`, and `Z*_I01` should use `/object/save` with `object_type = "PROG"` and either `program_type = "I"` or `subc = "I"`. This explicit include path is separate from normal report deployment; do not call `/object/activate` on an include by itself. Activate or check the owning executable program when one exists.

Function source normalization: `function deploy` sends function body source to `/function/create` and strips accidental outer `FUNCTION ... ENDFUNCTION`; `function repair` sends full include source to `/function/source_save` and wraps body-only input automatically.

Class method repair normalization: `class repair-method` sends complete method include source with outer `METHOD ... ENDMETHOD` to `/object/repair`, defaults `target.kind = METHOD`, `target.version = INACTIVE`, `check_after_save = true`, and `activate_after_check = false`. Repair payloads should avoid long ABAP lines, especially string templates, because some systems persist method includes through classic fixed-width report APIs.

## Safety Boundaries

The first version must not:

- Create transports.
- Auto-repair ABAP source.
- Auto-rename DDIC objects.
- Delete SAP objects.
- Access non-`zai_mcp_rest` SAP paths.

Additional client guardrails:

- The effective base URL must be exactly the `/sap/bc/zai_mcp_rest` service path; ADT and other SAP REST services are blocked at client initialization.
- Named workflows may use read, check, and write endpoints through the registered endpoint table.
- Raw `call /path payload.json` is for debugging only. By default it is limited to registered read/check endpoints.
- Raw write endpoints such as `/object/save`, `/object/activate`, `/ddic/create`, `/ddic/domain/update_values`, `/include/source_save`, and function save/create endpoints require `--allow-dangerous`, whether passed as paths or registered endpoint names such as `object_save`.
- Unknown raw paths are blocked even with `--allow-dangerous`; add a registered endpoint before using a new route.
- `ZCL_AI_MCP_REST_HANDLER*` must not be saved, activated, or repaired through the same REST handler. Patch or recover the handler via SE24/ADT or another explicitly approved independent channel.


