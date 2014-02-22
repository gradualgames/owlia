.ifndef TRAPROOM_CONSTANTS_INC
TRAPROOM_CONSTANTS_INC = 1

TRAPROOM_PARAMS = 1

traproom_raise_state = entity_local0
traproom_state_counter = entity_local1
traproom_trigger_rect_west_x_lo = entity_local2
traproom_trigger_rect_west_x_hi = entity_local3
traproom_trigger_rect_north_y_lo = entity_local4
traproom_trigger_rect_north_y_hi = entity_local5
traproom_trigger_rect_east_x_lo = entity_local6
traproom_trigger_rect_east_x_hi = entity_local7
traproom_trigger_rect_south_y_lo = entity_local8
traproom_trigger_rect_south_y_hi = entity_local9

.enum
TRAPROOM_STATE_INIT
TRAPROOM_STATE_WAIT_FOR_HERO_TO_ENTER_ROOM
TRAPROOM_STATE_WAIT_FOR_ENEMIES_TO_BE_KILLED
;NOTE! The raise and lower states must be in pairs, with
;the raise state first. This is because trap rooms are
;parameterized with the raise state, and the lower state
;is computed as the raise state + 1.
TRAPROOM_STATE_RAISE_MONOLITHS_ALIGNED
TRAPROOM_STATE_LOWER_MONOLITHS_ALIGNED
TRAPROOM_STATE_RAISE_MONOLITH_PAIR
TRAPROOM_STATE_LOWER_MONOLITH_PAIR
.endenum

.endif
