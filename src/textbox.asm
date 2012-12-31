.include "textbox.inc"
.include "ram.inc"
.include "zp.inc"
.include "map.inc"
.include "areas.inc"
.include "ppu.inc"
.include "mapper.inc"
.include "sprite.inc"
.include "controller.inc"
.include "soundengine.inc"
.include "sfx_data.inc"

.segment "CODE"

;This routine takes an address of a conversation script as a
;parameter in w0 and then reads the script to display text on
;the text box and animate it at a reasonable speed, as well
;as wait for the player to hit the A button when the script
;says to. The script contains control characters for end of line,
;end of page, end of conversation and wait for A button. end of
;line characters (EL) must ALWAYS be followed by a row number.
.proc run_conversation
conversation_address = w0
row_y_offset = b0

  ;make sure any previous ppu uploads are complete before proceeding
  wait_vblank_data_ready

  switch_bank_ldy conversations_bank

  ;Read row number. Reset row index
  ldy #0
read_next_row:
  lda (conversation_address),y
  ;Use row number to determine parameters to the draw_textbox_middle_row
  ;routine.
  ;multiply row number by 8
  asl
  asl
  asl
  ;add on Y coordinate of top of textbox
  clc
  adc #(16*10)
  ;store the offset
  sta row_y_offset

  ;save local state---map decoding is very destructive
  lda w0
  pha
  lda w0+1
  pha
  lda b0
  pha
  txa
  pha
  tya
  pha

  ;compute coordinates for row
  clc
  lda camera_x
  adc #0
  sta w0
  lda camera_x+1
  adc #0
  sta w0+1

  clc
  lda camera_y
  adc row_y_offset
  sta w1
  lda camera_y+1
  adc #0
  sta w1+1
  ;Decode map at this row.
  ;Call draw_textbox_middle_row at this row.
  switch_bank_ldy map_bank
  jsr draw_textbox_middle_row
  switch_bank_ldy conversations_bank

  ;restore local state
  pla
  tay
  pla
  tax
  pla
  sta b0
  pla
  sta w0+1
  pla
  sta w0

  lda #1
  sta row_ready
  ldx #2
  ;Read a character.
read_next_character:
  clc
  lda conversation_address
  adc #$01
  sta conversation_address
  lda conversation_address+1
  adc #$00
  sta conversation_address+1
  lda (conversation_address),y
  bmi interpret_control_character
  ;If positive (it is just an offset into the font)
interpret_font_character:
  ;Draw the character to the nametable row buffer (see sub routine)
  clc
  adc textbox_and_font_chr_offset
  sta nametable_row_buffer,x
  inx

  ;play a sound
  txa
  pha

  lda #<sfx_text
  sta sound_param_word_0
  lda #>sfx_text
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  ;Sync with vblank so the animation is reasonable.
  wait_vblank_data_ready
  set_vblank_data_ready
  wait_vblank_data_ready
  set_vblank_data_ready
  wait_vblank_data_ready
  lda #1
  sta row_ready
  set_vblank_data_ready
  jmp read_next_character
  ;If negative (it is a control character)
interpret_control_character:
  cmp #WT
  beq wait
  cmp #EL
  beq advance_to_next_row
  cmp #EP
  beq clear_textbox
  cmp #EC
  beq end_conversation
wait:
  ;If it is WT, just wait til user hits A button.
  wait_vblank_data_ready

  jsr controller_read

  set_vblank_data_ready

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne wait

  ;read next character
  jmp read_next_character
advance_to_next_row:
  ;If it is EL, advance the conversation read address and read next character
  ;as a row number.
  clc
  lda conversation_address
  adc #$01
  sta conversation_address
  lda conversation_address+1
  adc #$00
  sta conversation_address+1
  ;interpret next character as a row number and start a new line
  jmp read_next_row
clear_textbox:
  ;If it is EP, redraw the textbox blank (see sub routine)
  ;save local state---map decoding is very destructive
  lda w0
  pha
  lda w0+1
  pha
  lda b0
  pha
  txa
  pha
  tya
  pha

  switch_bank_ldy map_bank
  jsr draw_textbox
  switch_bank_ldy conversations_bank

  ;restore local state
  pla
  tay
  pla
  tax
  pla
  sta b0
  pla
  sta w0+1
  pla
  sta w0

  ;read next character
  jmp read_next_character

end_conversation:
  ;If it is EC, exit the whole algorithm
  rts

.endproc

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

  lda #160
  sta b0
  jsr sprite_hide_all_below

  switch_bank_ldy map_bank

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

;erases the textbox area by decoding the map across the same
;rows that the texbox occupied. Draw bottom up to make it
;look cool.
.proc erase_textbox

  wait_vblank_data_ready

  switch_bank_ldy map_bank

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
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
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
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
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
  jsr map_decode_row
  jsr map_process_intermediate_attribute_row_buffer
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

  ;fill the intermediate attribute row buffer with correct value
  ldy #area::textbox_attribute
  lda (area_address),y
  ldx #16
next_intermediate_attribute:
  sta intermediate_attribute_row_buffer,x
  dex
  bpl next_intermediate_attribute
  jsr map_process_intermediate_attribute_row_buffer

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

  ;fill the intermediate attribute row buffer with correct value
  ldy #area::textbox_attribute
  lda (area_address),y
  ldx #16
next_intermediate_attribute:
  sta intermediate_attribute_row_buffer,x
  dex
  bpl next_intermediate_attribute

  jsr map_process_intermediate_attribute_row_buffer

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

  ;fill the intermediate attribute row buffer with correct value
  ldy #area::textbox_attribute
  lda (area_address),y
  ldx #16
next_intermediate_attribute:
  sta intermediate_attribute_row_buffer,x
  dex
  bpl next_intermediate_attribute
  jsr map_process_intermediate_attribute_row_buffer

  rts

.endproc
