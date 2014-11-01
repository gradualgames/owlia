.ifndef EEL_CONSTANTS_INC
EEL_CONSTANTS_INC = 1

EEL_HEIGHT = $0f
EEL_WIDTH_INDEX_COUNT = 10
EEL_WIDTH_INDEX_DELAY = 4

.enum
EEL_STATE_INIT
EEL_STATE_LEFT_INIT
EEL_STATE_LEFT
EEL_STATE_RIGHT_INIT
EEL_STATE_RIGHT
.endenum

EEL_PARAMS = 1

eel_initial_state = entity_local0
eel_state_counter = entity_local1
eel_width_index = entity_local2
eel_initial_x_lo = entity_local3
eel_initial_x_hi = entity_local4

.endif
