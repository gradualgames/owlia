.ifndef KEY_CONSTANTS_INC
KEY_CONSTANTS_INC = 1

KEY_FAMILIAR_X_OFFSET = $04
KEY_FAMILIAR_Y_OFFSET = $10

.enum
KEY_STATE_INIT
KEY_STATE_PICKUP
KEY_STATE_PASSIVE_INIT
KEY_STATE_PASSIVE_INSERTED_INIT
KEY_STATE_PASSIVE
.endenum

key_initial_state = entity_local0
key_puzzle_flags_mask = entity_local1

.endif
