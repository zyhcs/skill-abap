# Class Playbook

## Save And Activate Class

1. Prepare class payload with `object_type = CLAS`, class name, package, transport, and full class source.
2. Call `/object/save`.
3. Call `/object/activate`.
4. Verify with `/debug/class_methods`.
5. When behavior matters, call `/object/check` on a temporary report that instantiates or calls the public class API.

## Activation Diagnostics

When class activation fails and `SEO_CLASS_ACTIVATE` does not return enough detail, call `/probe/run` with the built-in `CLASS_ACTIVATION_CHECK` probe:

```json
{
  "probe_id": "CLASS_ACTIVATION_CHECK",
  "class_name": "ZCLSD_EXAMPLE"
}
```

The probe uses `RS_WORKING_OBJECTS_ACTIVATE` in check-only mode and returns `CL_WB_CHECKLIST` messages as JSON. In Hybrid SDK Lite, use:

```powershell
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_client.py class activation-check ZCLSD_EXAMPLE
```

## Class Creation Notes

- The current class parser supports simple public instance methods.
- Supported method parameters include `IMPORTING`, `EXPORTING`, `CHANGING`, and `RETURNING VALUE(...)`.
- Methods and parameters must be written as active version so the compiler can see public methods.
- Activation uses the server-side SAP class APIs exposed by the handler.
- Generated classes should enable fixed point arithmetic by setting `VSEOCLASS-FIXPT = 'X'`.
- Do not use direct repository table updates.

## Read Existing Class

Prefer `/object/read` with `object_type = CLAS` if the deployed handler supports class source read.

A full handler should read the generated class pool program, expand generated class includes, and expand Class Builder `include methods.` using method include metadata.

If `/object/read` returns `Only PROG/REPORT source read is implemented`, the deployed handler is older and needs server-side enhancement. `/debug/class_methods` is useful for active metadata but is not a full source read.

## Read Method Versions

Use `/class/method/read` to read a single method. Omit `version` for the compatible default active source, or pass `INACTIVE` / `BOTH` when diagnosing activation errors that are not visible in active source.

```json
{
  "class_name": "ZCLSD_EXAMPLE",
  "method_name": "GET_TEXT",
  "version": "INACTIVE",
  "source_format": "STRING"
}
```

`BOTH` returns a `versions` array with active and inactive source entries. Prefer `STRING` to keep the response compact unless line objects are needed.

## Repair Method Source

Use `/object/repair` for narrow class method fixes when the inactive method source is broken and full class save would be too heavy. Current support is limited to `CLAS` method include source.

Payload example:

```json
{
  "object_type": "CLAS",
  "object_name": "ZCLSD_EXAMPLE",
  "target": {
    "kind": "METHOD",
    "name": "GET_TEXT",
    "version": "INACTIVE"
  },
  "source_code": "  METHOD get_text.\n    DATA lw_mara TYPE mara.\n    SELECT SINGLE * FROM mara INTO lw_mara.\n    rv_text = 'OK'.\n  ENDMETHOD.",
  "check_after_save": true,
  "activate_after_check": false
}
```

The handler also accepts flat fallback fields `target_kind`, `target_name`, and `target_version` for compatibility. Send the complete method include source with outer `METHOD ... ENDMETHOD`; `target.version = INACTIVE` writes the inactive version and `ACTIVE` writes the active version.

Hybrid SDK Lite command:

```powershell
python C:\Users\WangYong\.AI_MCP\skills\sap-ai-mcp-rest-api\scripts\sap_ai_mcp_client.py class repair-method C:\work\repair_payload.json
```

## Lifecycle Loop

Use `/object/lifecycle` when the server should orchestrate check, optional repair, activation, and verification in one response. The default repair loop is 3 rounds, with a hard maximum of 5.

Class lifecycle repair payload example:

```json
{
  "object_type": "CLAS",
  "object_name": "ZCLSD_EXAMPLE",
  "mode": "REPAIR_CHECK_ACTIVATE",
  "repair": {
    "target": {
      "kind": "METHOD",
      "name": "GET_TEXT",
      "version": "INACTIVE"
    },
    "source_code": "  METHOD get_text.\n    rv_text = 'OK'.\n  ENDMETHOD."
  },
  "options": {
    "max_repair_rounds": 3
  }
}
```

The endpoint does not invent repairs by itself. The caller supplies each repair source; the endpoint enforces the order: check, repair, check again, activate only after check passes, then verify.
