.linecont +
.ifndef MONOLITH_INC
MONOLITH_INC = 1

.include "monolith_constants.inc"

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

  .scope
  lda monolith_flags,x
  and #MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE
  beq not_up

  jsr monolith_make_impassable

not_up:
  .endscope

  lda monolith_flags,x
  ora #MONOLITH_FLAGS_EXIT_ENABLED_SET
  sta monolith_flags,x

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

  lda monolith_flags,x
  and #MONOLITH_TYPE_ISOLATE
  cmp #MONOLITH_TYPE_UNLOCKED
  bne monolith_not_unlocked
  lda monolith_flags,x
  and #MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE
  beq monolith_not_up
  jsr monolith_fall_if_touching_hero
monolith_not_up:
monolith_not_unlocked:

  ;test this monolith's exit if it is enabled
  lda monolith_flags,x
  and #MONOLITH_FLAGS_EXIT_ENABLED_TEST
  beq monolith_exit_disabled
  jsr monolith_test_exit
monolith_exit_disabled:

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

  jsr monolith_draw_background_patch_column

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

  jsr monolith_draw_background_patch_column

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

.proc monolith_draw_background_patch_column

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

.define monolith_exits \
  monolith_test_east_exit, \
  monolith_test_west_exit, \
  monolith_test_south_exit, \
  monolith_test_north_exit

monolith_exits_lo:
  .lobytes monolith_exits

monolith_exits_hi:
  .hibytes monolith_exits

.define monolith_touch_rect_offsets_x \
  -16, \
  0, \
  -8, \
  -8

monolith_touch_rect_offset_x_lo:
  .lobytes monolith_touch_rect_offsets_x

monolith_touch_rect_offset_x_hi:
  .hibytes monolith_touch_rect_offsets_x

.define monolith_touch_rect_offsets_y \
  -24, \
  -24, \
  -64, \
  0

monolith_touch_rect_offset_y_lo:
  .lobytes monolith_touch_rect_offsets_y

monolith_touch_rect_offset_y_hi:
  .hibytes monolith_touch_rect_offsets_y

monolith_touch_rect_width:
  .byte 32, 32, 32, 32

monolith_touch_rect_height:
  .byte 48, 48, 32, 32

.proc monolith_fall_if_touching_hero

  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  ldy monolith_direction,x
  clc
  lda entity_x_lo,x
  adc monolith_touch_rect_offset_x_lo,y
  sta w2
  lda entity_x_hi,x
  adc monolith_touch_rect_offset_x_hi,y
  sta w2+1
  clc
  lda entity_y_lo,x
  adc monolith_touch_rect_offset_y_lo,y
  sta w3
  lda entity_y_hi,x
  adc monolith_touch_rect_offset_y_hi,y
  sta w3+1
  lda monolith_touch_rect_width,y
  sta b2
  lda monolith_touch_rect_height,y
  sta b3

  ;transfer hero rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda hero_x
  sta w4
  lda hero_x+1
  sta w4+1
  lda hero_y
  sta w5
  lda hero_y+1
  sta w5+1
  lda hero_width
  sta b4
  lda hero_height
  sta b5

  jsr geotests_rect_inside_rect_size
  bne not_touching_hero
  lda hero_direction
  cmp monolith_direction,x
  bne do_not_activate_monolith
  ;at this point, we know that the hero is trying to activate the monolith
  lda #MONOLITH_STATE_FALL_USING_COLUMNS_INIT
  sta entity_state,x

  lda monolith_flags,x
  and #MONOLITH_FLAGS_DOWN_CLEAR
  sta monolith_flags,x

do_not_activate_monolith:
not_touching_hero:

  rts

.endproc

.proc monolith_test_exit

  ;transfer hero rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda hero_x
  sta w4
  lda hero_x+1
  sta w4+1
  lda hero_y
  sta w5
  lda hero_y+1
  sta w5+1
  lda hero_width
  sta b4
  lda hero_height
  sta b5

  ;now jump to the correct exit handler to load the north, south, east, or west
  ;screen edge rect and perform the test. the call will return with the zero flag
  ;set if the test succeeds.
  ldy monolith_direction,x
  lda monolith_exits_lo,y
  sta w0
  lda monolith_exits_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  jsr geotests_rect_in_rect_size
  bne not_exiting

  ;tell the play state to go to destination location
  lda monolith_goto_location_action,x
  sta state_control_params+play_state_control::action
  lda monolith_location_index,x
  sta state_control_params+play_state_control::param
  ;also tell the play state what direction this monolith's exit is in
  lda monolith_direction,x
  sta state_control_params+play_state_control::param+1

not_exiting:

  rts

indirect_jsr_w0:
  jmp (w0)

.endproc

.proc monolith_test_north_exit

  ;transfer north screen edge rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda camera_x
  sta w2
  lda camera_x+1
  sta w2+1
  lda camera_y
  sta w3
  lda camera_y+1
  sta w3+1
  lda #255
  sta b2
  lda #1
  sta b3

  rts

.endproc

.proc monolith_test_south_exit

  ;transfer north screen edge rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda camera_x
  sta w2
  lda camera_x+1
  sta w2+1
  clc
  lda camera_y
  adc #224
  sta w3
  lda camera_y+1
  adc #0
  sta w3+1
  lda #255
  sta b2
  lda #1
  sta b3

  rts

.endproc

.proc monolith_test_west_exit

  ;transfer west screen edge rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda camera_x
  sta w2
  lda camera_x+1
  sta w2+1
  lda camera_y
  sta w3
  lda camera_y+1
  sta w3+1
  lda #1
  sta b2
  lda #239
  sta b3

  rts

.endproc

.proc monolith_test_east_exit

  ;transfer east screen edge rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  clc
  lda camera_x
  adc #255
  sta w2
  lda camera_x+1
  adc #0
  sta w2+1
  lda camera_y
  sta w3
  lda camera_y+1
  sta w3+1
  lda #1
  sta b2
  lda #239
  sta b3

  rts

.endproc

.endif
