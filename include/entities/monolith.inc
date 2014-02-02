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
  monolith_state_rise_using_rows_init, \
  monolith_state_rise_draw_patch_first_row, \
  monolith_state_rise_draw_patch_second_row, \
  monolith_state_rise_draw_patch_third_row, \
  monolith_state_rise_using_columns_init, \
  monolith_state_rise_draw_patch_left_column, \
  monolith_state_rise_draw_patch_right_column, \
  monolith_state_rise_using_columns_pause_one_frame, \
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

  lda #0
  sta monolith_state_counter,x

  lda #MONOLITH_STATE_IDLE
  sta entity_state,x

  rts

monolith_state_fall_using_rows_init:

  jsr monolith_play_slam_sound

  lda #<(-16)
  sta monolith_patch_offset_y_lo,x
  lda #>(-16)
  sta monolith_patch_offset_y_hi,x

  lda #0
  sta monolith_patch_step,x

  lda #MONOLITH_STATE_FALL_DRAW_PATCH_SECOND_ROW
  sta entity_state,x

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
  lda monolith_patch_step,x
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

  inc monolith_patch_step,x
  lda monolith_patch_step,x
  cmp #4
  bne :+

  jsr monolith_make_passable

  lda #MONOLITH_SHAKE_SCREEN_COUNTER
  sta monolith_state_counter,x

  lda #MONOLITH_STATE_IDLE
  sta entity_state,x
  rts
:
  lda #MONOLITH_STATE_FALL_DRAW_PATCH_SECOND_ROW
  sta entity_state,x
  rts

monolith_state_fall_using_columns_init:

  jsr monolith_play_slam_sound

  lda #<(-32)
  sta monolith_patch_offset_y_lo,x
  lda #>(-32)
  sta monolith_patch_offset_y_hi,x

  lda #0
  sta monolith_patch_step,x

  lda #MONOLITH_STATE_FALL_USING_COLUMNS_PAUSE_ONE_FRAME
  sta entity_state,x

  rts

monolith_state_fall_draw_patch_left_column:

  lda #0
  sta monolith_patch_offset_x_lo,x
  sta monolith_patch_offset_x_hi,x

  lda #0
  sta monolith_patch_column,x

  jsr monolith_draw_falling_column

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

  jsr monolith_draw_falling_column

  clc
  lda monolith_patch_offset_y_lo,x
  adc #<(8)
  sta monolith_patch_offset_y_lo,x
  lda monolith_patch_offset_y_hi,x
  adc #>(8)
  sta monolith_patch_offset_y_hi,x

  inc monolith_patch_step,x
  lda monolith_patch_step,x
  cmp #4
  bne :+

  jsr monolith_make_passable

  lda #MONOLITH_SHAKE_SCREEN_COUNTER
  sta monolith_state_counter,x

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

monolith_state_rise_using_rows_init:

  jsr monolith_play_slam_sound

  jsr monolith_make_impassable

  lda #<(8)
  sta monolith_patch_offset_y_lo,x
  lda #>(8)
  sta monolith_patch_offset_y_hi,x

  lda #0
  sta monolith_patch_step,x

  lda #MONOLITH_STATE_RISE_DRAW_PATCH_THIRD_ROW
  sta entity_state,x

  rts

monolith_state_rise_draw_patch_first_row:

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

  clc
  lda w1
  adc #<(-16)
  sta w1
  lda w1+1
  adc #>(-16)
  sta w1+1

  jsr decode_nametable_patch_row

  sec
  lda monolith_patch_offset_y_lo,x
  sbc #8
  sta monolith_patch_offset_y_lo,x
  lda monolith_patch_offset_y_hi,x
  sbc #0
  sta monolith_patch_offset_y_hi,x

  inc monolith_patch_step,x
  lda monolith_patch_step,x
  cmp #4
  bne :+

  lda #MONOLITH_SHAKE_SCREEN_COUNTER
  sta monolith_state_counter,x

  lda #MONOLITH_STATE_IDLE
  sta entity_state,x
  rts
:

  lda #MONOLITH_STATE_RISE_DRAW_PATCH_THIRD_ROW
  sta entity_state,x

  rts

monolith_state_rise_draw_patch_second_row:

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

  clc
  lda w1
  adc #<(-8)
  sta w1
  lda w1+1
  adc #>(-8)
  sta w1+1

  jsr decode_nametable_patch_row

  lda #MONOLITH_STATE_RISE_DRAW_PATCH_FIRST_ROW
  sta entity_state,x

  rts

monolith_state_rise_draw_patch_third_row:

  ;patch index
  lda monolith_foreground_patch_index,x
  sta b0

  ;patch row
  sec
  lda #5
  sbc monolith_patch_step,x
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

  lda #MONOLITH_STATE_RISE_DRAW_PATCH_SECOND_ROW
  sta entity_state,x

  rts

monolith_state_rise_using_columns_init:

  jsr monolith_play_slam_sound

  jsr monolith_make_impassable

  lda #<(-16)
  sta monolith_patch_offset_y_lo,x
  lda #>(-16)
  sta monolith_patch_offset_y_hi,x

  lda #0
  sta monolith_patch_step,x

  lda #MONOLITH_STATE_RISE_USING_COLUMNS_PAUSE_ONE_FRAME
  sta entity_state,x

  rts

monolith_state_rise_draw_patch_left_column:

  lda #0
  sta monolith_patch_offset_x_lo,x
  sta monolith_patch_offset_x_hi,x

  lda #0
  sta monolith_patch_column,x

  jsr monolith_draw_rising_column

  lda #MONOLITH_STATE_RISE_DRAW_PATCH_RIGHT_COLUMN
  sta entity_state,x

  rts

monolith_state_rise_draw_patch_right_column:

  lda #8
  sta monolith_patch_offset_x_lo,x
  lda #0
  sta monolith_patch_offset_x_hi,x

  lda #1
  sta monolith_patch_column,x

  jsr monolith_draw_rising_column

  sec
  lda monolith_patch_offset_y_lo,x
  sbc #<8
  sta monolith_patch_offset_y_lo,x
  lda monolith_patch_offset_y_hi,x
  sbc #>8
  sta monolith_patch_offset_y_hi,x

  inc monolith_patch_step,x
  lda monolith_patch_step,x
  cmp #4
  bne :+

  lda #MONOLITH_SHAKE_SCREEN_COUNTER
  sta monolith_state_counter,x

  lda #MONOLITH_STATE_IDLE
  sta entity_state,x
  rts
:
  lda #MONOLITH_STATE_RISE_USING_COLUMNS_PAUSE_ONE_FRAME
  sta entity_state,x

  rts

monolith_state_rise_using_columns_pause_one_frame:

  lda #MONOLITH_STATE_RISE_DRAW_PATCH_LEFT_COLUMN
  sta entity_state,x

  rts

monolith_state_idle:

  ;if the shake screen flag is set, shake the screen as long as the state counter is not zero
  .scope
  lda monolith_flags,x
  and #MONOLITH_FLAGS_SHAKE_SCREEN_TEST
  beq do_not_shake_screen

  lda monolith_state_counter,x
  beq do_not_shake_screen

  dec monolith_state_counter,x

  lda camera_y
  eor #$04
  sta camera_y
  lda camera_scroll_y
  eor #$04
  sta camera_scroll_y

do_not_shake_screen:
  .endscope

  rts

.proc monolith_draw_falling_column

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
  lda monolith_patch_step,x
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

.proc monolith_draw_rising_column

  ;patch index
  lda monolith_foreground_patch_index,x
  sta b0

  ;patch column
  lda monolith_patch_column,x
  sta b1

  ;height of the column to decode
  lda monolith_patch_step,x
  sta b2
  inc b2
  inc b2
  inc b2

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

.proc monolith_make_passable

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr clear_dynamic_single_screen_collision_field_bit

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

  jsr clear_dynamic_single_screen_collision_field_bit

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

  jsr clear_dynamic_single_screen_collision_field_bit

  rts

.endproc

.proc monolith_make_impassable

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

  rts

.endproc

.proc monolith_play_slam_sound

  ;play a sound
  txa
  pha

  lda #<sfx_monolith_slam
  sta sound_param_word_0
  lda #>sfx_monolith_slam
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  rts

.endproc

.endif
