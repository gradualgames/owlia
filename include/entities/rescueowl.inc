.linecont +
.ifndef RESCUEOWL_INC
RESCUEOWL_INC = 1

.include "rescueowl_constants.inc"

.define rescueowl_inside_cage_animations \
  GreatHornedOwlInsideCage

rescueowl_inside_cage_animations_lo:
  .lobytes rescueowl_inside_cage_animations

rescueowl_inside_cage_animations_hi:
  .hibytes rescueowl_inside_cage_animations

rescueowl_spr_chr_group_indices:
  .byte sprite_chr_group_index_greathornedowl

.define rescueowl_states \
  rescueowl_state_init, \
  rescueowl_state_main

rescueowl_lo:
  .lobytes rescueowl_states

rescueowl_hi:
  .hibytes rescueowl_states

rescueowl_update:

  entity_state_switchboard rescueowl_lo, rescueowl_hi

rescueowl_state_init:

  jsr entity_set_drawable

  ldy rescueowl_type,x
  lda rescueowl_inside_cage_animations_lo,y
  sta entity_animation_address_lo,x
  lda rescueowl_inside_cage_animations_hi,y
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #RESCUEOWL_WIDTH
  sta entity_width,x
  lda #RESCUEOWL_HEIGHT
  sta entity_height,x

  ldy rescueowl_type,x
  lda rescueowl_spr_chr_group_indices,y
  tay
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

  lda #RESCUEOWL_STATE_MAIN
  sta entity_state,x

  rts

rescueowl_state_main:

  jsr entity_update_animation

  rts

.endif
