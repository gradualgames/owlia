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

NPC_WIDTH = 15
NPC_HEIGHT = 31

NPC_CONVERSATION_RECT_X_OFFSET = 8
NPC_CONVERSATION_RECT_Y_OFFSET = 0
NPC_CONVERSATION_RECT_WIDTH    = 8 * 2 + 16
NPC_CONVERSATION_RECT_HEIGHT   = 32

NPC_SPEED = 1

npc_conversation = entity_local0
npc_graphics_set = entity_local1
npc_walk_rect_width = entity_local2
npc_walk_rect_height = entity_local3
npc_direction = entity_local4
npc_pseudo_random_number = entity_local5
npc_frame_counter = entity_local6
npc_pseudo_random_number_sample = entity_local7

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

  jsr entity_set_drawable

  lda #NPC_DIRECTION_DOWN
  sta npc_direction,x

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

  lda #NPC_WIDTH
  sta entity_width,x
  lda #NPC_HEIGHT
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

  ;set unsorted by default. Then test against hero and familiar to
  ;see if the npc should be sorted with them.
  jsr entity_set_drawable

  ;test npc's own rect against hero and familiar to see if the npc
  ;ought to be sorted with them
  jsr entity_test_familiar_rect
  bne not_intersecting_familiar

  jsr entity_set_sorted

not_intersecting_familiar:

  jsr entity_test_hero_rect
  bne not_intersecting_hero

  jsr entity_set_sorted

not_intersecting_hero:

  ;test hero against npc's conversation rect
  sec
  lda entity_x_lo,x
  sbc #NPC_CONVERSATION_RECT_X_OFFSET
  sta w2
  lda entity_x_hi,x
  sbc #0
  sta w2+1

  sec
  lda entity_y_lo,x
  sbc #NPC_CONVERSATION_RECT_Y_OFFSET
  sta w3
  lda entity_y_hi,x
  sbc #0
  sta w3+1

  lda #NPC_CONVERSATION_RECT_WIDTH
  sta b2
  lda #NPC_CONVERSATION_RECT_HEIGHT
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

  jsr geotests_rect_in_rect_16bit
  bne do_not_start_conversation

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne do_not_start_conversation

  jsr start_conversation

do_not_start_conversation:

  rts

start_conversation:

  ;make sure both the npc and the hero are drawable
  jsr entity_set_drawable

  lda hero_flags
  ora #HERO_FLAGS_DRAWABLE_SET
  sta hero_flags

  ;cancel the hero's attack, overriding the default a button behavior.
  jsr hero_cancel_attack

  ;face the hero

  npc_center_x = w0
  npc_center_y = w1
  hero_center_x = w2
  hero_center_y = w3
  x_difference = w4
  y_difference = w5

  ;get center of NPC's x coordinate
  clc
  lda entity_x_lo,x
  adc #(NPC_WIDTH/2)
  sta npc_center_x
  lda entity_x_hi,x
  adc #$00
  sta npc_center_x+1

  ;get center of NPC's y coordinate
  clc
  lda entity_y_lo,x
  adc #(NPC_HEIGHT/2)
  sta npc_center_y
  lda entity_y_hi,x
  adc #$00
  sta npc_center_y+1

  ;get center of hero's x coordinate
  clc
  lda hero_x
  adc #(HERO_WIDTH/2)
  sta hero_center_x
  lda hero_x+1
  adc #$00
  sta hero_center_x+1

  ;get center of hero's y coordinate
  clc
  lda hero_y
  adc #(HERO_HEIGHT/2)
  sta hero_center_y
  lda hero_y+1
  adc #$00
  sta hero_center_y+1

  ;get absolute differences
  .scope
  sec
  lda npc_center_x
  sbc hero_center_x
  sta x_difference
  lda npc_center_x+1
  sbc hero_center_x+1
  sta x_difference+1
  bpl do_not_get_absolute_value

  ;negate x_difference
  lda x_difference
  eor #$ff
  sta x_difference
  lda x_difference+1
  eor #$ff
  sta x_difference+1

  clc
  lda x_difference
  adc #$01
  sta x_difference
  lda x_difference+1
  adc #$00
  sta x_difference+1

do_not_get_absolute_value:
  .endscope

  .scope
  sec
  lda npc_center_y
  sbc hero_center_y
  sta y_difference
  lda npc_center_y+1
  sbc hero_center_y+1
  sta y_difference+1
  bpl do_not_get_absolute_value

  ;negate y_difference
  lda y_difference
  eor #$ff
  sta y_difference
  lda y_difference+1
  eor #$ff
  sta y_difference+1

  clc
  lda y_difference
  adc #$01
  sta y_difference
  lda y_difference+1
  adc #$00
  sta y_difference+1

do_not_get_absolute_value:
  .endscope

  .scope
  sec
  lda x_difference
  sbc y_difference
  lda x_difference+1
  sbc y_difference+1
  bmi use_y_difference
use_x_difference:

  .scope
  sec
  lda hero_center_x
  sbc npc_center_x
  lda hero_center_x+1
  sbc npc_center_x+1
  bmi hero_to_left
hero_to_right:
  lda #NPC_DIRECTION_RIGHT
  sta npc_direction,x
  jmp done
hero_to_left:
  lda #NPC_DIRECTION_LEFT
  sta npc_direction,x
done:
  .endscope

  jmp done

use_y_difference:
  .scope
  sec
  lda hero_center_y
  sbc npc_center_y
  lda hero_center_y+1
  sbc npc_center_y+1
  bmi hero_above
hero_below:
  lda #NPC_DIRECTION_DOWN
  sta npc_direction,x
  jmp done
hero_above:
  lda #NPC_DIRECTION_UP
  sta npc_direction,x
done:
  .endscope

done:
  .endscope

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

  ;make hero face in opposite direction
  lda npc_direction,x
  tay
  lda npc_opposite_direction,y
  sta hero_direction
  jsr hero_face_in_current_direction

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda npc_conversation,x
  sta state_control_params+play_state_control::param

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
