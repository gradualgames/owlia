.linecont +
.ifndef MONOLITH_INC
MONOLITH_INC = 1

.include "monolith_constants.inc"

MONOLITH_WIDTH = $0f
MONOLITH_HEIGHT = $0f

.define monolith_states \
  monolith_state_init, \
  monolith_state_fall_using_rows_init, \
  monolith_state_fall_draw_patch_second_row, \
  monolith_state_fall_draw_patch_first_row, \
  monolith_state_fall_draw_bg_patch_row, \
  monolith_state_fall_using_columns_init, \
  monolith_state_fall_draw_patch_left_column, \
  monolith_state_fall_draw_patch_right_column, \
  monolith_state_fall_using_columns_pause_one_frame, \
  monolith_state_idle

monolith_lo:
  .lobytes monolith_states

monolith_hi:
  .hibytes monolith_states

monolith_update:

  entity_state_switchboard monolith_lo, monolith_hi

monolith_state_init:

  lda #MONOLITH_WIDTH
  sta entity_width,x
  lda #MONOLITH_HEIGHT
  sta entity_height,x

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  sec
  lda entity_y_lo,x
  sbc #<16
  sta w1
  lda entity_y_hi,x
  sbc #>16
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  sec
  lda entity_y_lo,x
  sbc #<32
  sta w1
  lda entity_y_hi,x
  sbc #>32
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda #5
  sta monolith_state_counter,x

  lda monolith_state_after_init,x
  sta entity_state,x

  rts

monolith_state_fall_using_rows_init:

  dec monolith_state_counter,x
  bne :+

  lda #<(-16)
  sta monolith_patch_offset_y_lo,x
  lda #>(-16)
  sta monolith_patch_offset_y_hi,x

  lda #0
  sta monolith_patch_bg_row,x

  lda #MONOLITH_STATE_FALL_DRAW_PATCH_SECOND_ROW
  sta entity_state,x
:
  rts

monolith_state_fall_draw_patch_second_row:

  ;patch index
  lda monolith_foreground_patch_index,x
  sta b0

  ;patch row
  lda #1
  sta b1

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  clc
  lda entity_y_lo,x
  adc monolith_patch_offset_y_lo,x
  sta w1
  lda entity_y_hi,x
  adc monolith_patch_offset_y_hi,x
  sta w1+1

  jsr decode_nametable_patch_row

  lda #MONOLITH_STATE_FALL_DRAW_PATCH_FIRST_ROW
  sta entity_state,x

  rts

monolith_state_fall_draw_patch_first_row:

  ;patch index
  lda monolith_foreground_patch_index,x
  sta b0

  ;patch row
  lda #0
  sta b1

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  clc
  lda entity_y_lo,x
  adc monolith_patch_offset_y_lo,x
  sta w1
  lda entity_y_hi,x
  adc monolith_patch_offset_y_hi,x
  sta w1+1

  sec
  lda w1
  sbc #8
  sta w1
  lda w1+1
  sbc #0
  sta w1+1

  jsr decode_nametable_patch_row

  lda #MONOLITH_STATE_FALL_DRAW_BG_PATCH_ROW
  sta entity_state,x

  rts

monolith_state_fall_draw_bg_patch_row:

  ;patch index
  lda monolith_background_patch_index,x
  sta b0

  ;patch row
  lda monolith_patch_bg_row,x
  sta b1

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  clc
  lda entity_y_lo,x
  adc monolith_patch_offset_y_lo,x
  sta w1
  lda entity_y_hi,x
  adc monolith_patch_offset_y_hi,x
  sta w1+1

  sec
  lda w1
  sbc #16
  sta w1
  lda w1+1
  sbc #0
  sta w1+1

  jsr decode_nametable_patch_row

  clc
  lda monolith_patch_offset_y_lo,x
  adc #<8
  sta monolith_patch_offset_y_lo,x
  lda monolith_patch_offset_y_hi,x
  adc #>8
  sta monolith_patch_offset_y_hi,x

  inc monolith_patch_bg_row,x
  lda monolith_patch_bg_row,x
  cmp #4
  bne :+

  lda #MONOLITH_STATE_IDLE
  sta entity_state,x
  rts
:
  lda #MONOLITH_STATE_FALL_DRAW_PATCH_SECOND_ROW
  sta entity_state,x
  rts

monolith_state_fall_using_columns_init:

  dec monolith_state_counter,x
  bne :+

  lda #<(-32)
  sta monolith_patch_offset_y_lo,x
  lda #>(-32)
  sta monolith_patch_offset_y_hi,x

  lda #0
  sta monolith_patch_bg_row,x

  lda #MONOLITH_STATE_FALL_USING_COLUMNS_PAUSE_ONE_FRAME
  sta entity_state,x
:

  rts

monolith_state_fall_draw_patch_left_column:

  lda #0
  sta monolith_patch_offset_x_lo,x
  sta monolith_patch_offset_x_hi,x

  lda #0
  sta monolith_patch_column,x

  jsr monolith_draw_column

  lda #MONOLITH_STATE_FALL_DRAW_PATCH_RIGHT_COLUMN
  sta entity_state,x

  rts

monolith_state_fall_draw_patch_right_column:

  lda #<(8)
  sta monolith_patch_offset_x_lo,x
  lda #>(8)
  sta monolith_patch_offset_x_hi,x

  lda #1
  sta monolith_patch_column,x

  jsr monolith_draw_column

  clc
  lda monolith_patch_offset_y_lo,x
  adc #<(8)
  sta monolith_patch_offset_y_lo,x
  lda monolith_patch_offset_y_hi,x
  adc #>(8)
  sta monolith_patch_offset_y_hi,x

  inc monolith_patch_bg_row,x
  lda monolith_patch_bg_row,x
  cmp #4
  bne :+

  lda #MONOLITH_STATE_IDLE
  sta entity_state,x
  rts
:

  lda #MONOLITH_STATE_FALL_USING_COLUMNS_PAUSE_ONE_FRAME
  sta entity_state,x

  rts

monolith_state_fall_using_columns_pause_one_frame:

  lda #MONOLITH_STATE_FALL_DRAW_PATCH_LEFT_COLUMN
  sta entity_state,x

  rts

monolith_state_idle:

  rts

.proc monolith_draw_column

  ;patch index
  lda monolith_background_patch_index,x
  sta b0

  ;patch column
  lda monolith_patch_column,x
  sta b1

  ;height of the column to decode
  lda #4
  sta b2

  clc
  lda entity_x_lo,x
  adc monolith_patch_offset_x_lo,x
  sta w0
  lda entity_x_hi,x
  adc monolith_patch_offset_x_hi,x
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<(-32)
  sta w1
  lda entity_y_hi,x
  adc #>(-32)
  sta w1+1

  jsr decode_nametable_patch_column

  ;patch index
  lda monolith_foreground_patch_index,x
  sta b0

  ;patch column
  lda monolith_patch_column,x
  sta b1

  ;height of the column to decode
  lda monolith_patch_bg_row,x
  cmp #3
  beq :+
  lda #3
  jmp :++
: lda #2
:
  sta b2

  clc
  lda entity_x_lo,x
  adc monolith_patch_offset_x_lo,x
  sta w0
  lda entity_x_hi,x
  adc monolith_patch_offset_x_hi,x
  sta w0+1

  clc
  lda entity_y_lo,x
  adc monolith_patch_offset_y_lo,x
  sta w1
  lda entity_y_hi,x
  adc monolith_patch_offset_y_hi,x
  sta w1+1

  clc
  lda w1
  adc #8
  sta w1
  lda w1+1
  adc #0
  sta w1+1

  jsr decode_nametable_patch_column

  rts

.endproc

.endif
