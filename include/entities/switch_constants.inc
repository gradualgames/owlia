.linecont +
.ifndef SWITCH_CONSTANTS_INC
SWITCH_CONSTANTS_INC = 1

SWITCH_X_OFFSET = 0
SWITCH_Y_OFFSET = -16

SWITCH_WIDTH = $0f
SWITCH_HEIGHT = $1f

SWITCH_PARAMS = 4

define_entity_properties switch_down_patch_index,\
                         switch_up_patch_index,\
                         switch_id,\
                         switch_pop_up_ids,\
                         \
                         switch_x_lo,\
                         switch_x_hi,\
                         switch_y_lo,\
                         switch_y_hi

.enum
SWITCH_STATE_INIT
SWITCH_STATE_WAIT_UNTIL_DEPRESSED
SWITCH_STATE_DEPRESS
SWITCH_STATE_POP_UP
SWITCH_STATE_IDLE
.endenum

.endif
