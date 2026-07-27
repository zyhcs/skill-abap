# SAP Function Module Dynamic Execution Playbook

Use this playbook when dynamically executing any standard (BAPI) or custom (`Z*`) Function Module in SAP via REST.

## Endpoint: `/function/execute`

### Request Payload Example

```json
{
  "function_name": "BAPI_MATERIAL_GET_DETAIL",
  "importing": {
    "MATERIAL": "000000000000000001",
    "PLANT": "1000"
  },
  "changing": {},
  "tables": {}
}
```

### Response Format

```json
{
  "STATUS": "OK",
  "SUBRC": 0,
  "MESSAGE": "",
  "PARAMETERS": [
    {
      "NAME": "MATERIAL_GENERAL_DATA",
      "KIND": 20,
      "VALUE": {
        "MATL_TYPE": "FERT",
        "BASE_UOM": "PC"
      }
    }
  ]
}
```

*Note: `KIND` indicates parameter type (10=IMPORTING from FM, 20=EXPORTING from FM, 30=CHANGING, 40=TABLES).*

## CLI Usage

```bash
python3 sap_ai_mcp_client.py --profile dev200 call /function/execute payload.json
```
