# Examples

## DDIC Payload

```json
{
  "package": "$TMP",
  "transport": "",
  "domains": [
    {"name": "ZD_FULL092_ID", "data_type": "CHAR", "length": 12, "decimals": 0, "description": "Full Test 092 ID", "values": []}
  ],
  "data_elements": [
    {"name": "ZE_FULL092_ID", "domain": "ZD_FULL092_ID", "description": "Full Test 092 ID", "short_text": "Test ID", "medium_text": "Full Test ID", "long_text": "Full Test Identifier", "heading": "Test ID"}
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
        {"name": "MANDT", "data_element": "MANDT", "key_flag": true, "not_null": true, "position": 1},
        {"name": "TEST_ID", "data_element": "ZE_FULL092_ID", "key_flag": true, "not_null": true, "position": 2}
      ]
    }
  ]
}
```

## Report Payload

```json
{
  "object_type": "PROG",
  "object_name": "ZSDRPAI_MCP_FULL092_TEST",
  "package": "$TMP",
  "transport": "",
  "source_code": "REPORT zsdrpAI_MCP_full092_test.\nWRITE 'OK'."
}
```

## Function Payload

```json
{
  "function_group": "ZSDG_AI_MCP_SIMPLE",
  "function_name": "ZSDF_AI_MCP_SIMPLE",
  "package": "$TMP",
  "transport": "",
  "short_text": "Simple AI_MCP function",
  "importing": [{"name": "IV_MATNR", "type": "MARA-MATNR"}],
  "exporting": [{"name": "EV_MTART", "type": "MARA-MTART"}],
  "changing": [],
  "tables": [],
  "source_code": "FUNCTION zsdf_AI_MCP_simple.\n  CLEAR ev_mtart.\n  SELECT SINGLE mtart FROM mara INTO ev_mtart WHERE matnr = iv_matnr.\nENDFUNCTION."
}
```

## Message Payload

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

## Textpool Payload

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


## Dynpro Table Control Payload

Minimal shape for a tested report table-control screen update:

```json
{
  "program": "ZSDRP_AI_MCP_TC_M14",
  "screen": "9012",
  "description": "AI_MCP toolbar table control for ZSDT_CONT_M_14",
  "replace_existing": true,
  "screen_lines": 24,
  "screen_columns": 120,
  "ok_code": "OK_CODE",
  "table_control": {
    "name": "TC_CONT_M14",
    "data_table": "GT_CONT_M14",
    "line": 4,
    "column": 1,
    "length": 116,
    "height": 12,
    "lines_variable": "G_TC_CONT_M14_LINES",
    "separ_v": true,
    "separ_h": true,
    "scroll_v": true,
    "scroll_h": true,
    "resize_v": true,
    "resize_h": true,
    "config": true,
    "select_lines": true,
    "line_selector": true,
    "fixed_columns": 1,
    "line_min": 5,
    "column_min": 15
  },
  "columns": [
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
    },
    {
      "field": "ZXH",
      "heading_text": "ZXH",
      "column": 1,
      "length": 3,
      "vislength": 3,
      "input": true,
      "output": true,
      "generate_heading": true
    }
  ],
  "screen_elements": [
    {
      "name": "PB_INSR",
      "type": "PUSH",
      "line": 2,
      "column": 4,
      "length": 4,
      "vislength": 3,
      "fcode": "TC_CONT_M14_INSR",
      "icon_name": "ICON_INSERT_ROW",
      "group1": "MOD"
    }
  ],
  "flow_logic": [
    "PROCESS BEFORE OUTPUT.",
    "  MODULE TC_CONT_M14_CHANGE_TC_ATTR.",
    "  LOOP AT GT_CONT_M14",
    "       WITH CONTROL TC_CONT_M14",
    "       CURSOR TC_CONT_M14-CURRENT_LINE.",
    "    MODULE TC_CONT_M14_GET_LINES.",
    "  ENDLOOP.",
    "  MODULE STATUS_9012.",
    "PROCESS AFTER INPUT.",
    "  LOOP AT GT_CONT_M14.",
    "    CHAIN.",
    "      FIELD GT_CONT_M14-ZXH.",
    "      MODULE TC_CONT_M14_MODIFY ON CHAIN-REQUEST.",
    "    ENDCHAIN.",
    "    FIELD GT_CONT_M14-FLAG",
    "      MODULE TC_CONT_M14_MARK ON REQUEST.",
    "  ENDLOOP.",
    "  MODULE TC_CONT_M14_USER_COMMAND."
  ]
}
```

Do not send `next_screen` for the common case; JSON Dynpro import defaults it to the current screen number. Send `next_screen` only for an intentional different next screen.

## Dynpro Custom Control Payload

Use `/dynpro/import_custom_control` for an OO ALV or other custom-control screen. The custom control name must match the ABAP `CL_GUI_CUSTOM_CONTAINER` `container_name`.

The custom control belongs only in `custom_controls[]`. Do not add `CC_PO_ALV` or another custom-control placeholder to `screen_elements[]`; SAP Dynpro import represents it as a `CUST_CTRL` container, not as a normal field.

```json
{
  "program": "ZDEMO_D05",
  "screen": "9001",
  "description": "PO Management Platform",
  "replace_existing": true,
  "screen_lines": 24,
  "screen_columns": 160,
  "ok_code": "OK_CODE",
  "custom_controls": [
    {
      "name": "CC_PO_ALV",
      "line": 18,
      "column": 1,
      "length": 158,
      "height": 5,
      "resize_v": true,
      "resize_h": true
    }
  ],
  "screen_elements": [
    {
      "name": "PB_PO_CREATE",
      "type": "PUSH",
      "text": "Create PO",
      "line": 5,
      "column": 2,
      "length": 12,
      "vislength": 12,
      "fcode": "PO_CRT"
    }
  ],
  "flow_logic": [
    "PROCESS BEFORE OUTPUT.",
    "  MODULE STATUS_9001.",
    "PROCESS AFTER INPUT.",
    "  MODULE USER_COMMAND_9001."
  ]
}
```

Expected `/debug/dynpro_read` container verification:

```json
[
  { "type": "SCREEN", "name": "SCREEN" },
  {
    "type": "CUST_CTRL",
    "name": "CC_PO_ALV",
    "element_of": "SCREEN",
    "line": "018",
    "column": "001",
    "length": "158",
    "height": "005"
  }
]
```

There must be no `TABLE_CTRL` container for OO ALV screens.

## Historical Tested Objects

Treat these as historical examples only; default new creation uses `$TMP` and empty transport.

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
