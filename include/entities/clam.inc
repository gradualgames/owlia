.linecont +
.ifndef CLAM_INC
CLAM_INC = 1

CLAM_WIDTH = $0f
CLAM_HEIGHT = $0f

.enum
CLAM_STATE_INIT
CLAM_STATE_MAIN
.endenum

.define clam_states \
  clam_state_init, \
  clam_state_main

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

  lda #CLAM_STATE_MAIN
  sta entity_state,x

  rts

clam_state_main:

  jsr entity_update_animation

  rts

.endif
