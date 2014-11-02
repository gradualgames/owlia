.linecont +
.ifndef ANGLERFISH_INC
ANGLERFISH_INC = 1

.include "anglerfish_constants.inc"

ANGLERFISH_WIDTH = $0f
ANGLERFISH_HEIGHT = $0f

ANGLERFISH_SPEED = 150

ANGLERFISH_ATTACKED_LENGTH = 120

anglerfish_turn_direction:
anglerfish_turnright_direction:
  .byte ANGLERFISH_DIRECTION_DOWN
  .byte ANGLERFISH_DIRECTION_UP
  .byte ANGLERFISH_DIRECTION_LEFT
  .byte ANGLERFISH_DIRECTION_RIGHT

anglerfish_turnleft_direction:
  .byte ANGLERFISH_DIRECTION_UP
  .byte ANGLERFISH_DIRECTION_DOWN
  .byte ANGLERFISH_DIRECTION_RIGHT
  .byte ANGLERFISH_DIRECTION_LEFT

anglerfish_turnopposite_direction:
  .byte ANGLERFISH_DIRECTION_LEFT
  .byte ANGLERFISH_DIRECTION_RIGHT
  .byte ANGLERFISH_DIRECTION_UP
  .byte ANGLERFISH_DIRECTION_DOWN

.define anglerfish_animation_addresses \
  anglerfish_side, \
  anglerfish_side, \
  anglerfish_down, \
  anglerfish_up

anglerfish_animation_addresses_lo:
  .lobytes anglerfish_animation_addresses

anglerfish_animation_addresses_hi:
  .hibytes anglerfish_animation_addresses

anglerfish_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000
  .byte %00000000, %01000000, %00000000, %00000000

.define anglerfish_direction_speed_x ANGLERFISH_SPEED, -ANGLERFISH_SPEED, 0, 0

anglerfish_direction_speed_x_lo:
  .lobytes anglerfish_direction_speed_x

anglerfish_direction_speed_x_hi:
  .hibytes anglerfish_direction_speed_x

.define anglerfish_direction_speed_y 0, 0, ANGLERFISH_SPEED, -ANGLERFISH_SPEED

anglerfish_direction_speed_y_lo:
  .lobytes anglerfish_direction_speed_y

anglerfish_direction_speed_y_hi:
  .hibytes anglerfish_direction_speed_y

.define spotlight_offset_direction_x 30, -20, 4, 3

spotlight_offset_direction_x_lo:
  .lobytes spotlight_offset_direction_x

spotlight_offset_direction_x_hi:
  .hibytes spotlight_offset_direction_x

.define spotlight_offset_direction_y 20, 20, 35, -15

spotlight_offset_direction_y_lo:
  .lobytes spotlight_offset_direction_y

spotlight_offset_direction_y_hi:
  .hibytes spotlight_offset_direction_y

.define anglerfish_states \
  anglerfish_state_init, \
  anglerfish_state_main, \
  anglerfish_state_die

anglerfish_lo:
  .lobytes anglerfish_states

anglerfish_hi:
  .hibytes anglerfish_states

anglerfish_update:

  entity_state_switchboard anglerfish_lo, anglerfish_hi

anglerfish_state_init:

  lda #ANGLERFISH_WIDTH
  sta entity_width,x
  lda #ANGLERFISH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_anglerfish
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #$00
  sta anglerfish_x_fine,x
  sta anglerfish_y_fine,x

  lda anglerfish_turn_length,x
  sta anglerfish_turn_counter,x

  lda #0
  sta anglerfish_flash_counter,x

  clc
  lda entity_x_lo,x
  adc anglerfish_initial_offset_x,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x

  clc
  lda entity_y_lo,x
  adc anglerfish_initial_offset_y,x
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x

  jsr anglerfish_get_animation_params

  jsr entity_set_drawable

  jsr entity_reset_animation

  ;spawn a spotlight entity
  lda #entity_index_spotlight
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  ;store index of spotlight entity index so we can keep it in front of the
  ;anglerfish
  lda spawned_entity
  sta anglerfish_spotlight_entity_index,x
  tay

  ;get initial entity flags (for flickering the spotlight) from anglerfish.
  ;this enables us to have spotlights in front of anglerfish that are horizontally
  ;across from one another and go over the 8 sprite wide limit. Plus, it looks
  ;neat to flicker the spotlight (looks transparent).
  lda entity_flags,y
  ora anglerfish_spotlight_on,x
  sta entity_flags,y

  jsr anglerfish_calculate_spotlight_position

  jsr anglerfish_add_shadow_spot

  lda #ANGLERFISH_STATE_MAIN
  sta entity_state,x

  rts

anglerfish_state_main:

  jsr anglerfish_advance_attacked_state

  lda entity_action_rect1_action
  cmp #ACTION_ATTACK
  bne action_rect1_not_deadly

  jsr entity_test_entity_action_rect1
  bne action_rect1_not_deadly

  jsr anglerfish_attacked

action_rect1_not_deadly:

  lda entity_action_rect2_action
  cmp #ACTION_ATTACK
  bne action_rect2_not_deadly

  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  jsr anglerfish_attacked

  far_call #FAMILIAR_BANK, familiar_hit_enemy

action_rect2_not_deadly:

  lda anglerfish_flash_counter,x
  bne do_not_move_anglerfish

  jsr anglerfish_move

do_not_move_anglerfish:

  jsr anglerfish_calculate_spotlight_position

  jsr anglerfish_add_shadow_spot

  jsr anglerfish_get_animation_params

  jsr entity_update_animation

  rts

anglerfish_state_die:

  lda #entity_index_explosion
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  ldy anglerfish_spotlight_entity_index,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y

  rts

.proc anglerfish_get_animation_params

  clc
  ldy anglerfish_direction,x
  lda anglerfish_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda anglerfish_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda entity_sprite_flags,x
  and #%10111111
  ora anglerfish_sprite_flags_direction,y
  sta entity_sprite_flags,x

  rts

.endproc

.proc anglerfish_move

  dec anglerfish_turn_counter,x
  bne do_not_turn_anglerfish

  clc
  lda anglerfish_direction,x
  adc anglerfish_turn_mode,x
  tay
  lda anglerfish_turn_direction,y
  sta anglerfish_direction,x

  lda anglerfish_turn_length,x
  sta anglerfish_turn_counter,x

do_not_turn_anglerfish:

  ldy anglerfish_direction,x
  .scope
  lda anglerfish_direction_speed_x_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda anglerfish_x_fine,x
  adc anglerfish_direction_speed_x_lo,y
  sta anglerfish_x_fine,x
  lda entity_x_lo,x
  adc anglerfish_direction_speed_x_hi,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x
  jmp done
sign_extend_negative:
  clc
  lda anglerfish_x_fine,x
  adc anglerfish_direction_speed_x_lo,y
  sta anglerfish_x_fine,x
  lda entity_x_lo,x
  adc anglerfish_direction_speed_x_hi,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$ff
  sta entity_x_hi,x
done:
  .endscope

  .scope
  lda anglerfish_direction_speed_y_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda anglerfish_y_fine,x
  adc anglerfish_direction_speed_y_lo,y
  sta anglerfish_y_fine,x
  lda entity_y_lo,x
  adc anglerfish_direction_speed_y_hi,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x
  jmp done
sign_extend_negative:
  clc
  lda anglerfish_y_fine,x
  adc anglerfish_direction_speed_y_lo,y
  sta anglerfish_y_fine,x
  lda entity_y_lo,x
  adc anglerfish_direction_speed_y_hi,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$ff
  sta entity_y_hi,x
done:
  .endscope

  rts

.endproc

.proc anglerfish_attacked

  lda anglerfish_flash_counter,x
  bne attacked_state_machine_already_running

  ;play a sound
  lda #<sfx_hit
  sta sound_param_word_0
  lda #>sfx_hit
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  lda #ANGLERFISH_ATTACKED_LENGTH
  sta anglerfish_flash_counter,x

attacked_state_machine_already_running:

  rts

.endproc

.proc anglerfish_advance_attacked_state

  lda anglerfish_flash_counter,x
  beq attacked_state_machine_not_running

  dec anglerfish_flash_counter,x

  lda anglerfish_flash_counter,x
  and #%00000011
  sta b0

  lda entity_sprite_flags,x
  and #%11111100
  ora b0
  sta entity_sprite_flags,x

attacked_state_machine_not_running:

  rts

.endproc

.proc anglerfish_add_shadow_spot

  clc
  lda entity_x_lo,x
  adc #$08
  sta w0
  lda entity_x_hi,x
  adc #$00
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #$18
  sta w1
  lda entity_y_hi,x
  adc #$00
  sta w1+1

  jsr sprite_add_shadow_spot

  rts

.endproc

.proc anglerfish_calculate_spotlight_position

  ldy anglerfish_direction,x
  .scope
  spotlight_x = w0
  spotlight_y = w1

  clc
  lda entity_x_lo,x
  adc spotlight_offset_direction_x_lo,y
  sta spotlight_x
  lda entity_x_hi,x
  adc spotlight_offset_direction_x_hi,y
  sta spotlight_x+1

  clc
  lda entity_y_lo,x
  adc spotlight_offset_direction_y_lo,y
  sta spotlight_y
  lda entity_y_hi,x
  adc spotlight_offset_direction_y_hi,y
  sta spotlight_y+1

  ldy anglerfish_spotlight_entity_index,x
  lda spotlight_x
  sta entity_x_lo,y
  lda spotlight_x+1
  sta entity_x_hi,y

  lda spotlight_y
  sta entity_y_lo,y
  lda spotlight_y+1
  sta entity_y_hi,y
  .endscope

  rts

.endproc

.endif
