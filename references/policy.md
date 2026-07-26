# SAP AI MCP REST Policy

## Object Naming & Corporate Rules

Always consult `rules/object_naming_rules.json` for corporate naming rules, module prefixes, and object patterns.
Always consult `rules/coding_variable_rules.md` for variable naming conventions (`lv_`, `lt_`, `ls_`, `iv_`), file header comments, and structure standards.
Always consult `rules/syntax_guidelines.md` for modern Open SQL and forbidden legacy ABAP syntax.
Always consult `rules/data_query_execution_rules.md` for data query limits (`UP TO n ROWS`), pagination, and execution safety.

Use these default fallback prefixes if no corporate rule overrides them:

| Object | Required pattern |
|---|---|
| Domain | `ZD_*` |
| Data element | `ZE_*` |
| Transparent table | `ZSDT_*` |
| Function group | `ZSDG_*` |
| Function module | `ZSDF_*` |
| Report | `ZSDRP*` |
| Class | `ZCLSD_*` |
| Dynpro screen | `9___` |

Use uppercase object names. Preserve a user-provided business abbreviation when it fits SAP length limits.

## Package And Transport

Default new objects to:

```text
Package:   $TMP
Transport:
```

For any package other than `$TMP`, pass a valid modifiable Workbench transport. Function modules are transported through their function group; expect `R3TR FUGR <function_group>`.

For `$TMP` local objects, still register the object directory entry with `DEVCLASS = '$TMP'`. Skip only the CTS append/transport step. Do not leave package/devclass blank.

Do not auto-rename duplicate DDIC objects. Stop and ask the user or report the conflict.

## Access Boundary

Use only the documented `/sap/bc/zai_mcp_rest?sap-client=100` service and documented `PATH_INFO` routes unless the user explicitly approves another SAP path.

Do not access `/sap/bc/adt/*`, other SICF services, or non-`zai_mcp_rest` REST paths without approval.

## Repository Safety

Do not directly update SAP repository or CTS database tables such as `TADIR` or `E071`.

Use SAP APIs exposed by the deployed REST handler. `INSERT REPORT` is allowed only through the handler for generated ABAP repository source includes, not as direct database table modification.

