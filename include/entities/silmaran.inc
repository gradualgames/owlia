.linecont +
.ifndef SILMARAN_INC
SILMARAN_INC = 1

.include "silmaran_constants.inc"

.define silmaran_states \
  silmaran_state_init, \
  silmaran_state_intro_wait, \
  silmaran_state_intro_align_camera_horiz, \
  silmaran_state_intro_align_camera_vert, \
  silmaran_state_intro_descend, \
  silmaran_state_intro_perch, \
  silmaran_state_intro_ascend, \
  silmaran_state_intro_summon_adlanniel

silmaran_lo:
  .lobytes silmaran_states

silmaran_hi:
  .hibytes silmaran_states

silmaran_update:

  entity_state_switchboard silmaran_lo, silmaran_hi

silmaran_state_init:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  lda #<silmaran_descend
  sta entity_animation_address_lo,x
  lda #>silmaran_descend
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SILMARAN_WIDTH
  sta entity_width,x
  lda #SILMARAN_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_silmaran
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda silmaran_initial_state,x
  sta entity_state,x

  rts

silmaran_state_intro_wait:

  ;make sure that Silmaran has only been encountered once
  lda inventory_earned_techs
  cmp #SILMARAN_EARNED_TECH
  bmi do_not_skip_silmaran

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
  rts

do_not_skip_silmaran:

  jsr check_summon_rect

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  ;take over the controller.
  jsr controller_clear
  set_controller_routine controller_nop

  lda #ENTITY_DIRECTION_UP
  sta hero_direction

  lda #<silmaran_theme
  sta song_address
  lda #>silmaran_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

  sec
  lda entity_x_lo,x
  sbc #<SILMARAN_OFFSCREEN_X_OFFSET
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>SILMARAN_OFFSCREEN_X_OFFSET
  sta entity_x_hi,x

  sec
  lda entity_y_lo,x
  sbc #<SILMARAN_OFFSCREEN_Y_OFFSET
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>SILMARAN_OFFSCREEN_Y_OFFSET
  sta entity_y_hi,x

  lda #SILMARAN_STATE_INTRO_ALIGN_CAMERA_HORIZ
  sta entity_state,x

entity_not_hitting_hero:

  rts

silmaran_state_intro_align_camera_horiz:

  .scope
  lda camera_x
  cmp #<SILMARAN_TOP_LEFT_SCREEN_X
  bne not_equal
  lda camera_x+1
  cmp #>SILMARAN_TOP_LEFT_SCREEN_X
  bne not_equal

  jmp done

not_equal:
  sec
  lda camera_x
  sbc #<SILMARAN_TOP_LEFT_SCREEN_X
  lda camera_x+1
  sbc #>SILMARAN_TOP_LEFT_SCREEN_X
  bmi scroll_right
  bpl scroll_left
scroll_right:

  jsr decode_column_right

  rts
scroll_left:

  jsr decode_column_left

  rts
done:

  lda #SILMARAN_STATE_INTRO_ALIGN_CAMERA_VERT
  sta entity_state,x

  .endscope

  rts

silmaran_state_intro_align_camera_vert:

  .scope
  lda camera_y
  cmp #<SILMARAN_TOP_LEFT_SCREEN_Y
  bne not_equal
  lda camera_y+1
  cmp #>SILMARAN_TOP_LEFT_SCREEN_Y
  bne not_equal

  jmp done

not_equal:
  sec
  lda camera_y
  sbc #<SILMARAN_TOP_LEFT_SCREEN_Y
  lda camera_y+1
  sbc #>SILMARAN_TOP_LEFT_SCREEN_Y
  bmi scroll_down
  bpl scroll_up
scroll_down:

  jsr decode_row_below

  rts
scroll_up:

  jsr decode_row_above

  rts
done:

  ;play a flapping sound
  lda #<sfx_flap
  sta sound_param_word_0
  lda #>sfx_flap
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  jsr entity_set_drawable

  lda #SILMARAN_STATE_INTRO_DESCEND
  sta entity_state,x

  .endscope

  rts

silmaran_state_intro_descend:

  clc
  lda entity_y_lo,x
  adc #1
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #0
  sta entity_y_hi,x

  .scope
  lda entity_y_lo,x
  cmp #<SILMARAN_PERCH_Y
  bne not_equal
  lda entity_y_hi,x
  cmp #>SILMARAN_PERCH_Y
  bne not_equal

  clc
  lda entity_x_lo,x
  adc #<SILMARAN_PERCH_X_OFFSET
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>SILMARAN_PERCH_X_OFFSET
  sta entity_x_hi,x

  lda #<silmaran_perch
  sta entity_animation_address_lo,x
  lda #>silmaran_perch
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_silmaran_encounter_scene
  sta state_control_params+play_state_control::param

  lda #SILMARAN_STATE_INTRO_PERCH
  sta entity_state,x

not_equal:
  .endscope

  jsr entity_update_animation

  rts

silmaran_state_intro_perch:

  lda #SILMARAN_STATE_INTRO_ASCEND_LENGTH
  sta silmaran_state_counter,x

  ;play a flapping sound
  lda #<sfx_flap
  sta sound_param_word_0
  lda #>sfx_flap
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  sec
  lda entity_x_lo,x
  sbc #<SILMARAN_PERCH_X_OFFSET
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>SILMARAN_PERCH_X_OFFSET
  sta entity_x_hi,x

  lda #<silmaran_descend
  sta entity_animation_address_lo,x
  lda #>silmaran_descend
  sta entity_animation_address_hi,x

  lda #SILMARAN_STATE_INTRO_ASCEND
  sta entity_state,x

  jsr entity_update_animation

  rts

silmaran_state_intro_ascend:

  .scope
  dec silmaran_state_counter,x
  bne not_gone_yet

  lda #<forest_theme
  sta song_address
  lda #>forest_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

  ;earn the unlock technique
  lda #SILMARAN_EARNED_TECH
  sta inventory_earned_techs

  ;restore control to the player
  lda #$ff
  jsr controller_fill_buffer_with_accumulator
  set_controller_routine controller_read

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

not_gone_yet:
  .endscope

  sec
  lda entity_y_lo,x
  sbc #1
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #0
  sta entity_y_hi,x

  jsr entity_update_animation

  rts

silmaran_state_intro_summon_adlanniel:

  lda #1
  sta buffer_controller+buttons::_right

  dec silmaran_state_counter,x
  bne do_not_switch_back_to_wait_state

  ;restore control to the player
  jsr controller_clear
  set_controller_routine controller_read

  lda #SILMARAN_STATE_INTRO_WAIT
  sta entity_state,x

do_not_switch_back_to_wait_state:

  rts

.proc check_summon_rect

  ;transfer hero rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda hero_x
  sta w2
  lda hero_x+1
  sta w2+1
  lda hero_y
  sta w3
  lda hero_y+1
  sta w3+1
  lda hero_width
  sta b2
  lda hero_height
  sta b3

  ;transfer summon rect to w4 = left and w5 = top and b4 = width and b5 = height
  lda #<SILMARAN_SUMMON_RECT_X
  sta w4
  lda #>SILMARAN_SUMMON_RECT_X
  sta w4+1
  lda #<SILMARAN_SUMMON_RECT_Y
  sta w5
  lda #>SILMARAN_SUMMON_RECT_Y
  sta w5+1
  lda #SILMARAN_SUMMON_RECT_WIDTH
  sta b4
  lda #SILMARAN_SUMMON_RECT_HEIGHT
  sta b5

  jsr geotests_rect_in_rect_size

  bne do_not_summon_adlanniel

  ;take over the controller.
  jsr controller_clear
  set_controller_routine controller_nop

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_silmaran_call_adlanniel
  sta state_control_params+play_state_control::param

  lda #SILMARAN_STATE_INTRO_SUMMON_ADLANNIEL_LENGTH
  sta silmaran_state_counter,x

  lda #SILMARAN_STATE_INTRO_SUMMON_ADLANNIEL
  sta entity_state,x

do_not_summon_adlanniel:

  rts

.endproc

.proc decode_row_above

  txa
  pha

  lda #1
  sta b0
  jsr decrement_camera_y

  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  far_call map_bank, map_decode_row
  far_call map_bank, map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  pla
  tax

  rts

.endproc

.proc decode_row_below

  txa
  pha

  lda #1
  sta b0
  jsr increment_camera_y

  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  clc
  lda camera_y
  adc #224
  sta w1
  lda camera_y+1
  adc #$00
  sta w1+1
  far_call map_bank, map_decode_row
  far_call map_bank, map_process_intermediate_attribute_row_buffer
  lda #1
  sta row_ready

  pla
  tax

  rts

.endproc

.proc decode_column_left

  txa
  pha

  lda #1
  sta b0
  jsr decrement_camera_x

  clc
  lda camera_x
  sta w0
  lda camera_x+1
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  far_call map_bank, map_decode_column
  far_call map_bank,  map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  pla
  tax

  rts

.endproc

.proc decode_column_right

  txa
  pha

  lda #1
  sta b0
  jsr increment_camera_x

  clc
  lda camera_x
  adc #$00
  sta w0
  lda camera_x+1
  adc #$01
  sta w0+1

  lda camera_y
  sta w1
  lda camera_y+1
  sta w1+1
  far_call map_bank, map_decode_column
  far_call map_bank,  map_process_intermediate_attribute_column_buffer
  lda #1
  sta column_ready

  pla
  tax

  rts

.endproc

.endif
