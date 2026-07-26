# Existing Object Read Playbook

## Default Read Mode

For all read endpoints, pass `"source_format": "STRING"` by default unless line-array output is explicitly required.

Treat `source_code` as the primary source of truth. Use `source_lines` only for UI line rendering or line-array debugging.

For large responses, write the response to a file with `curl -o` and inspect summaries or method-level snippets instead of printing full source into the conversation.
Use payload files encoded as ASCII or UTF-8 without BOM for read calls.

When supported, read/status responses should include object directory information under `tadir`, including `package` and `devclass`. Use this to verify `$TMP` and transport package behavior instead of inferring package state from source read success.

## Report Or Include

1. Call `/object/read` with `object_type = PROG` and `object_name` set to the report or include name.
2. Treat `source_code` as the source of truth when repository read status is OK.
3. Use `source_lines` only as an auxiliary line-number view for diagnostics or discussion. Do not rebuild or save source from a line array unless the endpoint explicitly requires it.

## Function Module

Preferred flow: call `/function/read` if the deployed handler supports it.

Compatible fallback:

1. Call `/function/check` with `function_name` to discover `function_group`, `program`, and `include`.
2. Call `/object/read` with `object_type = PROG` and `object_name` set to the returned include.
3. Ignore the expected standalone include syntax error `FUNCTION cannot be used in the current environment`; use `/function/check` as the final syntax result.

## Function Group

Preferred flow: call `/function_group/read` if the deployed handler supports it.

Compatible fallback:

1. Read `SAPL<function_group>` with `/object/read`.
2. Parse uncommented `INCLUDE` statements.
3. Read TOP, UXX, Fxx, Oxx, Ixx, and function module Uxx includes with `/object/read`.
4. For UXX entries, read the referenced `L<function_group>Uxx` function module includes separately.

## Global Class

1. Prefer `/object/read` with `object_type = CLAS` if supported.
2. A full read should expand generated class includes and Class Builder method includes.
3. If unsupported, use `/debug/class_methods` only for metadata and report that full class source read needs handler enhancement.

## Response Guidance

Keep repository read status separate from standalone syntax status. Includes can be read successfully while standalone syntax analysis fails.

Default to string source handling: read, edit, save, and repair ABAP source through `source_code` string fields. Line arrays are diagnostic metadata, not the default source transport format.

## Global Class Method

Optimized handlers expose `/class/method/read`. Use it when available to read one method without transferring the full class source:

```json
{
  "class_name": "ZCLSD_EXAMPLE",
  "method_name": "UPDATE_REMARK",
  "source_format": "STRING"
}
```

If `/class/method/read` is not available, call `/object/read` with `object_type = "CLAS"` and extract `METHOD <method_name> ... ENDMETHOD` from `source_code`.
