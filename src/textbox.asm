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

power_table_lo:
  .byte <10000, <1000, <100, <10, <1

power_table_hi:
  .byte >10000, >1000, >100, >10, >1

;This routine creates a decimal string from a 16 bit input number.
;w0 is expected to be the address of the input number to translate into a decimal string.
;w1 is expected to be the address of the output string buffer in RAM.
;b0 is used to count how many times each power fit into the input number
;b1 is used to count remaining digits
.proc create_decimal_string
input_number = w0
output_buffer = w1
digit_counter = b0
remaining_digits = b1

  ;start at highest power (first time inx is executed, we will be at index 0)
  ldx #$ff

  ;start at highest possible remaining digits + 1
  lda #6
  sta remaining_digits

  ;start at first digit of output string
  ldy #0

  ;check to see if input number is already zero, this is a special case. Just output 0
  ;and an end of string character in this case.
  lda input_number
  ora input_number+1
  beq already_zero

  ;search for the first power in the power table that is less than or equal to the input number
next_power:
  dec remaining_digits
  inx
  sec
  lda input_number
  sbc power_table_lo,x
  lda input_number+1
  sbc power_table_hi,x
  ;if the negative flag is set here, then the power is greater than the input number, so move on
  ;to next power
  bmi next_power

  ;at this point, x now points to the first power thant is less than or equal to the input number

next_digit:
  ;reset the digit counter
  lda #0
  sta digit_counter

  ;subtract the current power from the input number until we go negative. Increment the digit
  ;counter.
keep_counting:
  inc digit_counter
  sec
  lda input_number
  sbc power_table_lo,x
  sta input_number
  lda input_number+1
  sbc power_table_hi,x
  sta input_number+1
  bpl keep_counting

  ;when we get here, we've counted the current digit plus 1 (when we went negative). Add the power
  ;back and decrement the digit count to get the correct count.
  clc
  lda input_number
  adc power_table_lo,x
  sta input_number
  lda input_number+1
  adc power_table_hi,x
  sta input_number+1

  dec digit_counter

  ;at this point we know the current number has had the current power all the way removed. Store the
  ;digit counter in the output string.
  lda digit_counter
  sta (output_buffer),y

  ;move on to the next power, and the next digit
  inx
  iny

  dec remaining_digits
  bne next_digit

  ;now output an end of string character
  lda #ES
  sta (output_buffer),y

  rts

already_zero:

  lda #0
  sta (output_buffer),y
  iny
  lda #ES
  sta (output_buffer),y

  rts

.endproc

;This routine simply prints a string directly to the nametable.
;w0 is expected to be the address of the string to print.
;b0 is expected to be the hi byte of the nametable to which to draw the string.
;b1 is expected to be the row at which to print the string.
;b2 is expected to be the column at which to print the string.
;assumes that graphics are off or is being called from vblank.
.proc print_string_impl
string_address = w0

  set_ppu_2006_abs b0, b1, b2
  upload_ppu_2006

  ldy #0
: lda (string_address),y
  cmp #ES
  beq end_of_string
  clc
  adc chr_group_offset
  sta $2007
  iny
  jmp :-

end_of_string:
  rts

.endproc

.segment "ROM10"

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
  wait_vblank_flag

  lda #TEXTBOX_NO_RESULT
  sta textbox_result

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
  adc textbox_row
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
  jsr draw_textbox_middle_row

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

  ;Read controller here in inner loop. This allows us to
  ;exit the conversation when the start button is pressed
  ;during a cut scene. During normal play, the start button
  ;will be ignored because we will install a special controller
  ;routine for that purpose.
  jsr controller_indirect

  ;exit conversation if start button is pressed
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  bne :+
  lda #TEXTBOX_EXIT
  sta textbox_result
  jmp end_conversation
:

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
  wait_vblank_flag
  set_vblank_flag
  wait_vblank_flag
  set_vblank_flag
  wait_vblank_flag
  lda #1
  sta row_ready
  set_vblank_flag
  jmp read_next_character
  ;If negative (it is a control character)
interpret_control_character:
  cmp #WT
  beq wait
  cmp #CC
  beq confirm_cancel
  cmp #EL
  beq advance_to_next_row
  cmp #EP
  beq clear_textbox
  cmp #EC
  beq end_conversation
  cmp #TM
  beq time
confirm_cancel:
  ;If it is CC, wait til user hits A or B button,
  ;then store TEXTBOX_CONFIRM or TEXTBOX_CANCEL in textbox_result
  wait_vblank_flag

  jsr controller_indirect

  set_vblank_flag

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  beq store_result_confirm
  lda buffer_controller+buttons::_b
  and #%00000011
  cmp #%00000001
  beq store_result_cancel
  ;if we reach here, neither A nor B was pressed, keep waiting
  jmp confirm_cancel
store_result_confirm:
  lda #TEXTBOX_CONFIRM
  sta textbox_result
  jmp read_next_character
store_result_cancel:
  lda #TEXTBOX_CANCEL
  sta textbox_result
  jmp read_next_character

end_conversation:
  ;If it is EC, exit the whole algorithm
  rts

wait:
  ;If it is WT, just wait til user hits A button.
  wait_vblank_flag

  jsr controller_indirect

  set_vblank_flag

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

  jsr draw_textbox

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

time:

  .scope
  ;advance the conversation read address, then
  ;read the next byte and wait that number of frames
  clc
  lda conversation_address
  adc #$01
  sta conversation_address
  lda conversation_address+1
  adc #$00
  sta conversation_address+1

  ldy #0
  lda (conversation_address),y
  tax

time_wait_loop:
  wait_vblank_flag

  jsr controller_indirect

  ;exit conversation if start button is pressed
  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  bne :+
  lda #TEXTBOX_EXIT
  sta textbox_result
  jmp end_conversation
:

  dex
  beq exit_wait_loop

  set_vblank_flag

  jmp time_wait_loop
exit_wait_loop:
  .endscope

  ;read next character
  jmp read_next_character

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

  wait_vblank_flag

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
  adc textbox_row
  sta w1
  lda camera_y+1
  adc #0
  sta w1+1
  jsr draw_textbox_top_row
  lda #1
  sta row_ready

  set_vblank_flag

  ;draw all middle rows, incrementing y coordinate (w1)
  ldx #5
next_middle_row:
  wait_vblank_flag

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

  set_vblank_flag

  dex
  bne next_middle_row

  ;draw bottom row, incrementing y coordinate once (w1)
  wait_vblank_flag

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

  set_vblank_flag

  rts

.endproc

;erases the textbox area by decoding the map across the same
;rows that the texbox occupied. Draw bottom up to make it
;look cool.
.proc erase_textbox

  wait_vblank_flag

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
  adc textbox_row
  sta w1
  lda camera_y+1
  adc #0
  sta w1+1
  far_call map_bank, map_decode_row
  far_call map_bank, map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  set_vblank_flag

  ;draw all middle rows, incrementing y coordinate (w1)
  ldx #6
next_middle_row:
  wait_vblank_flag

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
  far_call map_bank, map_decode_row
  far_call map_bank, map_process_intermediate_attribute_row_buffer
  ;restore x
  pla
  tax
  lda #1
  sta row_ready

  set_vblank_flag

  dex
  bne next_middle_row

  ;draw bottom row, incrementing y coordinate once (w1)
  wait_vblank_flag

  clc
  lda w1
  adc #$08
  sta w1
  lda w1+1
  adc #$00
  sta w1+1
  far_call map_bank, map_decode_row
  far_call map_bank, map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  set_vblank_flag

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

  far_call map_bank, map_decode_row

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
  lda textbox_attribute
  ldx #16
next_intermediate_attribute:
  sta intermediate_attribute_row_buffer,x
  dex
  bpl next_intermediate_attribute
  far_call map_bank, map_process_intermediate_attribute_row_buffer

  rts

.endproc

;draws middle row of textbox to the nametable_row_buffer by
;decoding the map at X = w0 and Y = w1 and then overwriting
;the contents with graphics from the textbox (left tile followed
;by middle tile followed by right tile)
;the width of this textbox is hardcoded here in code, but
;the location of this row is determined by w0 and w1
.proc draw_textbox_middle_row

  far_call map_bank, map_decode_row

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
  lda textbox_attribute
  ldx #16
next_intermediate_attribute:
  sta intermediate_attribute_row_buffer,x
  dex
  bpl next_intermediate_attribute

  far_call map_bank, map_process_intermediate_attribute_row_buffer

  rts

.endproc

;draws bottom row of textbox to the nametable_row_buffer by
;decoding the map at X = w0 and Y = w1 and then overwriting
;the contents with graphics from the textbox (bottom left tile
;followed by bottom tiles followed by bottom right tile)
;the width of this textbox is hardcoded here in code, but
;the location of this row is determined by w0 and w1
.proc draw_textbox_bottom_row

  far_call map_bank, map_decode_row

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
  lda textbox_attribute
  ldx #16
next_intermediate_attribute:
  sta intermediate_attribute_row_buffer,x
  dex
  bpl next_intermediate_attribute
  far_call map_bank, map_process_intermediate_attribute_row_buffer

  rts

.endproc
