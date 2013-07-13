.linecont +
.ifndef INNKEEP_INC
INNKEEP_INC = 1

INNKEEP_WIDTH = $0f
INNKEEP_HEIGHT = $0f

innkeep_conversation  = entity_local0
innkeep_destination_x_lo = entity_local1
innkeep_destination_x_hi = entity_local2
innkeep_destination_y_lo = entity_local3
innkeep_destination_y_hi = entity_local4
innkeep_width = entity_local5
innkeep_height = entity_local6
innkeep_offset_x = entity_local7
innkeep_offset_y = entity_local8
innkeep_price = entity_local9
innkeep_brightness_counter = entity_local10
innkeep_wait_counter = entity_local11

.enum
INNKEEP_STATE_INIT
INNKEEP_STATE_PROMPT_FOR_STAY
INNKEEP_STATE_STAY_OR_NOT
INNKEEP_STATE_ALIGN_HERO_WITH_DESTINATION_X
INNKEEP_STATE_ALIGN_HERO_WITH_DESTINATION_Y
INNKEEP_STATE_FADE_OUT_PALETTE
INNKEEP_STATE_SLEEP
INNKEEP_STATE_FADE_IN_PALETTE
.endenum

.define innkeep_states \
  innkeep_state_init, \
  innkeep_state_prompt_for_stay, \
  innkeep_state_stay_or_not, \
  innkeep_state_align_hero_with_destination_x, \
  innkeep_state_align_hero_with_destination_y, \
  innkeep_state_fade_out_palette, \
  innkeep_state_sleep, \
  innkeep_state_fade_in_palette

innkeep_lo:
  .lobytes innkeep_states

innkeep_hi:
  .hibytes innkeep_states

innkeep_update:

  entity_state_switchboard innkeep_lo, innkeep_hi

innkeep_state_init:

  ;the innkeep is just a rect, it is never drawn
  jsr entity_clear_drawable

  ;initialize width and height
  lda innkeep_width,x
  sta entity_width,x
  lda innkeep_height,x
  sta entity_height,x

  ;initialize offset
  .scope
  lda innkeep_offset_x,x
  bmi sign_extend_negative
sign_extend_positive:

  clc
  lda entity_x_lo,x
  adc innkeep_offset_x,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x

  jmp done
sign_extend_negative:

  clc
  lda entity_x_lo,x
  adc innkeep_offset_x,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$ff
  sta entity_x_hi,x

done:
  .endscope

  .scope
  lda innkeep_offset_y,x
  bmi sign_extend_negative
sign_extend_positive:

  clc
  lda entity_y_lo,x
  adc innkeep_offset_y,x
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x

  jmp done
sign_extend_negative:

  clc
  lda entity_y_lo,x
  adc innkeep_offset_y,x
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$ff
  sta entity_y_hi,x

done:
  .endscope

  lda #INNKEEP_STATE_PROMPT_FOR_STAY
  sta entity_state,x

  rts

innkeep_state_prompt_for_stay:

  .scope
  jsr entity_test_hero_rect
  bne not_touching_hero

  jsr hero_is_attacking
  bne hero_not_attacking

  ;initialize brightness counter for when the innkeep entity
  ;transitions into the fade out palette state.
  lda #MAX_BRIGHTNESS_LEVEL
  asl
  asl
  asl
  sta innkeep_brightness_counter,x

  ;initialize wait counter for sleep state
  lda #50
  sta innkeep_wait_counter,x

  ;cancel attack this frame because hero pressed a against a
  ;purchasable item!
  jsr hero_cancel_attack

  ;put hero into a passive state so she cannot
  ;get input from the controller between now and when the not-enough-gp
  ;box has been cleared.
  lda #10
  sta b0
  jsr hero_wait_frames

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda innkeep_conversation,x
  sta state_control_params+play_state_control::param

  ;on next frame, transition to add-item-or-not state to respond to
  ;textbox result
  lda #INNKEEP_STATE_STAY_OR_NOT
  sta entity_state,x

not_touching_hero:
hero_not_attacking:
  .endscope

  rts

innkeep_state_stay_or_not:

  lda textbox_result
  cmp #TEXTBOX_CONFIRM
  beq stay
do_not_stay:

  ;restore control to player
  lda #<controller_read
  sta controller_routine
  lda #>controller_read
  sta controller_routine+1

  ;transition back to prompt state
  lda #INNKEEP_STATE_PROMPT_FOR_STAY
  sta entity_state,x

  rts

stay:

  .scope
  ;check to see if hero has enough gp
  sec
  lda inventory_gp
  sbc innkeep_price,x
  lda inventory_gp+1
  sbc #$00
  bmi not_enough_gp

  ;decrement price from gp
  sec
  lda inventory_gp
  sbc innkeep_price,x
  sta inventory_gp
  lda inventory_gp+1
  sbc #$00
  sta inventory_gp+1

  ;take over the controller, the innkeep entity will move the hero to the
  ;bed using the passed in parameters for how far to move
  jsr controller_clear
  lda #<controller_nop
  sta controller_routine
  lda #>controller_nop
  sta controller_routine+1

  ;transition to state which moves hero to bed
  lda #INNKEEP_STATE_ALIGN_HERO_WITH_DESTINATION_X
  sta entity_state,x

  rts

not_enough_gp:

  ;restore control to player
  lda #<controller_read
  sta controller_routine
  lda #>controller_read
  sta controller_routine+1

  ;transition back to prompt state
  lda #INNKEEP_STATE_PROMPT_FOR_STAY
  sta entity_state,x

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_not_enough_gp
  sta state_control_params+play_state_control::param

  rts
  .endscope

innkeep_state_align_hero_with_destination_x:

  .scope
  sec
  lda hero_x
  sbc innkeep_destination_x_lo,x
  sta w0
  lda hero_x+1
  sbc innkeep_destination_x_hi,x
  sta w0+1
  bpl move_left
  beq done
move_right:

  lda #1
  sta buffer_controller+buttons::_right

  jmp done
move_left:

  lda #1
  sta buffer_controller+buttons::_left

done:
  .endscope

  .scope
  lda w0+1
  bpl do_not_negate_difference

  clc
  lda w0
  eor #$ff
  adc #$01
  sta w0
  lda w0+1
  eor #$ff
  adc #$00
  sta w0+1

do_not_negate_difference:

  sec
  lda w0
  sbc #2
  bpl not_close_enough

  jsr controller_clear

  lda #INNKEEP_STATE_ALIGN_HERO_WITH_DESTINATION_Y
  sta entity_state,x
not_close_enough:
  .endscope

  rts

innkeep_state_align_hero_with_destination_y:

  .scope
  sec
  lda hero_y
  sbc innkeep_destination_y_lo,x
  sta w0
  lda hero_y+1
  sbc innkeep_destination_y_hi,x
  sta w0+1
  bpl move_up
  beq done
move_down:

  lda #1
  sta buffer_controller+buttons::_down

  jmp done
move_up:

  lda #1
  sta buffer_controller+buttons::_up

done:
  .endscope

  .scope
  lda w0+1
  bpl do_not_negate_difference

  clc
  lda w0
  eor #$ff
  adc #$01
  sta w0
  lda w0+1
  eor #$ff
  adc #$00
  sta w0+1

do_not_negate_difference:

  sec
  lda w0
  sbc #2
  bpl not_close_enough

  jsr controller_clear

  lda #INNKEEP_STATE_FADE_OUT_PALETTE
  sta entity_state,x

not_close_enough:
  .endscope

  rts

innkeep_state_fade_out_palette:

  lda innkeep_brightness_counter,x
  beq faded_out
  lsr
  lsr
  lsr
  sta b3
  jsr entity_change_palette_brightness_bg_trampoline
  jsr entity_change_palette_brightness_spr_trampoline

  dec innkeep_brightness_counter,x

  rts

faded_out:

  lda #INNKEEP_STATE_SLEEP
  sta entity_state,x

  rts

innkeep_state_sleep:

  lda innkeep_wait_counter,x
  bne wait_not_over

  lda #INNKEEP_STATE_FADE_IN_PALETTE
  sta entity_state,x

  rts

wait_not_over:

  dec innkeep_wait_counter,x

  rts

innkeep_state_fade_in_palette:

  lda innkeep_brightness_counter,x
  cmp #33
  beq faded_in
  lsr
  lsr
  lsr
  and #%00000111
  sta b3
  jsr entity_change_palette_brightness_bg_trampoline
  jsr entity_change_palette_brightness_spr_trampoline

  inc innkeep_brightness_counter,x

  rts

faded_in:

  ;restore player's health (the whole point of staying at this inn!!!)
  lda #3
  sta hero_health

  ;restore control to player forcing player to let go of buttons before
  ;further input will be detected (fill buffer with all pressed values)
  lda #$ff
  jsr controller_fill_buffer_with_accumulator
  lda #<controller_read
  sta controller_routine
  lda #>controller_read
  sta controller_routine+1

  ;transition back to prompt state
  lda #INNKEEP_STATE_PROMPT_FOR_STAY
  sta entity_state,x

  rts

.endif
