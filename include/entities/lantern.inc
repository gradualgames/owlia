.linecont +
.ifndef LANTERN_INC
LANTERN_INC = 1

LANTERN_WIDTH = $07
LANTERN_HEIGHT = $07

.enum
LANTERN_STATE_INIT
LANTERN_STATE_MAIN
.endenum

.define lantern_states \
  lantern_state_init, \
  lantern_state_main

lantern_lo:
  .lobytes lantern_states

lantern_hi:
  .hibytes lantern_states

lantern_update:

  entity_state_switchboard lantern_lo, lantern_hi

lantern_state_init:

  jsr entity_set_drawable_unsorted

  lda #<Lantern
  sta entity_animation_address_lo,x
  lda #>Lantern
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #LANTERN_WIDTH
  sta entity_width,x
  lda #LANTERN_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_lantern
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #LANTERN_STATE_MAIN
  sta entity_state,x

  rts

lantern_state_main:

  jsr entity_update_animation

  rts

.endif
