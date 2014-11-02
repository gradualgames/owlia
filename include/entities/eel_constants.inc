.ifndef EEL_CONSTANTS_INC
EEL_CONSTANTS_INC = 1

EEL_INITIAL_HEALTH = 3

EEL_HEIGHT = $0f
EEL_WIDTH_INDEX_COUNT = 10
EEL_WIDTH_INDEX_DELAY = 4

EEL_LINE_OF_SIGHT_WIDTH = 48
EEL_LINE_OF_SIGHT_HEIGHT = 16

EEL_LASH_OUT_LENGTH = 40

EEL_ATTACKED_LENGTH = 40

.enum
EEL_STATE_INIT
EEL_STATE_LEFT_INIT
EEL_STATE_LEFT_WAIT
EEL_STATE_LEFT
EEL_STATE_RIGHT_INIT
EEL_STATE_RIGHT_WAIT
EEL_STATE_RIGHT
.endenum

EEL_PARAMS = 1

eel_initial_state = entity_local0
eel_width_index_counter = entity_local1
eel_width_index = entity_local2
eel_initial_x_lo = entity_local3
eel_initial_x_hi = entity_local4
eel_lash_out_counter = entity_local5
eel_knockback_counter = entity_local6
eel_direction = entity_local7
eel_health            = entity_local8
eel_flash_counter = entity_local9

.endif
