.ifndef BOMBABLE_WALL_CONSTANTS_INC
BOMBABLE_WALL_CONSTANTS_INC = 1

BOMBABLE_WALL_WIDTH = $0f
BOMBABLE_WALL_HEIGHT = $0f

BOMBABLE_WALL_PATCH_OFFSET_X = -16
BOMBABLE_WALL_INITIAL_PATCH_OFFSET_Y = 24
BOMBABLE_WALL_INITIAL_PATCH_ROW = 11

BOMBABLE_WALL_FALL_DELAY = 10

.enum
BOMBABLE_WALL_STATE_INIT
BOMBABLE_WALL_STATE_WAIT_TIL_BOMBED
BOMBABLE_WALL_STATE_FALL
BOMBABLE_WALL_STATE_TEST_EXIT
.endenum

BOMBABLE_WALL_PARAMS = 4

bombable_wall_patch_index = entity_local0
bombable_wall_corridor_attribute = entity_local1
bombable_wall_goto_location_action = entity_local2
bombable_wall_location_index = entity_local3

bombable_wall_patch_offset_y_lo = entity_local4
bombable_wall_patch_offset_y_hi = entity_local5
bombable_wall_patch_row = entity_local6
bombable_wall_frame_counter = entity_local7

.endif
