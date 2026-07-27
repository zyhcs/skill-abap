# SAP Transport Automation Playbook

Use this playbook when the user asks to manage SAP transport requests, orchestrate CI/CD pipelines, release requests, copy objects between requests, or push requests to testing environments.

## Endpoints

1. `/transport/search`: Search for unreleased requests belonging to a user (defaults to current profile user).
2. `/transport/create`: Create new requests or Transport of Copies (TOC). Set `target` to create a TOC.
3. `/transport/copy`: Copy physical objects from an unreleased source request to a target request using `TR_REQUEST_CHOICE`, skipping `CORR MERG` entries to avoid lock errors.
4. `/transport/release`: Release a request. Automatically bypasses lock checking for TOCs by using `iv_without_locking = abap_true`.
5. `/transport/import`: Trigger `TMS_MGR_IMPORT_TR_REQUEST` to import a request into the target system buffer. (Note: Recommend running this directly against the target system profile, e.g., `--profile qas600`).

## Automated TOC Pipeline (CI/CD)

When asked to transport an unreleased request to a QA system without releasing the original development request:
1. Discover the unreleased request via `/transport/search`.
2. Create a TOC via `/transport/create`. Use naming convention defined in `rules/object_naming_rules.json`: `TOC_<MODULE>_<DESCRIPTION>_BY_<USER>_<YYYYMMDD>` (or `<MODULE>_<DESCRIPTION>_BY_<USER>_<YYYYMMDD>` for Workbench). Target system is usually `S4Q` or the provided QA SID.
3. Copy objects from the original TR to the TOC via `/transport/copy`.
4. Release the TOC via `/transport/release`.
5. Import the TOC into the QA system via `/transport/import` (use the target system profile).

## Best Practices
- Never use standard SE09 release for development requests if the user only wants to deploy for QA testing; always use the TOC Pipeline to keep the development request open.
- When calling `/transport/import`, it's normal for `subrc = 0` but an empty alert to be returned. This typically means the job was successfully added to the import queue or processed asynchronously by STMS.
