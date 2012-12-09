.ifndef TEXTBOX_INC
TEXTBOX_INC = 1

.global draw_textbox
.global erase_textbox
.global draw_textbox_top_row
.global draw_textbox_middle_row
.global draw_textbox_bottom_row

;offsets of tiles in the textbox chr graphics
;these are to be added to textbox_and_font_chr_offset
;to get correct tile numbers when drawing the textbox.
TOP_LEFT_TILE_OFFSET     = 0
TOP_RIGHT_TILE_OFFSET    = 1
LEFT_TILE_OFFSET         = 2
RIGHT_TILE_OFFSET        = 3
MIDDLE_TILE_OFFSET       = 4
BOTTOM_LEFT_TILE_OFFSET  = 5
BOTTOM_RIGHT_TILE_OFFSET = 6
TOP_TILE_OFFSET          = 7
BOTTOM_TILE_OFFSET       = 8

.endif
