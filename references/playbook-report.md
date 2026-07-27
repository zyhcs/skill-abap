# Report Playbook

## Default Report Template

When generating or creating new ABAP report programs, ALWAYS load and use `templates/report_standard_alv_template.abap` as the mandatory base template unless the user explicitly requests a different template or structure.

## Create Or Update Report

1. Prepare payload:

```json
{
  "object_type": "PROG",
  "object_name": "ZSDRPAI_MCP_EXAMPLE",
  "package": "$TMP",
  "transport": "",
  "source_code": "REPORT zsdrpAI_MCP_example.\nWRITE 'OK'."
}
```

2. Call `/object/check`.
3. Fix syntax errors if any.
4. Call `/object/save`.
5. Call `/object/activate`.

## Report Directory Attributes

When saving generated reports, keep the report Application empty, enable fixed point arithmetic, and mark the report Unicode-compatible. The handler should write the report with a `TRDIR` directory entry where `APPL = space`, `SUBC = '1'`, `FIXPT = 'X'`, and `UCCHECK = 'X'`, instead of relying on SAP defaults.

Use the same directory-entry context when syntax-checking report source. `/object/check` and the syntax status returned by `/object/read` should run `SYNTAX-CHECK ... DIRECTORY ENTRY ...` with `SUBC = '1'`, `APPL = space`, `FIXPT = 'X'`, and `UCCHECK = 'X'`. New Open SQL forms such as comma-separated field lists, host variables with `@`, and `INTO TABLE @DATA(...)` can otherwise fail with a misleading fixed point arithmetic error even when the ABAP release supports the syntax.

## Read Report Or Include

Use `/object/read` with `object_type = PROG` and `object_name` set to the report or include name.

Successful responses can include `source_code`, `source_lines`, line counts, and syntax messages. Use `source_code` as the canonical returned source string; use `source_lines` only for line-number display or diagnostics.

## Save Standalone Include

Use `/object/save` with `object_type = "PROG"` and explicitly pass `program_type = "I"` or `subc = "I"` for standalone ABAP includes:

```json
{
  "object_type": "PROG",
  "object_name": "ZDEMO_D05_TOP",
  "package": "$TMP",
  "transport": "",
  "program_type": "I",
  "subc": "I",
  "source_code": "*&---------------------------------------------------------------------*\n*& Include      ZDEMO_D05_TOP\n*&---------------------------------------------------------------------*"
}
```

This path must save with ABAP program type Include only for explicit include payloads. It must not change normal report saves. Do not activate a standalone include directly; activate or check the owning executable program when one exists, or read the include back to verify the save.

## Probe Runner Protocol

Use `/probe/run` for controlled runtime checks through whitelisted probe runner reports. The first supported runner shape is a report named `ZSDRP_AI_MCP_*` with parameter `P_MEMID TYPE C LENGTH 80`.

The runner must export a standard table named `GT_RESULT` to ABAP memory using the supplied memory id. Result rows should contain `NAME`, `STATUS`, `SEVERITY`, `OBJECT_TYPE`, `OBJECT_NAME`, `STAGE`, `VALUE`, and `MESSAGE` fields. `/probe/run` imports `GT_RESULT`, frees the memory id, and returns the rows as JSON.

Example payload:

```json
{
  "runner": "ZSDRP_AI_MCP_PROBE_0615"
}
```

Security rule: do not execute arbitrary reports through `/probe/run`; allow only `ZSDRP_AI_MCP_*` probe runner reports.

## Built-In Class Activation Probe

Use `/probe/run` with `probe_id = CLASS_ACTIVATION_CHECK` when a global class cannot activate and detailed syntax/checklist messages are needed without creating a temporary runner report.

Example payload:

```json
{
  "probe_id": "CLASS_ACTIVATION_CHECK",
  "class_name": "ZCLSD_AI_MCP_0613H"
}
```

The handler calls `RS_WORKING_OBJECTS_ACTIVATE` with `CHECK_ONLY = ABAP_TRUE`, `UI_DECOUPLED = ABAP_TRUE`, `SUPPRESS_ENQUEUE = ABAP_TRUE`, `SUPPRESS_INSERT = 'X'`, `SUPPRESS_CORR_INSERT = 'X'`, and `WITH_POPUP = SPACE`. It does not modify the target class source and returns `CL_WB_CHECKLIST->GET_ERROR_MESSAGES` as JSON rows such as `CHECKLIST_ERROR_TEXT`, `CHECKLIST_ERROR_LINE`, `CHECKLIST_ERROR_CODE`, and `CHECKLIST_ERROR_TYPE`.

Use this built-in probe before relying on `SEO_CLASS_ACTIVATE` when the goal is diagnostics, because `SEO_CLASS_ACTIVATE` often returns only a coarse failure status.
