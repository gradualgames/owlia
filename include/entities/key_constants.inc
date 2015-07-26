.linecont +
.ifndef KEY_CONSTANTS_INC
KEY_CONSTANTS_INC = 1

;note---exposing these states as callable routines is a break from
;patterns throughout the game engine. It turned out to be very useful
;to have these states run together when initializing the unlock state
;so that the key is fully initialized and drawn on the same frame as
;the owl begins flying while carrying the key, with the key properly
;aligned with the owl. In the future, I hope to do much more of this
;sort of thing because it doesn't make sense to wait a whole frame for
;initialization to occur.
.global key_state_init
.global key_state_passive_init

KEY_FAMILIAR_X_OFFSET = $04
KEY_FAMILIAR_Y_OFFSET = $10

.enum
KEY_STATE_INIT
KEY_STATE_PICKUP
KEY_STATE_PASSIVE_INIT
KEY_STATE_PASSIVE_INSERTED_INIT
KEY_STATE_PASSIVE
.endenum

define_entity_properties key_initial_state, key_dungeon_flags_mask

.endif
