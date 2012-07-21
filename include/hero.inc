.include "ram.inc"
.include "spritesheet0.inc"
.include "entity.inc"

.ifndef HERO_INC
HERO_INC = 1

hero_update:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #50
  sta entity_x_lo,x
  lda #0
  sta entity_x_hi,x
  lda #50
  sta entity_y_lo,x
  lda #0
  sta entity_y_hi,x

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
