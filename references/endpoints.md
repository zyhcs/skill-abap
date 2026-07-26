# Endpoints

## Base URL And Routing

Default personal base URL:

```text
http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100
```

Prefer environment variable `sap_ai_mcp_BASE_URL` when available. Keep the URL at the base `zai_mcp_rest` SICF path and pass the logical route through HTTP header `PATH_INFO`.

Correct:

```text
URL:       http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest?sap-client=100
PATH_INFO: /object/check
```

Incorrect:

```text
http://<your-sap-host>:<port>/sap/bc/zai_mcp_rest/object/check?sap-client=100
```

## Current Endpoint Matrix

| PATH_INFO | Purpose |
|---|---|
| `/ddic/validate_names` | Check whether DDIC object names already exist |
| `/ddic/create` | Create domains, data elements, and transparent tables |
| `/ddic/status` | Query DDIC active status |
| `/ddic/domain/update_values` | Update fixed values on an existing DDIC domain, then activate and verify it |
| `/object/check` | Syntax-check ABAP source without saving. For reports, the handler should check with fixed report attributes: `SUBC = '1'`, `APPL = space`, `FIXPT = 'X'`, `UCCHECK = 'X'`. |
| `/object/read` | Read `PROG`/`REPORT`, generated includes, and supported `CLAS`/`CLASS` source. Use `"source_format": "STRING"` by default. Any returned report syntax status should use the same fixed report attributes as `/object/check`. |
| `/object/save` | Save report, include, or class source. For reports, save with `SUBC = '1'`, `APPL = space`, `FIXPT = 'X'`, and `UCCHECK = 'X'`. For standalone ABAP includes, pass `program_type = "I"` or `subc = "I"`; only that explicit include path uses `INSERT REPORT ... PROGRAM TYPE 'I'`, leaving normal report saves unchanged. |
| `/object/activate` | Activate report or class |
| `/object/repair` | Repair object subcomponents and optionally read back/check/activate. First supported target is `CLAS` method source through Class Builder APIs. |
| `/object/lifecycle` | Orchestrate save/check/repair/check/activate/verify for supported objects. Default repair rounds: 3; hard limit: 5. First supported objects: `PROG` and `CLAS`. |
| `/function/create` | Create a function group and function module |
| `/function/check` | Check a function module by compiling its function group program |
| `/function/source_save` | Update source of an existing Z function module include. The handler resolves the function module to its generated `LZ*Uxx` include and validates that it belongs to the Z function group before saving. |
| `/include/source_save` | Update a generated `LZ*` function group include for a Z function group. Allows `TOP`, `Fxx`, `Oxx`, and `Ixx`; rejects `Uxx` so function module source must go through `/function/source_save`. Payload requires `function_group`, `include_name`, and full `source_code`; optional `check_function` runs `/function/check` after save. |
| `/function/main_source_save` | Update a `SAPLZ*` function group main include list |
| `/message/save` | Maintain message texts in an existing `Z*` message class. Does not create message classes. Payload supports one or more `{ number, text }` entries, optional `language`, and optional `transport`; `number` may be `AUTO` to allocate from max existing `T100-MSGNR + 1` in range `001-999`; verify usage through `/object/check` with `MESSAGE ...(<message_class>)`. |
| `/textpool/save` | Maintain report or function group textpool entries for existing `Z*` objects. Supports `PROG`/`REPORT`, `FUGR`, and `FUNC`; `I` text symbols support `key = AUTO` to allocate from max existing numeric key + 1; saves by reading, merging, `INSERT TEXTPOOL`, and readback verification. |
| `/dynpro/import_from_json` | Create or update a generated Dynpro screen from JSON. Supports table controls, explicit `flow_logic`, special selection columns, `replace_existing`, and default self `next_screen`. |
| `/dynpro/import_screen` | Create or update a generated normal Dynpro screen from JSON using only `screen_elements` and optional `flow_logic`; does not require or create table controls or custom controls. |
| `/dynpro/import_custom_control` | Create or update a generated Dynpro screen from JSON with one or more Dynpro `CUST_CTRL` containers for OO ALV/custom controls. This is separate from `/dynpro/import_from_json` and does not create table controls. |
| `/dynpro/import_layout` | Create or update a generated Dynpro screen from JSON with explicit `containers[]` plus `screen_elements[]`. Use this for layout containers such as `SUBSCREEN` and `STRIP_CTRL`/tabstrip structures without changing the normal, table-control, or custom-control import behavior. |
| `/transport/create` | Create a new SAP Transport Request (TRKORR, Workbench/Customizing) |
| `/run` | Combined DDIC create plus ABAP check/save/activate flow |
| `/capabilities` | Return handler feature flags for capability-aware clients |
| `/probe/run` | Run controlled probe checks. Supports whitelisted `ZSDRP_AI_MCP_*` runner reports and built-in `CLASS_ACTIVATION_CHECK` for class check-only activation diagnostics. |
| `/debug/dynpro_read` | Inspect Dynpro containers, fields, field/container mapping, and selected table-control attributes. |
| `/debug/fm_interface` | Inspect function module interface |
| `/debug/ddic_fields` | Inspect active DDIC table or structure fields |
| `/debug/ddic_type` | Inspect runtime ABAP type structure |
| `/debug/domain_values` | Inspect fixed values of a DDIC domain |
| `/debug/class_methods` | Inspect class methods and parameters |
| `/class/method/read` | Read a single global class method source when supported. Supports `version = ACTIVE` default, `INACTIVE`, or `BOTH` when deployed. |
| `/debug/locks` | Inspect enqueue locks |

## Recommended Future Read Endpoints

| PATH_INFO | Purpose |
|---|---|
| `/function/read` | Read a function module source directly with group and include metadata. Use `"source_format": "STRING"` by default when supported. |
| `/function_group/read` | Read a full function group and active includes. Use `"source_format": "STRING"` by default. |
| `/class/read` | Read global class definition, implementation, methods, and generated includes |


