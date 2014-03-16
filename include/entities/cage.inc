.linecont +
.ifndef CAGE_INC
CAGE_INC = 1

CAGE_WIDTH = $0f
CAGE_HEIGHT = $0f

.enum
CAGE_STATE_INIT
CAGE_STATE_MAIN
.endenum

.define cage_states \
  cage_state_init, \
  cage_state_main

cage_lo:
  .lobytes cage_states

cage_hi:
  .hibytes cage_states

cage_update:

  entity_state_switchboard cage_lo, cage_hi

cage_state_init:

  jsr entity_set_drawable

  lda #<Cage
  sta entity_animation_address_lo,x
  lda #>Cage
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CAGE_WIDTH
  sta entity_width,x
  lda #CAGE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_cage
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #CAGE_STATE_MAIN
  sta entity_state,x

  rts

cage_state_main:

  jsr entity_update_animation

  rts

.endif
