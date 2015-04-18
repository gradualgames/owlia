.linecont +
.ifndef RING_INC
RING_INC = 1

RING_FAMILIAR_X_OFFSET = 0
RING_FAMILIAR_Y_OFFSET = 16

RING_FALL_RANDOM_THRESHOLD = 120

RING_WIDTH = $0f
RING_HEIGHT = $0f

ring_x_lo = entity_x_lo
ring_x_hi = entity_x_hi

ring_y_lo = entity_y_lo
ring_y_hi = entity_y_hi

ring_bottle_index = entity_local0
ring_fall_random_value = entity_local1
ring_x_fine = entity_local2
ring_y_fine = entity_local3
ring_x_velocity_lo = entity_local4
ring_x_velocity_hi = entity_local5
ring_y_velocity_lo = entity_local6
ring_y_velocity_hi = entity_local7

.enum
RING_STATE_INIT
RING_STATE_MAIN
RING_STATE_FALL_ONTO_BOTTLE
.endenum

define_lohi_tables ring, \
 {ring_state_init, \
  ring_state_main, \
  ring_state_fall_onto_bottle}

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

  entity_lda16 ring_x_velocity, 0
  entity_lda16 ring_y_velocity, 0

  lda #RING_STATE_MAIN
  sta entity_state,x

  rts

ring_state_main:

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

  lda rand
  sta ring_fall_random_value,x

familiar_not_intersecting:
familiar_not_fetching:
  .endscope

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
  lda ring_fall_random_value,x
  cmp #RING_FALL_RANDOM_THRESHOLD
  bpl skip_entity

  lda #$ff
  sta familiar_carried_entity_index

  tya
  sta ring_bottle_index,x

  lda #RING_STATE_FALL_ONTO_BOTTLE
  sta entity_state,x
  jmp done

skip_entity:
  dey
  bpl next_entity
done:

  .endscope

  jsr entity_update_animation

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

  jsr entity_update_animation

  rts

.endif
