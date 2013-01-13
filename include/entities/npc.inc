.linecont +
.ifndef NPC_INC
NPC_INC = 1

.enum
NPC_STATE_INIT
NPC_STATE_MAIN
.endenum

.enum
NPC_DIRECTION_RIGHT
NPC_DIRECTION_LEFT
NPC_DIRECTION_DOWN
NPC_DIRECTION_UP
.endenum

NPC_SPEED = 1

npc_conversation = entity_local0
npc_graphics_set = entity_local1
npc_walk_rect_width = entity_local2
npc_walk_rect_height = entity_local3
npc_direction = entity_local4
npc_pseudo_random_number = entity_local5
npc_frame_counter = entity_local6
npc_pseudo_random_number_sample = entity_local7
npc_hero_still_in_rect = entity_local8

.define npc_states \
  npc_state_init, \
  npc_state_main

npc_lo:
  .lobytes npc_states

npc_hi:
  .hibytes npc_states

npc_update:

  entity_state_switchboard npc_lo, npc_hi

npc_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #NPC_DIRECTION_DOWN
  sta npc_direction,x

  lda #0
  sta npc_hero_still_in_rect,x

  clc
  lda npc_direction,x
  adc npc_graphics_set,x
  tay
  lda npc_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npc_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda npc_sprite_flags_direction,y
  sta entity_sprite_flags,x

  lda #16
  sta entity_width,x
  lda #32
  sta entity_height,x

  jsr entity_reset_animation

  ;seed the random number
  lda stream_read_address_lo
  eor hero_x
  sta npc_pseudo_random_number,x

  lda #NPC_STATE_MAIN
  sta entity_state,x

  rts

npc_state_main:

  ;permute the pseudo random number
: lda npc_pseudo_random_number,x
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor #$1d
noEor:
  sta npc_pseudo_random_number,x
  dey
  bne :-

  sta npc_pseudo_random_number,x

  ;decrement the frame counter
  dec npc_frame_counter,x
  bne npc_frame_counter_not_zero

  ;sample lowest 6 bits of pseudo random number and use it as new frame counter
  and #%00111111
  sta npc_frame_counter,x

  ;sample lowest 3 bits of pseudo random number
  and #%00000111
  sta npc_pseudo_random_number_sample,x
  and #%00000100
  bne do_not_use_as_direction

  ;lowest 3 bits was between 0 and 3, use it as the new direction for the npc
  lda npc_pseudo_random_number_sample,x
  sta npc_direction,x

  ;face in that direction
  clc
  adc npc_graphics_set,x
  tay
  lda npc_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npc_animation_addresses_hi,y
  sta entity_animation_address_hi,x
  lda npc_sprite_flags_direction,y
  sta entity_sprite_flags,x
do_not_use_as_direction:

  ;seed the random number
  lda stream_read_address_lo
  eor hero_x
  sta npc_pseudo_random_number,x

npc_frame_counter_not_zero:

  ;move the npc man in the direction he is facing if the random number sample is between 0 and 3
  ;anything else is interpreted as a "pause."
  lda npc_pseudo_random_number_sample,x
  and #%00000100
  bne do_not_move

  ;use direction as index into increment luts
  ldy npc_direction,x

  clc
  lda entity_x_lo,x
  adc npc_direction_speed_x_lo,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc npc_direction_speed_x_hi,y
  sta entity_x_hi,x

  clc
  lda entity_y_lo,x
  adc npc_direction_speed_y_lo,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc npc_direction_speed_y_hi,y
  sta entity_y_hi,x

  jsr keep_within_walk_rectangle

  jsr entity_update_animation

do_not_move:

  ;test whether hero intersects npc's rect and rotate the result
  ;into npcman_hero_still_in_rect. This makes it easy to detect
  ;a transition into the npc's rect and a transition out.
  .scope
  jsr entity_test_hero_rect
  bne not_in_hero_rect
in_hero_rect:
  lda #$01
  jmp done
not_in_hero_rect:
  lda #$00
done:
  ror
  rol npc_hero_still_in_rect,x
  .endscope

  lda npc_hero_still_in_rect,x
  and #%00000011
  cmp #%00000010
  bne do_not_reset_drawable_flags

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda hero_flags
  ora #HERO_FLAGS_DRAWABLE_SET
  sta hero_flags

do_not_reset_drawable_flags:

  lda npc_hero_still_in_rect,x
  and #%00000001
  beq do_not_start_conversation

  lda entity_flags,x
  eor #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda entity_flags,x
  and #ENTITY_FLAGS_DRAWABLE_TEST
  eor #ENTITY_FLAGS_DRAWABLE_SET
  sta b0

  lda hero_flags
  and #HERO_FLAGS_DRAWABLE_CLEAR
  ora b0
  sta hero_flags

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne do_not_start_conversation

  ;make sure both the npc and the hero are drawable
  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda hero_flags
  ora #HERO_FLAGS_DRAWABLE_SET
  sta hero_flags

  ;cancel the hero's attack, overriding the default a button behavior.
  jsr hero_cancel_attack

  ;face the hero
  ldy hero_direction
  lda npc_opposite_direction,y
  sta npc_direction,x
  clc
  adc npc_graphics_set,x
  tay
  lda npc_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npc_animation_addresses_hi,y
  sta entity_animation_address_hi,x
  lda npc_sprite_flags_direction,y
  sta entity_sprite_flags,x

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda npc_conversation,x
  sta state_control_params+play_state_control::param

do_not_start_conversation:

  rts

keep_within_walk_rectangle:

  ;make sure NPC does not stray outside of rectangle relative to spawn position

  ;subtract spawn x from current x
  sec
  lda entity_x_lo,x
  sbc entity_spawn_x_lo,x
  sta w0
  lda entity_x_hi,x
  sbc entity_spawn_x_hi,x
  sta w0+1
  bpl not_left_of_rect

  lda entity_spawn_x_lo,x
  sta entity_x_lo,x
  lda entity_spawn_x_hi,x
  sta entity_x_hi,x

  ;stop npc from walking
  lda #4
  sta npc_pseudo_random_number_sample,x

not_left_of_rect:

  sec
  lda w0
  sbc npc_walk_rect_width,x
  lda w0+1
  sbc #0
  bmi not_right_of_rect

  clc
  lda entity_spawn_x_lo,x
  adc npc_walk_rect_width,x
  sta entity_x_lo,x
  lda entity_spawn_x_hi,x
  adc #0
  sta entity_x_hi,x

  ;stop npc from walking
  lda #4
  sta npc_pseudo_random_number_sample,x

not_right_of_rect:

  ;subtract spawn y from current y
  sec
  lda entity_y_lo,x
  sbc entity_spawn_y_lo,x
  sta w1
  lda entity_y_hi,x
  sbc entity_spawn_y_hi,x
  sta w1+1
  bpl not_above_rect

  lda entity_spawn_y_lo,x
  sta entity_y_lo,x
  lda entity_spawn_y_hi,x
  sta entity_y_hi,x

  ;stop npc from walking
  lda #4
  sta npc_pseudo_random_number_sample,x

not_above_rect:

  sec
  lda w1
  sbc npc_walk_rect_height,x
  lda w1+1
  sbc #0
  bmi not_below_rect

  clc
  lda entity_spawn_y_lo,x
  adc npc_walk_rect_height,x
  sta entity_y_lo,x
  lda entity_spawn_y_hi,x
  adc #0
  sta entity_y_hi,x

  ;stop npc from walking
  lda #4
  sta npc_pseudo_random_number_sample,x

not_below_rect:

  rts

.endif
