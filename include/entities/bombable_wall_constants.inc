.ifndef BOMBABLE_WALL_CONSTANTS_INC
BOMBABLE_WALL_CONSTANTS_INC = 1

BOMBABLE_WALL_WIDTH = $0f
BOMBABLE_WALL_HEIGHT = $0f

BOMBABLE_WALL_PATCH_OFFSET_X = -16
BOMBABLE_WALL_INITIAL_PATCH_OFFSET_Y = 24
BOMBABLE_WALL_INITIAL_PATCH_ROW = 13

.enum
BOMBABLE_WALL_STATE_INIT
BOMBABLE_WALL_STATE_MAIN
.endenum

BOMBABLE_WALL_PARAMS = 1

bombable_wall_corridor_attribute = entity_local0

bombable_wall_patch_offset_y_lo = entity_local1
bombable_wall_patch_offset_y_hi = entity_local2
bombable_wall_patch_row = entity_local3

.endif
