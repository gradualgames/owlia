.linecont +
.ifndef CLAM_INC
CLAM_INC = 1

CLAM_STATE_OPEN_LENGTH = 20
CLAM_STATE_REVEAL_TREASURE_LENGTH = 80
CLAM_STATE_CLOSE_LENGTH = 20

CLAM_ITEM_OFFSET_X = 4
CLAM_ITEM_OFFSET_Y = 4

CLAM_ITEM_QUANTITY = 100

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

  lda #CLAM_STATE_ANGRY
  sta entity_state,x

done:
  .endscope

do_not_transition_yet:
  .endscope

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

  jsr entity_update_animation

  rts

clam_state_angry:

  jsr entity_update_animation

  rts

.endif
