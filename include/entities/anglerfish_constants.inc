.linecont +
.ifndef ANGLERFISH_CONSTANTS_INC
ANGLERFISH_CONSTANTS_INC = 1

ANGLERFISH_TURN_MODE_RIGHT = 0
ANGLERFISH_TURN_MODE_LEFT = 4
ANGLERFISH_TURN_MODE_OPPOSITE = 8

.enum
ANGLERFISH_PAUSE_MODE_NORMAL
ANGLERFISH_PAUSE_MODE_STOP_GO
.endenum

ANGLERFISH_SPOTLIGHT_ON =  %00000010
ANGLERFISH_SPOTLIGHT_OFF = %00000000

ANGLERFISH_TURN_LENGTH = 70
ANGLERFISH_TURN_LENGTH_LONG = 16*10

ANGLERFISH_PARAMS = 7

define_entity_properties anglerfish_turn_mode,\
                         anglerfish_pause_mode,\
                         anglerfish_turn_length,\
                         anglerfish_direction,\
                         anglerfish_spotlight_on,\
                         anglerfish_initial_offset_x,\
                         anglerfish_initial_offset_y,\
                         ,\
                         anglerfish_x_fine,\
                         anglerfish_y_fine,\
                         anglerfish_turn_counter,\
                         anglerfish_spotlight_entity_index,\
                         anglerfish_flash_counter,\
                         anglerfish_is_paused

.enum
ANGLERFISH_STATE_INIT
ANGLERFISH_STATE_MAIN
ANGLERFISH_STATE_DIE
.endenum

.endif
