.include "ram.inc"
.include "spritesheet0.inc"

.ifndef HERO_INC
HERO_INC = 1

hero_update:

  lda #0
  sta entity_animation_frame,x
  lda #1
  sta entity_animation_counter,x
  
  lda #0
  sta entity_sprite_group_offset,x
  
  lda #<WalkSide
  sta entity_animation_address_lo,x
  lda #>WalkSide
  sta entity_animation_address_hi,x

  rts

.endif
