.linecont +
.ifndef ANGLERFISH_INC
ANGLERFISH_INC = 1

ANGLERFISH_WIDTH = $0f
ANGLERFISH_HEIGHT = $0f

.enum
ANGLERFISH_STATE_INIT
ANGLERFISH_STATE_MAIN
.endenum

.define anglerfish_states \
  anglerfish_state_init, \
  anglerfish_state_main

anglerfish_lo:
  .lobytes anglerfish_states

anglerfish_hi:
  .hibytes anglerfish_states

anglerfish_update:

  entity_state_switchboard anglerfish_lo, anglerfish_hi

anglerfish_state_init:

  jsr entity_set_drawable

  lda #<AnglerFishSide
  sta entity_animation_address_lo,x
  lda #>AnglerFishSide
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #ANGLERFISH_WIDTH
  sta entity_width,x
  lda #ANGLERFISH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_anglerfish
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #ANGLERFISH_STATE_MAIN
  sta entity_state,x

  rts

anglerfish_state_main:

  jsr entity_update_animation

  rts

.endif
