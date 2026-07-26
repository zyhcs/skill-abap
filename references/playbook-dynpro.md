# Dynpro Playbook

## Import And Verify Generated Dynpro

1. Build the generated Dynpro JSON layout payload as a file.
2. For an existing screen, set `replace_existing = true`; otherwise `RPY_DYNPRO_INSERT` can return `Dynpro <program> <screen> already exists`.
3. Call `/dynpro/import_from_json` for table-control screens, or `/dynpro/import_screen` for normal screens that have no `table_control` or `custom_controls`.
4. Call `/debug/dynpro_read` to inspect containers, fields, and field/container mapping.
5. Activate/check the owner object:
   - Report screen: `/object/activate`, then `/object/check`.
   - Function group screen: `/function/check` for the target function module or generated group program.

## Endpoint Notes

There is no `/dynpro/read` endpoint in the current handler contract. Use `/debug/dynpro_read` for readback verification.

Dynpro screen numbers for generated screens must use the `9___` range.

For generated normal screens, the handler should default `D020S-NEXTSCREEN` to the current screen number. Pass `next_screen` only when an intentional different next screen is required.

## Normal Screens

Use `/dynpro/import_screen` when the screen only needs regular `screen_elements[]`, an optional `ok_code`, and optional `flow_logic`. This endpoint intentionally does not require `table_control` or `custom_controls[]`.
Set `screen_type = "I"` when the target must be a true subscreen for `CALL SUBSCREEN`; omit it or set `screen_type = "N"` for the default normal screen.

## Custom Control / OO ALV Screens

Use `/dynpro/import_custom_control` when the screen should host an OO ALV or other custom control through `CL_GUI_CUSTOM_CONTAINER`.

Rules:

- Do not use `/dynpro/import_from_json` for OO ALV container-only screens; that endpoint intentionally creates a table control.
- Provide at least one entry in `custom_controls[]` with the exact `container_name` used by ABAP, for example `CC_PO_ALV`.
- The handler must write custom controls to `DYCATT_TAB` as container type `CUST_CTRL`. Do not use `CUSTOM_CONTROL` or `CUSTOM` as `DYNPFIELD_ATTR-TYPE`; SAP rejects those values.
- Do not also add the custom-control name to `screen_elements[]`. The placeholder is a container, not a normal screen field. `/debug/dynpro_read` should show `containers[].type = "CUST_CTRL"` and `containers[].name = "<container_name>"`.
- Keep ALV field catalog and grid columns in ABAP code; the Dynpro payload should create only the custom control placeholder and surrounding labels/buttons/input fields.
- Use `flow_logic` for the screen PBO/PAI modules only. Do not include table-control `LOOP ... WITH CONTROL` blocks for OO ALV screens.

Expected readback for an OO ALV placeholder:

```text
containers:
  type       = CUST_CTRL
  name       = CC_PO_ALV
  element_of = SCREEN

TABLE_CTRL count = 0
```

## Explicit Layout / Tabstrip Screens

Use `/dynpro/import_layout` when the screen needs Dynpro containers that are not covered by the normal, table-control, or custom-control importers, especially `SUBSCREEN` areas and tabstrips represented as `STRIP_CTRL`.

Rules:

- Existing importers stay unchanged: `/dynpro/import_screen` still maps every field to `SCREEN`, `/dynpro/import_from_json` still creates one table control, and `/dynpro/import_custom_control` still creates only `CUST_CTRL` placeholders.
- Payload `screen_type` is optional and defaults to normal screen type `N`; use `I` only for true subscreen definitions.
- Payload `containers[]` maps to `DYCATT_TAB`; include explicit container names, types, parent `element_of`, coordinates, and size.
- Payload `screen_elements[]` may set `container` to place a field in `SCREEN`, `STRIP_CTRL`, or another defined container.
- For tabstrip tab buttons, set `container` to the tabstrip container name, `type` to `PUSH`, `fcode` to the tab function code, and `ref_field` to the subscreen area.
- Flow logic must be supplied explicitly when using subscreens or tabstrips, for example `CALL SUBSCREEN ...` and active-tab PBO/PAI modules.

Minimal tabstrip shape:

```json
{
  "program": "ZDEMO_D06",
  "screen": "9050",
  "description": "Layout screen with tabstrip",
  "replace_existing": true,
  "screen_lines": 40,
  "screen_columns": 160,
  "ok_code": "OK_CODE",
  "containers": [
    {
      "name": "SUB9051",
      "type": "SUBSCREEN",
      "element_of": "SCREEN",
      "line": 6,
      "column": 4,
      "length": 148,
      "height": 13
    },
    {
      "name": "TAB9010",
      "type": "STRIP_CTRL",
      "element_of": "SCREEN",
      "line": 33,
      "column": 1,
      "length": 151,
      "height": 23,
      "resize_v": true,
      "resize_h": true,
      "line_min": 19,
      "column_min": 18
    },
    {
      "name": "TAB9010_SCA",
      "type": "SUBSCREEN",
      "element_of": "TAB9010",
      "line": 35,
      "column": 2,
      "length": 149,
      "height": 20,
      "resize_v": true,
      "resize_h": true,
      "scroll_v": true,
      "scroll_h": true
    }
  ],
  "screen_elements": [
    {
      "container": "TAB9010",
      "name": "TAB9010_TAB1",
      "type": "PUSH",
      "text": "货物信息",
      "line": 1,
      "column": 1,
      "length": 13,
      "vislength": 8,
      "fcode": "TAB9010_FC1",
      "ref_field": "TAB9010_SCA"
    }
  ],
  "flow_logic": [
    "PROCESS BEFORE OUTPUT.",
    "  CALL SUBSCREEN sub9051 INCLUDING sy-repid g_screen_9050-dynnr1.",
    "  MODULE tab9010_active_tab_set.",
    "  CALL SUBSCREEN tab9010_sca INCLUDING g_tab9010-prog g_tab9010-subscreen.",
    "PROCESS AFTER INPUT.",
    "  CALL SUBSCREEN sub9051.",
    "  CALL SUBSCREEN tab9010_sca.",
    "  MODULE tab9010_active_tab_get.",
    "  MODULE user_command_9050."
  ]
}
```

## Table Control Standard Pattern

Use the SE51 table-control wizard shape as the default for editable generated table controls.

PBO flow:

```abap
PROCESS BEFORE OUTPUT.
*&SPWIZARD: PBO FLOW LOGIC FOR TABLECONTROL 'TC_NAME'
  MODULE TC_NAME_CHANGE_TC_ATTR.
*&SPWIZARD: MODULE TC_NAME_CHANGE_COL_ATTR.
  LOOP AT GT_DATA
       WITH CONTROL TC_NAME
       CURSOR TC_NAME-CURRENT_LINE.
    MODULE TC_NAME_GET_LINES.
*&SPWIZARD:   MODULE TC_NAME_CHANGE_FIELD_ATTR
  ENDLOOP.

  MODULE STATUS_9XXX.
```

PAI flow:

```abap
PROCESS AFTER INPUT.
*&SPWIZARD: PAI FLOW LOGIC FOR TABLECONTROL 'TC_NAME'
  LOOP AT GT_DATA.
    CHAIN.
      FIELD GT_DATA-FIELD1.
      FIELD GT_DATA-FIELD2.
      MODULE TC_NAME_MODIFY ON CHAIN-REQUEST.
    ENDCHAIN.
    FIELD GT_DATA-FLAG
      MODULE TC_NAME_MARK ON REQUEST.
  ENDLOOP.
  MODULE TC_NAME_USER_COMMAND.
```

When exact SE51 flow is needed, send full `flow_logic` in the JSON payload. If `flow_logic` is provided, the handler should use it as the complete flow and not append generated default `FIELD` lines.

## Table Control Selection Column

For the special row-selection checkbox column, use a real work-area/table field such as `FLAG TYPE c LENGTH 1`, and define the column payload like this:

```json
{
  "field": "FLAG",
  "field_type": "CHECK",
  "length": 1,
  "vislength": 1,
  "input": true,
  "output": true,
  "generate_heading": false,
  "selection_column": true,
  "omit_column": true
}
```

Expected readback:

```text
GT_DATA-FLAG:
  type      = CHECK
  column    = 000
  tc_selcol = X
```

The special selection column is not a normal visible text column. Do not assign it a normal table-control `COLUMN` value.

## Table Control Container Attributes

Use these table-control payload flags when matching SE51 wizard output:

```json
{
  "select_lines": true,
  "line_selector": true,
  "fixed_columns": 1,
  "resize_v": true,
  "resize_h": true,
  "config": true,
  "line_min": 5,
  "column_min": 15
}
```

Expected container readback includes:

```text
tc_config  = X
tc_sel_lns = MULTIPLE
tc_sel_cls = NONE
tc_lsel_cl = X
```

## Table Control Toolbar Buttons

For SE51 wizard-style table-control pushbuttons, use icon pushbuttons with function codes based on the table-control name:

| Purpose | Icon | Function code suffix |
|---|---|---|
| Insert row | `ICON_INSERT_ROW` | `INSR` |
| Delete selected rows | `ICON_DELETE_ROW` | `DELE` |
| First page | `ICON_FIRST_PAGE` | `P--` |
| Previous page | `ICON_PREVIOUS_PAGE` | `P-` |
| Next page | `ICON_NEXT_PAGE` | `P+` |
| Last page | `ICON_LAST_PAGE` | `P++` |
| Select all | `ICON_SELECT_ALL` | `MARK` |
| Deselect all | `ICON_DESELECT_ALL` | `DMRK` |

Example function code for table control `TC_CONT_M14`: `TC_CONT_M14_INSR`.

Implement a `USER_OK_TC` dispatcher and helper forms similar to the SE51 table-control wizard: insert row, delete marked rows, compute scrolling, mark all, and demark all. If the user requested physical deletes, delete database rows for marked lines before deleting them from the internal table.

Avoid adding unrelated Save/Back screen pushbuttons unless explicitly requested. Navigation is better handled by the hosting report/application flow.

## Tested Local Pattern

The local report `ZSDRP_AI_MCP_TC_M14` screen `9012` is the current tested pattern for:

- Special selection column (`FLAG`, `TC_SELCOL = X`, `COLUMN = 000`).
- Full wizard-style `flow_logic`.
- Eight table-control toolbar icon buttons.
- `replace_existing = true` update cycle.
- Default self `next_screen`.
