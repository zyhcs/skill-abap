# Troubleshooting

## JSON BOM Parsing Symptoms

Symptoms can include `function_name is required` or `object_name is required` even when the payload visibly contains the field. Some deployed SAP handlers parse UTF-8 files with BOM as empty or invalid JSON.

Client prevention:

```powershell
Set-Content -Path $payload -Value '{"function_name":"ZSDF_EXAMPLE"}' -Encoding ascii
```

For non-ASCII payloads:

```powershell
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($payload, $json, $utf8NoBom)
```

Server-side fix: strip a leading UTF-8 BOM before JSON deserialization and return a clear parse error.

## TK 127

`Changes to objects are only allowed in correction/repair` means the request type or object situation does not allow normal Workbench object append. Use another valid request or check request type, owner, task, and target.

## TR 589

`Combination of object type and function invalid` was observed when `E071-OBJFUNC = 'K'` was invalid for `R3TR PROG`.

Fix:

```abap
ls_e071-objfunc = space.
```

## Function Include False Error

Do not treat include-level `FUNCTION cannot be used in the current environment` from `/object/check` as the function module result. Use `/function/check` after `/function/create` or `/function/source_save`.

## SE91 BDC Screen Mismatch

For `/message/save`, `00 344` with `SAPLWBMESSAGES` screen pairs means the SE91 BDC script does not match the current system screen flow. Use `/debug/dynpro_read` to inspect `SAPLWBMESSAGES` screens and adjust the BDC sequence.

Known current flow:

```text
0100 -> 1000 -> 1000 -> 0100
```

The message table is rendered in subscreen `0101`, but batch input should target main screen `1000` with table-control field `T100-TEXT(01)`.

## Textpool Overwrite Risk

`/textpool/save` merges by `ID + KEY`. Explicit keys are upserted, so they can overwrite existing text elements. For generated text symbols, prefer `id = "I"` with `key = "AUTO"` so the handler reads the current textpool and assigns the next numeric key instead of guessing.

## Fixed Point Syntax Context

If valid new Open SQL, such as comma-separated SELECT fields, `@` host variables, or `INTO TABLE @DATA(...)`, fails with a message that fixed point arithmetic is not activated, the report syntax-check context is wrong. The handler should run report syntax checks with `SYNTAX-CHECK ... DIRECTORY ENTRY ls_trdir` where `SUBC = '1'`, `APPL = space`, `FIXPT = 'X'`, and `UCCHECK = 'X'`. Do not downgrade valid new syntax solely because this error appears.

## Object Directory Issues

- The package displayed in SE11/SE80 comes from `TADIR-DEVCLASS`.
- DDIC activation alone does not guarantee the package field is filled.
- If package is blank, TADIR registration did not complete.

## Type Compatibility

Some SAP APIs require exact DDIC parameter types. Useful examples:

- `DDOBJNAME` for DDIC object names.
- `E070-TRKORR` for transport request.
- `TRBOOLEAN` for dialog flags.
- `E071` table for CTS object append.

## Dynpro Import And Table Control Issues

`Dynpro <program> <screen> already exists` from `/dynpro/import_from_json` means the screen exists and the payload did not request replacement. Set `replace_existing = true` when intentionally updating an existing generated screen.

For OO ALV/custom-control screens, use `/dynpro/import_custom_control`, not `/dynpro/import_from_json`. The latter is for generated table controls and may create `TABLE_CTRL` containers.

If a custom-control import fails with `In DYNPFIELD_ATTR field TYPE has the invalid value CUSTOM_CONT` or `CUSTOM`, the payload or handler is treating the custom control as a normal screen field. Remove the custom control from `screen_elements[]` and ensure the handler writes `custom_controls[]` as `DYCATT_TAB-TYPE = 'CUST_CTRL'`.

Correct OO ALV readback should contain a `CUST_CTRL` container such as `CC_PO_ALV`, and no `TABLE_CTRL`/`TC_*` container for the ALV area.

If SE51 shows `Next Dynpro = 0` for a generated normal screen, the handler wrote `D020S-NEXTSCREEN = '0000'`. Current convention is default self next screen: when `next_screen` is not supplied, JSON import should set next screen to the current screen number.

If a row-selection checkbox appears as a normal/hidden table-control column, ensure the field payload uses `field_type = CHECK`, `selection_column = true`, and `omit_column = true`; readback should show `tc_selcol = X` and `column = 000`.

If a PAI module prompt appears in SE51 even though the report compiles, do not create a duplicate module from the prompt. First read/check the owner report or function group source; generated module definitions may already exist and SE51 may not navigate to them correctly.

If an icon pushbutton import fails with `component ICON_NAME has invalid value`, that icon name is not valid for the target system's Dynpro field attribute. Use a tested SAP icon such as `ICON_INSERT_ROW`, `ICON_DELETE_ROW`, `ICON_FIRST_PAGE`, `ICON_PREVIOUS_PAGE`, `ICON_NEXT_PAGE`, `ICON_LAST_PAGE`, `ICON_SELECT_ALL`, or `ICON_DESELECT_ALL`, or make the button text-only.

For report source payloads, keep `source_code` line endings as LF. A stray carriage return can produce syntax messages such as `The statement "\r FORM" is not expected`.

## Class Method Repair Line Width

`/object/repair` writes method include source through classic report APIs. Keep ABAP source lines short, preferably 72 characters or less, when repairing a method include. Long string-template lines may be truncated by the target system and later produce errors such as `Invalid line break in string template` or `The statement "ENDMETHOD" is missing`.

When repairing REST handler methods, split JSON string templates and long argument lines before sending the repair payload. After repair, read the method back with `/class/method/read` and run a class activation check before using the modified endpoint.
