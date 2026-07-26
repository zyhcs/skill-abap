# Function Module Playbook

## Naming And Interface Rules

- Function groups must use `ZSDG_*`.
- Function modules must use `ZSDF_*`.
- `IMPORTING`, `EXPORTING`, and `CHANGING` scalar parameter `type` values must be existing DDIC table-field references such as `MARA-MATNR`, `BSEG-WRBTR`, or `TLINE-TDLINE`.
- Do not use standalone data elements such as `MATNR` for scalar function parameters.
- `TABLES` parameter `type` values must be existing DDIC table or structure names such as `MARA` or `BAPIRET2`.

## Create And Check

1. Call `/function/create` with function group, function name, interface, package, transport, and function body source. Do not include outer `FUNCTION ... ENDFUNCTION`; the handler wraps create source.
2. Call `/function/check` with `function_name`.
3. If check fails, repair the full source.
4. Call `/function/source_save` with full include source including `FUNCTION ... ENDFUNCTION`.
5. Repeat `/function/check` within the requested retry limit.
6. For non-`$TMP`, verify the transport contains `R3TR FUGR <function_group>`.

Hybrid SDK Lite normalizes this contract: `function deploy` strips an accidental outer wrapper before `/function/create`, and `function repair` adds the wrapper before `/function/source_save` if the caller provides only a body.

## Final Syntax Authority

Use `/function/check` as the final syntax validation. Do not judge a function module by running `/object/check` against generated includes such as `LZ*U01`; standalone include checks can return the expected false error `FUNCTION cannot be used in the current environment`.

## Include Save Rule

When saving generated `LZ*` include programs, the ABAP program type must be `I`:

```abap
INSERT REPORT lv_include FROM lt_source PROGRAM TYPE 'I'.
```

Use this for generated `LZ*TOP`, `LZ*O01`, `LZ*I01`, `LZ*F01`, and function module include programs such as `LZ*Uxx`. Do not use program type `I` for `SAPLZ*` function group main programs or normal reports.


## Generated Include Save

Use `/include/source_save` for generated function group includes that are not function module source includes:

- Allowed: `L<function_group>TOP`, `L<function_group>Fxx`, `L<function_group>Oxx`, `L<function_group>Ixx`.
- Rejected: `L<function_group>Uxx`. Save function module source through `/function/source_save` so the handler can resolve and validate the `function_name` to its exact generated `Uxx` include.
- The include name must be `LZ*`, and the second character must be `Z`; this blocks standard or non-Z function group includes.
- The include must belong to the requested Z function group, i.e. match `L<function_group>*`.
- Save generated include source with ABAP program type `I`.
- Pass `check_function` when possible so the handler runs `/function/check` after the include save.

Payload example:

```json
{
  "function_group": "ZSDG_0012",
  "include_name": "LZSDG_0012I01",
  "source_code": "...complete include source...",
  "check_function": "ZSDF_SO_CHANGEX_ARC"
}
```
## Main Program Include List

`/function/main_source_save` is restricted to `SAPLZ*` main programs and only allows `TOP`, `UXX`, `Fxx`, `Oxx`, and `Ixx` includes belonging to the same generated Z function group. It must reject includes outside `L<function_group>*` and non-`LZ*` generated includes.
