.linecont +
.ifndef NPCMAN_INC
NPCMAN_INC = 1

.enum
NPCMAN_STATE_INIT
NPCMAN_STATE_MAIN
.endenum

.enum
NPCMAN_DIRECTION_RIGHT
NPCMAN_DIRECTION_LEFT
NPCMAN_DIRECTION_DOWN
NPCMAN_DIRECTION_UP
.endenum

NPCMAN_SPEED = 1

NPCMAN_WALK_RECT_WIDTH  = 16 * 6
NPCMAN_WALK_RECT_HEIGHT = 16 * 6

npcman_direction = entity_local0
npcman_pseudo_random_number = entity_local1
npcman_frame_counter = entity_local2
npcman_pseudo_random_number_sample = entity_local3

npcman_direction_speed_x_lo:
  .byte NPCMAN_SPEED, -NPCMAN_SPEED, 0, 0

npcman_direction_speed_x_hi:
  .byte 0, $ff, 0, 0

npcman_direction_speed_y_lo:
  .byte 0, 0, NPCMAN_SPEED, -NPCMAN_SPEED

npcman_direction_speed_y_hi:
  .byte 0, 0, 0, $ff

npcman_opposite_direction:
  .byte NPCMAN_DIRECTION_LEFT
  .byte NPCMAN_DIRECTION_RIGHT
  .byte NPCMAN_DIRECTION_UP
  .byte NPCMAN_DIRECTION_DOWN

.define npcman_animation_addresses\
  NpcManWalkSide,\
  NpcManWalkSide,\
  NpcManWalkDown,\
  NpcManWalkUp

npcman_animation_addresses_lo:
  .lobytes npcman_animation_addresses

npcman_animation_addresses_hi:
  .hibytes npcman_animation_addresses

npcman_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000

.define npcman_states \
  npcman_state_init, \
  npcman_state_main

npcman_lo:
  .lobytes npcman_states

npcman_hi:
  .hibytes npcman_states

npcman_update:

  entity_state_switchboard npcman_lo, npcman_hi

npcman_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #NPCMAN_DIRECTION_DOWN
  sta npcman_direction,x

  ldy npcman_direction,x
  lda npcman_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npcman_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda npcman_sprite_flags_direction,y
  sta entity_sprite_flags,x

  lda #16
  sta entity_width,x
  lda #32
  sta entity_height,x

  jsr entity_reset_animation

  lda entity_type,x
  tay
  lda entity_type_chr_offsets,y
  sta entity_sprite_group_offset,x

  ;seed the random number
  lda stream_read_address_lo
  eor hero_x
  sta npcman_pseudo_random_number,x

  lda #NPCMAN_STATE_MAIN
  sta entity_state,x

  rts

npcman_state_main:

  ;permute the pseudo random number
: lda npcman_pseudo_random_number,x
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor #$1d
noEor:
  sta npcman_pseudo_random_number,x
  dey
  bne :-

  sta npcman_pseudo_random_number,x

  ;decrement the frame counter
  dec npcman_frame_counter,x
  bne npcman_frame_counter_not_zero

  ;sample lowest 6 bits of pseudo random number and use it as new frame counter
  and #%00111111
  sta npcman_frame_counter,x

  ;sample lowest 3 bits of pseudo random number
  and #%00000111
  sta npcman_pseudo_random_number_sample,x
  and #%00000100
  bne do_not_use_as_direction

  ;lowest 3 bits was between 0 and 3, use it as the new direction for the npc
  lda npcman_pseudo_random_number_sample,x
  sta npcman_direction,x

  ;face in that direction
  tay
  lda npcman_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npcman_animation_addresses_hi,y
  sta entity_animation_address_hi,x
  lda npcman_sprite_flags_direction,y
  sta entity_sprite_flags,x
do_not_use_as_direction:

  ;seed the random number
  lda stream_read_address_lo
  eor hero_x
  sta npcman_pseudo_random_number,x

npcman_frame_counter_not_zero:

  ;move the npc man in the direction he is facing if the random number sample is between 0 and 3
  ;anything else is interpreted as a "pause."
  lda npcman_pseudo_random_number_sample,x
  and #%00000100
  bne do_not_move

  ;use direction as index into increment luts
  ldy npcman_direction,x

  clc
  lda entity_x_lo,x
  adc npcman_direction_speed_x_lo,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc npcman_direction_speed_x_hi,y
  sta entity_x_hi,x

  clc
  lda entity_y_lo,x
  adc npcman_direction_speed_y_lo,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc npcman_direction_speed_y_hi,y
  sta entity_y_hi,x

  jsr keep_within_walk_rectangle

  jsr entity_update_animation

do_not_move:

  jsr entity_test_hero_rect
  bne do_not_start_conversation

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne do_not_start_conversation

  ;cancel the hero's attack, overriding the default a button behavior.
  jsr hero_cancel_attack

  ;face the hero
  ldy hero_direction
  lda npcman_opposite_direction,y
  sta npcman_direction,x
  tay
  lda npcman_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npcman_animation_addresses_hi,y
  sta entity_animation_address_hi,x
  lda npcman_sprite_flags_direction,y
  sta entity_sprite_flags,x

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda entity_param,x
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
  sta npcman_pseudo_random_number_sample,x

not_left_of_rect:

  sec
  lda w0
  sbc #NPCMAN_WALK_RECT_WIDTH
  lda w0+1
  sbc #0
  bmi not_right_of_rect

  clc
  lda entity_spawn_x_lo,x
  adc #NPCMAN_WALK_RECT_WIDTH
  sta entity_x_lo,x
  lda entity_spawn_x_hi,x
  adc #0
  sta entity_x_hi,x

  ;stop npc from walking
  lda #4
  sta npcman_pseudo_random_number_sample,x

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
  sta npcman_pseudo_random_number_sample,x

not_above_rect:

  sec
  lda w1
  sbc #NPCMAN_WALK_RECT_HEIGHT
  lda w1+1
  sbc #0
  bmi not_below_rect

  clc
  lda entity_spawn_y_lo,x
  adc #NPCMAN_WALK_RECT_HEIGHT
  sta entity_y_lo,x
  lda entity_spawn_y_hi,x
  adc #0
  sta entity_y_hi,x

  ;stop npc from walking
  lda #4
  sta npcman_pseudo_random_number_sample,x

not_below_rect:

  rts

.endif
