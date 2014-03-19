.linecont +
.ifndef GREATHORNEDOWL_INC
GREATHORNEDOWL_INC = 1

GREATHORNEDOWL_WIDTH = $0f
GREATHORNEDOWL_HEIGHT = $0f

greathornedowl_cage_entity_index = entity_local0

.enum
GREATHORNEDOWL_STATE_INIT
GREATHORNEDOWL_STATE_MAIN
.endenum

.define greathornedowl_states \
  greathornedowl_state_init, \
  greathornedowl_state_main

greathornedowl_lo:
  .lobytes greathornedowl_states

greathornedowl_hi:
  .hibytes greathornedowl_states

greathornedowl_update:

  entity_state_switchboard greathornedowl_lo, greathornedowl_hi

greathornedowl_state_init:

  jsr entity_set_drawable

  lda #<GreatHornedOwlInsideCage
  sta entity_animation_address_lo,x
  lda #>GreatHornedOwlInsideCage
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #GREATHORNEDOWL_WIDTH
  sta entity_width,x
  lda #GREATHORNEDOWL_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_greathornedowl
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  clc
  lda entity_x_lo,x
  adc #<8
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>8
  sta entity_x_hi,x

  sec
  lda entity_y_lo,x
  sbc #<8
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>8
  sta entity_y_hi,x

  lda #$00
  sta entity_sprite_flags,x

  ;search for the cage entity and remember its index
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_type,y
  cmp #entity_index_cage
  bne not_cage

  tya
  sta greathornedowl_cage_entity_index,x
  jmp done

not_cage:

  dey
  bpl next_entity
done:
  .endscope

  lda #GREATHORNEDOWL_STATE_MAIN
  sta entity_state,x

  rts

greathornedowl_state_main:

  jsr entity_update_animation

  rts

.endif
