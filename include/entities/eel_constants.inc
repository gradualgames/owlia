.linecont +
.ifndef EEL_CONSTANTS_INC
EEL_CONSTANTS_INC = 1

EEL_INITIAL_HEALTH = 1

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

define_entity_properties eel_initial_state,\
                         eel_width_index_counter,\
                         eel_width_index,\
                         eel_initial_x_lo,\
                         eel_initial_x_hi,\
                         eel_lash_out_counter,\
                         eel_knockback_counter,\
                         eel_direction,\
                         eel_health           ,\
                         eel_flash_counter

.endif
