# Message Save Playbook

Use this playbook for `/message/save`, which maintains message texts inside an existing `Z*` message class. This endpoint creates or updates message numbers only; it does not create the message class itself. Explicit three-digit numbers are upserted; `number = "AUTO"` is allocated as create-only.

## Flow

1. Create a JSON payload file with `message_class`, optional `language`, optional `transport`, and a `messages` array.
2. Call `/message/save` through the base `/sap/bc/zai_mcp_rest` URL with `PATH_INFO: /message/save`.
3. Require top-level `"status":"OK"`.
4. Check every `results[]` entry:
   - `status` must be `OK`.
   - `expected_text` and `actual_text` must match.
5. Verify usage with `/object/check` on a temporary report that references every new message number.

## Payload

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

## Validation Rules

- `message_class` must already exist in `T100A`.
- Only `Z*` message classes are allowed.
- `number` must be `AUTO` or exactly three digits, `000` to `999`.
- Explicit numbers are upserted.
- `AUTO` numbers are allocated from the current maximum `T100-MSGNR` in range `001-999`, then incremented in payload order.
- If no existing number is found in `001-999`, `AUTO` starts from `001`.
- If allocation would exceed `999`, the request returns `MESSAGE_NUMBER_RANGE_FULL` and saves nothing.
- If allocated numbers conflict with explicit numbers in the same request, the request returns a validation error and saves nothing.
- `text` is required and must not exceed 73 characters.
- One request handles one language. For multiple languages, call once per language.
- Multiple messages may be sent in one request.
- The handler validates the full payload before saving any entry.

## CTS

`transport` is optional. When provided, the handler appends:

```text
R3TR MSAG <message_class>
```

If the message class is already locked in another request, return the structured SAP CTS error. Do not bypass CTS by writing SAP repository or transport tables directly.

## Verification

Use `/object/check` with a temporary report such as:

```abap
REPORT zai_mcp_rest_msg_multi_probe.
START-OF-SELECTION.
  MESSAGE s997(zsd_01) WITH 'ONE'.
  MESSAGE s998(zsd_01) WITH 'TWO'.
```

A successful save returns `requested_number` and actual `number`; use the actual number in follow-up checks. A successful check returns:

```json
{"status":"OK","messages":[]}
```

## Implementation Notes

The current deployed handler uses SE91 BDC, not direct writes to `T100` or `T100A`.

Known tested screen flow on the current system:

```text
SAPLWBMESSAGES 0100
  RSDAG-ARBGB
  RSDAG-MSGFLAG = X
  MSG_NUMMER
  BDC_OKCODE = =WB_EDIT

SAPLWBMESSAGES 1000
  T100-TEXT(01)
  BDC_OKCODE = =WB_SAVE

SAPLWBMESSAGES 1000
  BDC_OKCODE = =WB_BACK

SAPLWBMESSAGES 0100
  BDC_OKCODE = =WB_END
```

If BDC returns screen mismatch `00 344`, inspect the actual SE91 screens with `/debug/dynpro_read`. On this system the message table is in screen `0101` as a subscreen of `1000`, but batch input records target the main screen `1000`.

## Tested

Confirmed on `ZSD_01`:

- Single message `999`, text `AI_MCP REST message save test &`.
- Multi-message request for `997` and `998`.
- `/object/check` verified `MESSAGE e999(zsd_01)`, `MESSAGE s997(zsd_01)`, and `MESSAGE s998(zsd_01)`.

