# DDIC REST Playbook

Use `abap-ddic-generator` for DDIC design rules. Use this playbook only for live SAP REST execution.

## DDIC Create Gate

For DDIC creation, treat the payload as the design contract. Validate execution safety, but do not redesign the payload unless the user explicitly asks.

```yaml
ddic_create_gate:
  applies_when: /ddic/create or ddic deploy
  design_source: any
  payload_is_design_contract: true
  agent_must_not_redesign_payload: true

  accepts_payload_shape:
    - package
    - transport
    - domains
    - data_elements
    - tables

  preflight:
    - payload_shape_valid
    - package_transport_valid
    - domain_fixed_values_use_low_high_description_shape
    - no_empty_data_element_labels
    - data_elements_reference_domains
    - table_fields_reference_data_elements
    - curr_quan_refs_present

  sequence:
    - /ddic/validate_names
    - stop_on_existing_object_conflicts
    - /ddic/create
    - /ddic/status
```

## Object Order

1. Domains
2. Data elements
3. Transparent tables

## Flow

1. Build a payload with `package`, `transport`, `domains`, `data_elements`, and `tables`.
2. Call `/ddic/validate_names`.
3. Stop if any object already exists. Do not auto-rename.
4. Call `/ddic/create`.
5. Call `/ddic/status`.

## Live Checks

- Every custom data element must reference an existing or newly created domain.
- Every table field must reference an active data element.
- For domain fixed values in `/ddic/create` payloads, every value row must use
  `low`, `high`, and `description`; set `high` to an empty string for single
  fixed values. Do not use `value` instead of `low`; that malformed shape can
  leave the domain in an inactive local version while activation fails and TADIR
  package registration remains blank.
- For data elements, send non-empty labels. Preferred JSON fields are `short_text`, `medium_text`, `long_text`, and `heading`.
- Accept SAP alias label fields `scrtext_s`, `scrtext_m`, `scrtext_l`, and `reptext` only for compatibility. Treat them as aliases for the preferred label fields, not as separate values.
- If any data element label is missing, derive it from `description` or the data element name before calling `/ddic/create`; do not intentionally create data elements with empty labels.
- Default `$TMP` and empty transport apply unless the user provided package and transport.
- For non-`$TMP`, pass a valid Workbench request.
- Use `/ddic/status` `tadir.package` / `tadir.devclass` fields, when available, to verify object directory package registration.

## Transparent Table Amount/Quantity References

For table fields based on `CURR` or `QUAN` data elements, send reference metadata in the field payload. Preferred field names:

```json
{
  "name": "AMOUNT",
  "data_element": "ZE_EXAMPLE_AMOUNT",
  "reference_table": "ZSDT_EXAMPLE",
  "reference_field": "WAERS"
}
```

Compatibility aliases accepted by the handler are `reftable`, `reffield`, and `precfield`. Prefer `reference_table` and `reference_field` for new payloads. Use `precfield` only when SAP specifically requires the legacy preceding-field relation.

## Transparent Table Not Null Policy

For generated table payloads, set 
ot_null to 	rue only for key fields and MANDT. Non-key fields, including currency/unit reference fields and amount/quantity fields, default to alse unless the user explicitly requires them to be mandatory.

## Default Transparent Table Settings

```json
{
  "delivery_class": "A",
  "data_maintenance": "X",
  "data_class": "APPL0",
  "size_category": "0",
  "storage_type": "C",
  "enhancement_category": "3"
}
```

## Domain Fixed Value Failure Prevention

Correct fixed-value payload shape:

```json
{
  "name": "ZD_EXAMPLE_FLAG",
  "data_type": "CHAR",
  "length": 1,
  "decimals": 0,
  "description": "Example Flag",
  "values": [
    {"low": "Y", "high": "", "description": "Yes"},
    {"low": "N", "high": "", "description": "No"}
  ]
}
```

Incorrect shape to reject before `/ddic/create`:

```json
{
  "values": [
    {"value": "Y", "description": "Yes"}
  ]
}
```

Observed failure mode from the incorrect shape: `/ddic/create` may stop at
`DOMA_ACTIVE_VERIFY` with "Domain activation did not produce active version";
`/ddic/status` then shows the domain as `active = false`, `as4local = L`, and
`tadir.found = false`. Fix the payload shape first, then recreate or repair the
domain through supported SAP APIs.
## Domain Fixed Value Update

Use `/ddic/domain/update_values` when maintaining fixed values on an existing active domain. Do not use `/ddic/create` for this case.

Payload shape:

```json
{
  "domain_name": "ZD_EXAMPLE",
  "language": "E",
  "package": "ZSD001",
  "transport": "S4DK900153",
  "mode": "replace",
  "values": [
    {"low": "01", "high": "", "description": "First Value"},
    {"low": "02", "high": "", "description": "Second Value"}
  ]
}
```

Rules:

- Use only for existing domains; create new domains through `/ddic/create`.
- Preserve the domain technical definition; update fixed values only.
- `mode` must be `replace` or `merge`; default to `replace` only when the user explicitly wants the submitted list to be authoritative.
- Fixed values must use `low`, `high`, and `description`; set `high` to empty string for single values.
- For non-`$TMP` package objects, pass a valid Workbench transport.
- Verify by calling `/debug/domain_values` after update.

