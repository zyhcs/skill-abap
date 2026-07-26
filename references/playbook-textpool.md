# Textpool Save Playbook

Use this playbook for `/textpool/save`, which maintains ABAP textpool entries for reports and function groups. The endpoint reads the existing textpool, merges the requested entries, saves the full merged textpool, and reads back to verify.

## Supported Objects

- `PROG` / `REPORT`: textpool program is `object_name`.
- `FUGR`: textpool program is `SAPL<function_group>`.
- `FUNC`: resolves the function module in `TFDIR` and maintains the function group's main program textpool.

Only `Z*` reports, function groups, and function modules are allowed.

## Payload

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

## Rules

- `id` must be `I`, `S`, or `R`.
- `I` text symbol keys must be `AUTO` or exactly three digits.
- `AUTO` is only valid for `id = "I"` and allocates from the current maximum existing numeric `I` key in range `001-999`, then increments in payload order.
- Explicit keys are upserted, so check existing textpool when you must avoid overwriting a manually maintained key.
- `S` and `R` keys must be explicit.
- `entry` is required and must fit `TEXTPOOL-ENTRY` length 132.
- One request handles one language. Call again for other languages.
- The handler validates and allocates the full request before saving.

## CTS

`transport` is optional. When provided, the handler appends:

```text
R3TR PROG <program>
```

for reports, or:

```text
R3TR FUGR <function_group>
```

for function groups and function modules.

## Verification

For text symbols, verify the returned actual key:

```abap
REPORT zai_mcp_rest_textpool_probe.
START-OF-SELECTION.
  WRITE text-011.
```

For function groups or function modules, run `/function/check` on a function module in the group after adding or changing text symbols used by generated includes.
