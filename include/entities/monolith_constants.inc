.ifndef MONOLITH_CONSTANTS_INC
MONOLITH_CONSTANTS_INC = 1

.enum
MONOLITH_STATE_INIT
MONOLITH_STATE_FALL_USING_ROWS_INIT
MONOLITH_STATE_FALL_DRAW_PATCH_SECOND_ROW
MONOLITH_STATE_FALL_DRAW_PATCH_FIRST_ROW
MONOLITH_STATE_FALL_DRAW_BG_PATCH_ROW
MONOLITH_STATE_FALL_USING_COLUMNS_INIT
MONOLITH_STATE_FALL_DRAW_PATCH_LEFT_COLUMN
MONOLITH_STATE_FALL_DRAW_PATCH_RIGHT_COLUMN
MONOLITH_STATE_IDLE
.endenum

MONOLITH_PARAMS = 3

monolith_foreground_patch_index = entity_local0
monolith_background_patch_index = entity_local1
monolith_state_after_init = entity_local2
monolith_state_counter = entity_local3
monolith_patch_offset_x_lo = entity_local4
monolith_patch_offset_x_hi = entity_local5
monolith_patch_offset_y_lo = entity_local6
monolith_patch_offset_y_hi = entity_local7
monolith_patch_bg_row = entity_local8
monolith_patch_column = entity_local9

.endif
