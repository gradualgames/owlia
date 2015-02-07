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

anglerfish_turn_mode = entity_local0
anglerfish_pause_mode = entity_local1
anglerfish_turn_length = entity_local2
anglerfish_direction = entity_local3
anglerfish_spotlight_on = entity_local4
anglerfish_initial_offset_x = entity_local5
anglerfish_initial_offset_y = entity_local6

anglerfish_x_fine = entity_local7
anglerfish_y_fine = entity_local8
anglerfish_turn_counter = entity_local9
anglerfish_spotlight_entity_index = entity_local10
anglerfish_flash_counter = entity_local11
anglerfish_is_paused = entity_local12

.enum
ANGLERFISH_STATE_INIT
ANGLERFISH_STATE_MAIN
ANGLERFISH_STATE_DIE
.endenum

.endif
