.linecont +
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

define_entity_properties bombable_wall_patch_index,\
                         bombable_wall_corridor_attribute,\
                         bombable_wall_goto_location_action,\
                         bombable_wall_location_index,\
                         \
                         bombable_wall_patch_offset_y_lo,\
                         bombable_wall_patch_offset_y_hi,\
                         bombable_wall_patch_row,\
                         bombable_wall_frame_counter

.endif
