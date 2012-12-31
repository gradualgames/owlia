.linecont +
.ifndef NPCWOMAN_INC
NPCWOMAN_INC = 1

.enum
NPCWOMAN_STATE_INIT
NPCWOMAN_STATE_MAIN
.endenum

.enum
NPCWOMAN_DIRECTION_RIGHT
NPCWOMAN_DIRECTION_LEFT
NPCWOMAN_DIRECTION_DOWN
NPCWOMAN_DIRECTION_UP
.endenum

NPCWOMAN_SPEED = 1

NPCWOMAN_WALK_RECT_WIDTH  = 16 * 8
NPCWOMAN_WALK_RECT_HEIGHT = 16 * 2

npcwoman_hero_still_in_rect = entity_local0
npcwoman_direction = entity_local1
npcwoman_pseudo_random_number = entity_local2
npcwoman_frame_counter = entity_local3
npcwoman_pseudo_random_number_sample = entity_local4

npcwoman_direction_speed_x_lo:
  .byte NPCWOMAN_SPEED, -NPCWOMAN_SPEED, 0, 0

npcwoman_direction_speed_x_hi:
  .byte 0, $ff, 0, 0

npcwoman_direction_speed_y_lo:
  .byte 0, 0, NPCWOMAN_SPEED, -NPCWOMAN_SPEED

npcwoman_direction_speed_y_hi:
  .byte 0, 0, 0, $ff

npcwoman_opposite_direction:
  .byte NPCWOMAN_DIRECTION_LEFT
  .byte NPCWOMAN_DIRECTION_RIGHT
  .byte NPCWOMAN_DIRECTION_UP
  .byte NPCWOMAN_DIRECTION_DOWN

.define npcwoman_animation_addresses\
  NpcWomanWalkSide,\
  NpcWomanWalkSide,\
  NpcWomanWalkDown,\
  NpcWomanWalkUp

npcwoman_animation_addresses_lo:
  .lobytes npcwoman_animation_addresses

npcwoman_animation_addresses_hi:
  .hibytes npcwoman_animation_addresses

npcwoman_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000

.proc npcwoman_update

  entity_state_switchboard npcwoman_lo, npcwoman_hi

npcwoman_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #NPCWOMAN_DIRECTION_DOWN
  sta npcwoman_direction,x

  ldy npcwoman_direction,x
  lda npcwoman_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npcwoman_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda npcwoman_sprite_flags_direction,y
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

  lda #$00
  sta npcwoman_hero_still_in_rect,x

  ;seed the random number
  lda stream_read_address_lo
  eor hero_x
  sta npcwoman_pseudo_random_number,x

  lda #NPCWOMAN_STATE_MAIN
  sta entity_state,x

  rts

npcwoman_state_main:

  ;permute the pseudo random number
: lda npcwoman_pseudo_random_number,x
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor #$1d
noEor:
  sta npcwoman_pseudo_random_number,x
  dey
  bne :-

  sta npcwoman_pseudo_random_number,x

  ;decrement the frame counter
  dec npcwoman_frame_counter,x
  bne npcwoman_frame_counter_not_zero

  ;sample lowest 6 bits of pseudo random number and use it as new frame counter
  and #%00111111
  sta npcwoman_frame_counter,x

  ;sample lowest 3 bits of pseudo random number
  and #%00000111
  sta npcwoman_pseudo_random_number_sample,x
  and #%00000100
  bne do_not_use_as_direction

  ;lowest 3 bits was between 0 and 3, use it as the new direction for the npc
  lda npcwoman_pseudo_random_number_sample,x
  sta npcwoman_direction,x

  ;face in that direction
  tay
  lda npcwoman_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npcwoman_animation_addresses_hi,y
  sta entity_animation_address_hi,x
  lda npcwoman_sprite_flags_direction,y
  sta entity_sprite_flags,x
do_not_use_as_direction:

  ;seed the random number
  lda stream_read_address_lo
  eor hero_x
  sta npcwoman_pseudo_random_number,x

npcwoman_frame_counter_not_zero:

  ;move the npc man in the direction he is facing if the random number sample is between 0 and 3
  ;anything else is interpreted as a "pause."
  lda npcwoman_pseudo_random_number_sample,x
  and #%00000100
  bne do_not_move

  ;use direction as index into increment luts
  ldy npcwoman_direction,x

  clc
  lda entity_x_lo,x
  adc npcwoman_direction_speed_x_lo,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc npcwoman_direction_speed_x_hi,y
  sta entity_x_hi,x

  clc
  lda entity_y_lo,x
  adc npcwoman_direction_speed_y_lo,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc npcwoman_direction_speed_y_hi,y
  sta entity_y_hi,x

  jsr keep_within_walk_rectangle

  jsr entity_update_animation

do_not_move:

  jsr hero_is_moving
  beq do_not_start_conversation

  ;test whether hero intersects npc's rect and rotate the result
  ;into npcwoman_hero_still_in_rect. This makes it easy to detect
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
  rol npcwoman_hero_still_in_rect,x
  .endscope

  lda npcwoman_hero_still_in_rect,x
  and #%00000011
  cmp #%00000001
  bne do_not_start_conversation

  ;face the hero
  ldy hero_direction
  lda npcwoman_opposite_direction,y
  sta npcwoman_direction,x
  tay
  lda npcwoman_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npcwoman_animation_addresses_hi,y
  sta entity_animation_address_hi,x
  lda npcwoman_sprite_flags_direction,y
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
  sta npcwoman_pseudo_random_number_sample,x

not_left_of_rect:

  sec
  lda w0
  sbc #NPCWOMAN_WALK_RECT_WIDTH
  lda w0+1
  sbc #0
  bmi not_right_of_rect

  clc
  lda entity_spawn_x_lo,x
  adc #NPCWOMAN_WALK_RECT_WIDTH
  sta entity_x_lo,x
  lda entity_spawn_x_hi,x
  adc #0
  sta entity_x_hi,x

  ;stop npc from walking
  lda #4
  sta npcwoman_pseudo_random_number_sample,x

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
  sta npcwoman_pseudo_random_number_sample,x

not_above_rect:

  sec
  lda w1
  sbc #NPCWOMAN_WALK_RECT_HEIGHT
  lda w1+1
  sbc #0
  bmi not_below_rect

  clc
  lda entity_spawn_y_lo,x
  adc #NPCWOMAN_WALK_RECT_HEIGHT
  sta entity_y_lo,x
  lda entity_spawn_y_hi,x
  adc #0
  sta entity_y_hi,x

  ;stop npc from walking
  lda #4
  sta npcwoman_pseudo_random_number_sample,x

not_below_rect:

  rts

.define npcwoman_states \
  npcwoman_state_init, \
  npcwoman_state_main

npcwoman_lo:
  .lobytes npcwoman_states

npcwoman_hi:
  .hibytes npcwoman_states

.endproc

.endif
