.linecont +
.ifndef NPC_INC
NPC_INC = 1

.include "npc_constants.inc"

.enum
NPC_STATE_INIT
NPC_STATE_WALK
NPC_STATE_PAUSE
NPC_STATE_MOTIONLESS
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
npc_mode = entity_local4
npc_direction = entity_local5
npc_pseudo_random_number = entity_local6
npc_random_turnleft_counter = entity_local7
npc_random_turnright_counter = entity_local8
npc_random_pause_counter = entity_local9
npc_spawn_x_lo = entity_local10
npc_spawn_x_hi = entity_local11
npc_spawn_y_lo = entity_local12
npc_spawn_y_hi = entity_local13

npc_direction_speed_x_lo:
  .byte NPC_SPEED, -NPC_SPEED, 0, 0

npc_direction_speed_x_hi:
  .byte 0, $ff, 0, 0

npc_direction_speed_y_lo:
  .byte 0, 0, NPC_SPEED, -NPC_SPEED

npc_direction_speed_y_hi:
  .byte 0, 0, 0, $ff

npc_opposite_direction:
  .byte NPC_DIRECTION_LEFT
  .byte NPC_DIRECTION_RIGHT
  .byte NPC_DIRECTION_UP
  .byte NPC_DIRECTION_DOWN

npc_turnright_direction:
  .byte NPC_DIRECTION_DOWN
  .byte NPC_DIRECTION_UP
  .byte NPC_DIRECTION_LEFT
  .byte NPC_DIRECTION_RIGHT

npc_turnleft_direction:
  .byte NPC_DIRECTION_UP
  .byte NPC_DIRECTION_DOWN
  .byte NPC_DIRECTION_RIGHT
  .byte NPC_DIRECTION_LEFT

.define npc_animation_addresses\
  npcman_walk_side,\
  npcman_walk_side,\
  npcman_walk_down,\
  npcman_walk_up, \
  npcwoman_walk_side,\
  npcwoman_walk_side,\
  npcwoman_walk_down,\
  npcwoman_walk_up

npc_animation_addresses_lo:
  .lobytes npc_animation_addresses

npc_animation_addresses_hi:
  .hibytes npc_animation_addresses

npc_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000
  .byte %00000000, %01000000, %00000000, %00000000

.define npc_states \
  npc_state_init, \
  npc_state_walk, \
  npc_state_pause, \
  npc_state_motionless

npc_lo:
  .lobytes npc_states

npc_hi:
  .hibytes npc_states

npc_update:

  entity_state_switchboard npc_lo, npc_hi

npc_state_init:

  jsr entity_set_drawable

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

  lda #0
  sta npc_pseudo_random_number,x

  ;initialize random turn counters. Each time they count
  ;down the npc will turn (or pause), and then a new value will
  ;be selected via a pseudo random number generator.
  lda #255
  sta npc_random_turnright_counter,x

  lda #100
  sta npc_random_turnleft_counter,x

  lda #50
  sta npc_random_pause_counter,x

  ;remember spawn position
  lda entity_x_lo,x
  sta npc_spawn_x_lo,x
  lda entity_x_hi,x
  sta npc_spawn_x_hi,x

  lda entity_y_lo,x
  sta npc_spawn_y_lo,x
  lda entity_y_hi,x
  sta npc_spawn_y_hi,x

  .scope
  lda npc_mode,x
  and #NPC_MODE_TEST
  cmp #NPC_MODE_WALK
  beq walking
  cmp #NPC_MODE_MOTIONLESS
  beq motionless
walking:
  lda #NPC_STATE_WALK
  sta entity_state,x
  jmp done
motionless:
  lda #NPC_STATE_MOTIONLESS
  sta entity_state,x
done:
  .endscope

  rts

npc_state_motionless:

  jsr test_whether_hero_wants_to_start_conversation

  rts

npc_state_pause:

  jsr npc_randomly_turn_or_pause

  jsr test_whether_hero_wants_to_start_conversation

  rts

npc_state_walk:

  jsr npc_randomly_turn_or_pause

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

  jsr test_whether_hero_wants_to_start_conversation

  rts

npc_randomly_turn_or_pause:

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

  .scope
  dec npc_random_turnleft_counter,x
  bne do_not_turn_npc

  lda #NPC_STATE_WALK
  sta entity_state,x

  ldy npc_direction,x
  lda npc_turnleft_direction,y
  sta npc_direction,x

  lda npc_pseudo_random_number,x
  sta npc_random_turnleft_counter,x

do_not_turn_npc:
  .endscope

  .scope
  dec npc_random_turnright_counter,x
  bne do_not_turn_npc

  lda #NPC_STATE_WALK
  sta entity_state,x

  ldy npc_direction,x
  lda npc_turnright_direction,y
  sta npc_direction,x

  ;select random number with an offset
  clc
  lda npc_pseudo_random_number,x
  adc #128
  sta npc_random_turnleft_counter,x

do_not_turn_npc:
  .endscope

  .scope
  dec npc_random_pause_counter,x
  bne do_not_pause_npc

  lda #NPC_STATE_PAUSE
  sta entity_state,x

  ;select random number with an offset
  clc
  lda npc_pseudo_random_number,x
  adc #128
  sta npc_random_pause_counter,x

do_not_pause_npc:
  .endscope

  ;face in that direction
  lda npc_direction,x
  clc
  adc npc_graphics_set,x
  tay
  lda npc_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npc_animation_addresses_hi,y
  sta entity_animation_address_hi,x
  lda npc_sprite_flags_direction,y
  sta entity_sprite_flags,x

  rts

test_whether_hero_wants_to_start_conversation:

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

  jsr geotests_rect_in_rect_size
  bne do_not_start_conversation

  far_call #HERO_BANK, hero_is_attacking
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
  far_call #HERO_BANK, hero_cancel_attack

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
  far_call #HERO_BANK, hero_face_in_current_direction

  ;put hero into a passive state so she cannot
  ;get input from the controller immediately upon
  ;finishing a conversation with the NPC.
  lda #3
  sta b0
  far_call #HERO_BANK, hero_wait_frames

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
  sbc npc_spawn_x_lo,x
  sta w0
  lda entity_x_hi,x
  sbc npc_spawn_x_hi,x
  sta w0+1
  bpl not_left_of_rect

  lda npc_spawn_x_lo,x
  sta entity_x_lo,x
  lda npc_spawn_x_hi,x
  sta entity_x_hi,x

  lda #NPC_DIRECTION_RIGHT
  sta npc_direction,x

not_left_of_rect:

  sec
  lda w0
  sbc npc_walk_rect_width,x
  lda w0+1
  sbc #0
  bmi not_right_of_rect

  clc
  lda npc_spawn_x_lo,x
  adc npc_walk_rect_width,x
  sta entity_x_lo,x
  lda npc_spawn_x_hi,x
  adc #0
  sta entity_x_hi,x

  lda #NPC_DIRECTION_LEFT
  sta npc_direction,x

not_right_of_rect:

  ;subtract spawn y from current y
  sec
  lda entity_y_lo,x
  sbc npc_spawn_y_lo,x
  sta w1
  lda entity_y_hi,x
  sbc npc_spawn_y_hi,x
  sta w1+1
  bpl not_above_rect

  lda npc_spawn_y_lo,x
  sta entity_y_lo,x
  lda npc_spawn_y_hi,x
  sta entity_y_hi,x

  lda #NPC_DIRECTION_DOWN
  sta npc_direction,x

not_above_rect:

  sec
  lda w1
  sbc npc_walk_rect_height,x
  lda w1+1
  sbc #0
  bmi not_below_rect

  clc
  lda npc_spawn_y_lo,x
  adc npc_walk_rect_height,x
  sta entity_y_lo,x
  lda npc_spawn_y_hi,x
  adc #0
  sta entity_y_hi,x

  lda #NPC_DIRECTION_UP
  sta npc_direction,x

not_below_rect:

  rts

.endif
