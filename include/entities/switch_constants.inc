.ifndef SWITCH_CONSTANTS_INC
SWITCH_CONSTANTS_INC = 1

SWITCH_X_OFFSET = 0
SWITCH_Y_OFFSET = -16

SWITCH_WIDTH = $0f
SWITCH_HEIGHT = $1f

SWITCH_PARAMS = 4
switch_down_patch_index = entity_local0
switch_up_patch_index = entity_local1
switch_id = entity_local2
switch_pop_up_ids = entity_local3

switch_x_lo = entity_local4
switch_x_hi = entity_local5
switch_y_lo = entity_local6
switch_y_hi = entity_local7

.enum
SWITCH_STATE_INIT
SWITCH_STATE_WAIT_UNTIL_DEPRESSED
SWITCH_STATE_DEPRESS
SWITCH_STATE_POP_UP
SWITCH_STATE_IDLE
.endenum

.endif
