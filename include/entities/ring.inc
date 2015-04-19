.linecont +
.ifndef RING_INC
RING_INC = 1

RING_FAMILIAR_X_OFFSET = 0
RING_FAMILIAR_Y_OFFSET = 16

RING_STATE_PAUSE_BEFORE_RETURNING_HOME_LENGTH = 50

RING_WIDTH = $0f
RING_HEIGHT = $0f

ring_x_lo = entity_x_lo
ring_x_hi = entity_x_hi

ring_y_lo = entity_y_lo
ring_y_hi = entity_y_hi

ring_bottle_index = entity_local0
ring_x_fine = entity_local1
ring_y_fine = entity_local2
ring_x_velocity_lo = entity_local3
ring_x_velocity_hi = entity_local4
ring_y_velocity_lo = entity_local5
ring_y_velocity_hi = entity_local6
ring_state_counter = entity_local7
ring_spawn_x_lo = entity_local8
ring_spawn_x_hi = entity_local9
ring_spawn_y_lo = entity_local10
ring_spawn_y_hi = entity_local11

.enum
RING_STATE_INIT
RING_STATE_WAIT_UNTIL_FETCHED
RING_STATE_SEARCH_FOR_BOTTLES
RING_STATE_FALL_ONTO_BOTTLE
RING_STATE_PAUSE_BEFORE_RETURNING_HOME
RING_STATE_RETURN_HOME
.endenum

define_lohi_tables ring, \
 {ring_state_init, \
  ring_state_wait_until_fetched, \
  ring_state_search_for_bottles, \
  ring_state_fall_onto_bottle, \
  ring_state_pause_before_returning_home, \
  ring_state_return_home}

ring_update:

  entity_state_switchboard ring_lo, ring_hi

ring_state_init:

  jsr entity_set_drawable

  lda #<ring
  sta entity_animation_address_lo,x
  lda #>ring
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #RING_WIDTH
  sta entity_width,x
  lda #RING_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_minigame
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #0
  sta ring_x_fine,x
  sta ring_y_fine,x

  entity_move16 ring_x, ring_spawn_x
  entity_move16 ring_y, ring_spawn_y

  entity_lda16 ring_x_velocity, 0
  entity_lda16 ring_y_velocity, 0

  lda #RING_STATE_WAIT_UNTIL_FETCHED
  sta entity_state,x

  rts

ring_state_wait_until_fetched:

  .scope
  lda entity_action_rect2_action
  cmp #ENTITY_ACTION_FETCH
  bne familiar_not_fetching

  jsr entity_test_entity_action_rect2
  bne familiar_not_intersecting

  ;store offsets for this entity when it is being fetched by familiar
  lda #RING_FAMILIAR_X_OFFSET
  sta familiar_carried_entity_x_offset
  lda #RING_FAMILIAR_Y_OFFSET
  sta familiar_carried_entity_y_offset

  ;tell the familiar to return to the hero with the fetched item.
  far_call #FAMILIAR_BANK, familiar_fetch_current_item

  lda #RING_STATE_SEARCH_FOR_BOTTLES
  sta entity_state,x

familiar_not_intersecting:
familiar_not_fetching:
  .endscope

  rts

ring_state_search_for_bottles:

  ;search for bottle entities. if the ring intersects with a bottle
  ;hit box, then randomly decide whether to "fall onto the bottle."
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  lda entity_type,y
  cmp #entity_index_bottle
  bne skip_entity

  ;if we reach here we found an alive bottle entity
  ;compare the ring's rect to the bottle's rect

  ;transfer entity rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda entity_x_lo,x
  sta w2
  lda entity_x_hi,x
  sta w2+1
  lda entity_y_lo,x
  sta w3
  lda entity_y_hi,x
  sta w3+1
  lda entity_width,x
  sta b2
  lda entity_height,x
  sta b3

  ;transfer bottle rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda entity_x_lo,y
  sta w4
  lda entity_x_hi,y
  sta w4+1
  lda entity_y_lo,y
  sta w5
  lda entity_y_hi,y
  sta w5+1
  lda entity_width,y
  sta b4
  lda entity_height,y
  sta b5

  jsr geotests_rect_in_rect_size
  bne skip_entity

  ;if we reach here the ring intersects the bottle. Now randomly decide
  ;whether to enter the "fall onto this bottle" state.
  lda rand
  and #%00001111
  bne skip_entity

  lda #$ff
  sta familiar_carried_entity_index

  tya
  sta ring_bottle_index,x

  lda #RING_STATE_FALL_ONTO_BOTTLE
  sta entity_state,x
  rts

skip_entity:
  dey
  bpl next_entity
  .endscope

  ;if the carried entity index changes to $ff here, we know it
  ;has been done by the familiar itself. Thus we know the ring
  ;failed to fall onto a bottle. Now we can change to a state that
  ;times out and returns to home.
  .scope
  lda familiar_carried_entity_index
  cmp #$ff
  bne ring_still_being_carried

  lda #RING_STATE_PAUSE_BEFORE_RETURNING_HOME_LENGTH
  sta ring_state_counter,x

  lda #RING_STATE_PAUSE_BEFORE_RETURNING_HOME
  sta entity_state,x

ring_still_being_carried:
  .endscope

  rts

ring_state_fall_onto_bottle:

  ;home into the bottle's position
  ldy ring_bottle_index,x

  clc
  lda entity_x_lo,y
  sta w0
  lda entity_x_hi,y
  sta w0+1

  clc
  lda entity_y_lo,y
  sta w1
  lda entity_y_hi,y
  sta w1+1

  ;calculate initial velocity as distance between goal and current location of eye
  sec
  lda w0
  sbc entity_x_lo,x
  sta ring_x_velocity_lo,x
  lda w0+1
  sbc entity_x_hi,x
  sta ring_x_velocity_hi,x

  sec
  lda w1
  sbc entity_y_lo,x
  sta ring_y_velocity_lo,x
  lda w1+1
  sbc entity_y_hi,x
  sta ring_y_velocity_hi,x

  ;now modify velocity
  lda ring_x_velocity_hi,x
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  sta ring_x_velocity_hi,x

  lda ring_y_velocity_hi,x
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  sta ring_y_velocity_hi,x

  entity_add_velocity ring_x, ring_x_velocity
  entity_add_velocity ring_y, ring_y_velocity

  ;if both velocities reach zero, the ring has reached the
  ;bottle. switch to a state where we count down and then
  ;return to the home position.
  .scope
  lda ring_x_velocity_lo,x
  ora ring_x_velocity_hi,x
  ora ring_y_velocity_lo,x
  ora ring_y_velocity_hi,x
  bne ring_still_falling_onto_bottle

  lda #RING_STATE_PAUSE_BEFORE_RETURNING_HOME_LENGTH
  sta ring_state_counter,x

  lda #RING_STATE_PAUSE_BEFORE_RETURNING_HOME
  sta entity_state,x

ring_still_falling_onto_bottle:
  .endscope

  rts

ring_state_pause_before_returning_home:

  .scope
  dec ring_state_counter,x
  bne do_not_transition_yet

  lda #RING_STATE_RETURN_HOME
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

ring_state_return_home:

  clc
  lda ring_spawn_x_lo,x
  sta w0
  lda ring_spawn_x_hi,x
  sta w0+1

  clc
  lda ring_spawn_y_lo,x
  sta w1
  lda ring_spawn_y_hi,x
  sta w1+1

  ;calculate initial velocity as distance between goal and current location of eye
  sec
  lda w0
  sbc entity_x_lo,x
  sta ring_x_velocity_lo,x
  lda w0+1
  sbc entity_x_hi,x
  sta ring_x_velocity_hi,x

  sec
  lda w1
  sbc entity_y_lo,x
  sta ring_y_velocity_lo,x
  lda w1+1
  sbc entity_y_hi,x
  sta ring_y_velocity_hi,x

  ;now modify velocity
  lda ring_x_velocity_hi,x
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  asl ring_x_velocity_lo,x
  rol
  sta ring_x_velocity_hi,x

  lda ring_y_velocity_hi,x
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  asl ring_y_velocity_lo,x
  rol
  sta ring_y_velocity_hi,x

  entity_add_velocity ring_x, ring_x_velocity
  entity_add_velocity ring_y, ring_y_velocity

  .scope
  lda ring_x_velocity_lo,x
  ora ring_x_velocity_hi,x
  ora ring_y_velocity_lo,x
  ora ring_y_velocity_hi,x
  bne ring_still_returning_home

  lda #RING_STATE_WAIT_UNTIL_FETCHED
  sta entity_state,x

ring_still_returning_home:
  .endscope

  rts

.endif
