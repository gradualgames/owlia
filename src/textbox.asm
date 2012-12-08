.include "textbox.inc"
.include "ram.inc"
.include "zp.inc"
.include "map.inc"
.include "ppu.inc"

.segment "CODE"

;draws the whole textbox by using the helper routines
;draw_textbox_top_row, draw_textbox_middle_row, and
;draw_textbox_bottom_row. It calculates offsets from
;camera_x and camera_y to determine where to draw each
;row. It uses the map module to first decode the tiles
;as they are already at the chosen location, and then
;the helper routines shovel actual textbox graphics into
;the row buffer for upload. This routine is responsible
;for waiting and setting the vblank data ready variable
;to get the resulting textbox graphics onto the screen.
.proc draw_textbox

  wait_vblank_data_ready

  ;set up coordinates and draw top row
  clc
  lda camera_x
  adc #0
  sta w0
  lda camera_x+1
  adc #0
  sta w0+1

  clc
  lda camera_y
  adc #(16*10)
  sta w1
  lda camera_y+1
  adc #0
  sta w1+1
  jsr draw_textbox_top_row
  lda #1
  sta row_ready

  set_vblank_data_ready

  ;draw all middle rows, incrementing y coordinate (w1)
  ldx #6
next_middle_row:
  wait_vblank_data_ready

  clc
  lda w1
  adc #$08
  sta w1
  lda w1+1
  adc #$00
  sta w1+1

  ;save x, the map routines are destructive of most cpu state
  txa
  pha
  jsr draw_textbox_middle_row
  ;restore x
  pla
  tax
  lda #1
  sta row_ready

  set_vblank_data_ready

  dex
  bne next_middle_row

  ;draw bottom row, incrementing y coordinate once (w1)
  wait_vblank_data_ready

  clc
  lda w1
  adc #$08
  sta w1
  lda w1+1
  adc #$00
  sta w1+1
  jsr draw_textbox_bottom_row
  lda #1
  sta row_ready

  set_vblank_data_ready

  rts

.endproc


;draws top row of textbox to the nametable_row_buffer by
;first decoding the map at X = w0 and Y = w1 and then
;overwriting the contents with graphics from the textbox
;(top left tile followed by top tiles followed by top right
;tile)
;the width of this textbox is hardcoded here in code, but
;the location of this row is determined by w0 and w1
.proc draw_textbox_top_row

  jsr map_decode_row

  ldx #0
  ;draw top left corner
  clc
  lda textbox_and_font_chr_offset
  adc #TOP_LEFT_TILE_OFFSET
  sta nametable_row_buffer,x

  ;draw top tile
  ldx #1
  clc
  lda textbox_and_font_chr_offset
  adc #TOP_TILE_OFFSET
draw_next_top_tile:
  sta nametable_row_buffer,x
  inx
  cpx #31
  bne draw_next_top_tile

  ;draw top right corner
  clc
  lda textbox_and_font_chr_offset
  adc #TOP_RIGHT_TILE_OFFSET
  sta nametable_row_buffer,x

  rts

.endproc

;draws middle row of textbox to the nametable_row_buffer by
;decoding the map at X = w0 and Y = w1 and then overwriting
;the contents with graphics from the textbox (left tile followed
;by middle tile followed by right tile)
;the width of this textbox is hardcoded here in code, but
;the location of this row is determined by w0 and w1
.proc draw_textbox_middle_row

  jsr map_decode_row

  ldx #0
  ;draw left side
  clc
  lda textbox_and_font_chr_offset
  adc #LEFT_TILE_OFFSET
  sta nametable_row_buffer,x

  ;draw middle tile
  ldx #1
  clc
  lda textbox_and_font_chr_offset
  adc #MIDDLE_TILE_OFFSET
draw_next_top_tile:
  sta nametable_row_buffer,x
  inx
  cpx #31
  bne draw_next_top_tile

  ;draw right side
  clc
  lda textbox_and_font_chr_offset
  adc #RIGHT_TILE_OFFSET
  sta nametable_row_buffer,x

  rts

.endproc

;draws bottom row of textbox to the nametable_row_buffer by
;decoding the map at X = w0 and Y = w1 and then overwriting
;the contents with graphics from the textbox (bottom left tile
;followed by bottom tiles followed by bottom right tile)
;the width of this textbox is hardcoded here in code, but
;the location of this row is determined by w0 and w1
.proc draw_textbox_bottom_row

  jsr map_decode_row

  ldx #0
  ;draw bottom left tile
  clc
  lda textbox_and_font_chr_offset
  adc #BOTTOM_LEFT_TILE_OFFSET
  sta nametable_row_buffer,x

  ;draw bottom tile
  ldx #1
  clc
  lda textbox_and_font_chr_offset
  adc #BOTTOM_TILE_OFFSET
draw_next_top_tile:
  sta nametable_row_buffer,x
  inx
  cpx #31
  bne draw_next_top_tile

  ;draw bottom right tile
  clc
  lda textbox_and_font_chr_offset
  adc #BOTTOM_RIGHT_TILE_OFFSET
  sta nametable_row_buffer,x

  rts

.endproc
