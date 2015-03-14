.linecont +
.ifndef CLAM_INC
CLAM_INC = 1

CLAM_STATE_OPEN_LENGTH = 20
CLAM_STATE_REVEAL_TREASURE_LENGTH = 80
CLAM_STATE_CLOSE_LENGTH = 20

CLAM_ITEM_OFFSET_X = 4
CLAM_ITEM_OFFSET_Y = 4

CLAM_ITEM_QUANTITY = 100

CLAM_INITIAL_JUMP_VELOCITY = 500
CLAM_JUMP_ACCELERATION = -50

CLAM_WIDTH = $0f
CLAM_HEIGHT = $0f

.enum
CLAM_STATE_INIT
CLAM_STATE_OPEN
CLAM_STATE_REVEAL_TREASURE
CLAM_STATE_CLOSE
CLAM_STATE_ANGRY
.endenum

clam_state_counter = entity_local0
clam_item_entity_index = entity_local1
clam_x_lo = entity_local2
clam_x_hi = entity_local3
clam_x_fine = entity_local4
clam_y_lo = entity_local5
clam_y_hi = entity_local6
clam_y_fine = entity_local7
clam_altitude_lo = entity_local8
clam_altitude_hi = entity_local9
clam_altitude_fine = entity_local10
clam_x_velocity_lo = entity_local11
clam_x_velocity_hi = entity_local12
clam_y_velocity_lo = entity_local13
clam_y_velocity_hi = entity_local14
clam_altitude_velocity_lo = entity_local15
clam_altitude_velocity_hi = entity_local16

.define clam_states \
  clam_state_init, \
  clam_state_open, \
  clam_state_reveal_treasure, \
  clam_state_close, \
  clam_state_angry

clam_lo:
  .lobytes clam_states

clam_hi:
  .hibytes clam_states

clam_update:

  entity_state_switchboard clam_lo, clam_hi

clam_state_init:

  jsr entity_set_drawable

  jsr entity_set_shadow_spot

  lda #<clam
  sta entity_animation_address_lo,x
  lda #>clam
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CLAM_WIDTH
  sta entity_width,x
  lda #CLAM_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_clam
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda24 clam_x, 0
  move16 entity_x, clam_x

  lda24 clam_y, 0
  move16 entity_y, clam_y

  lda24 clam_altitude, 0

  lda16 clam_x_velocity, 0
  lda16 clam_y_velocity, 0
  lda16 clam_altitude_velocity, 0

  jsr position_clam

  lda #CLAM_STATE_OPEN_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_OPEN
  sta entity_state,x

  rts

clam_state_open:

  .scope
  dec clam_state_counter,x
  bne do_not_transition_yet

  lda #entity_index_item
  sta b0

  clc
  lda entity_x_lo,x
  adc #<CLAM_ITEM_OFFSET_X
  sta w0
  lda entity_x_hi,x
  adc #>CLAM_ITEM_OFFSET_X
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<CLAM_ITEM_OFFSET_Y
  sta w1
  lda entity_y_hi,x
  adc #>CLAM_ITEM_OFFSET_Y
  sta w1+1

  jsr entity_spawn

  lda spawned_entity
  sta clam_item_entity_index,x

  ldy spawned_entity
  lda #ITEM_STATE_PICKUP_INIT
  sta item_initial_state,y
  lda #ITEM_TYPE_GP
  sta item_type,y
  lda #<CLAM_ITEM_QUANTITY
  sta item_quantity_lo,y
  lda #>CLAM_ITEM_QUANTITY
  sta item_quantity_hi,y
  lda #0
  sta item_dungeon_flags_mask,y

  lda #CLAM_STATE_REVEAL_TREASURE_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_REVEAL_TREASURE
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr position_clam

  jsr entity_update_animation

  rts

clam_state_reveal_treasure:

  .scope
  dec clam_state_counter,x
  bne do_not_transition_yet

  .scope
  ldy clam_item_entity_index,x
  cpy familiar_carried_entity_index
  beq taken

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq taken
not_taken:

  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y

  lda #CLAM_STATE_CLOSE_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_CLOSE
  sta entity_state,x

  jmp done
taken:

  lda16 clam_altitude_velocity, CLAM_INITIAL_JUMP_VELOCITY

  lda #CLAM_STATE_ANGRY
  sta entity_state,x

done:
  .endscope

do_not_transition_yet:
  .endscope

  jsr position_clam

  rts

clam_state_close:

  .scope
  dec clam_state_counter,x
  bne do_not_transition_yet

  lda #CLAM_STATE_OPEN_LENGTH
  sta clam_state_counter,x

  lda #CLAM_STATE_OPEN
  sta entity_state,x

do_not_transition_yet:
  .endscope

  jsr position_clam

  jsr entity_update_animation

  rts

clam_state_angry:

  add_acceleration clam_altitude_velocity, CLAM_JUMP_ACCELERATION

  jsr move_clam

  jsr position_clam

  jsr entity_update_animation

  rts

.proc move_clam

  add_velocity clam_x, clam_x_velocity
  add_velocity clam_y, clam_y_velocity
  add_velocity clam_altitude, clam_altitude_velocity

  .scope
  lda clam_altitude_hi,x
  bpl do_not_reset_jump

  lda24 clam_altitude, 0
  lda16 clam_altitude_velocity, CLAM_INITIAL_JUMP_VELOCITY

do_not_reset_jump:
  .endscope

  rts

.endproc

.proc position_clam

  move16 clam_x, entity_x

  sec
  lda clam_y_lo,x
  sbc clam_altitude_lo,x
  sta entity_y_lo,x
  lda clam_y_hi,x
  sbc clam_altitude_hi,x
  sta entity_y_hi,x

  lda16 entity_shadow_spot_x, 4

  move16 clam_altitude, entity_shadow_spot_y

  clc
  lda entity_shadow_spot_y_lo,x
  adc #<8
  sta entity_shadow_spot_y_lo,x
  lda entity_shadow_spot_y_hi,x
  adc #>8
  sta entity_shadow_spot_y_hi,x

  rts

.endproc

.endif
