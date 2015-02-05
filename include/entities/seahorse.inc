.linecont +
.ifndef SEAHORSE_INC
SEAHORSE_INC = 1

SEAHORSE_WIDTH = $0f
SEAHORSE_HEIGHT = $1f

.enum
SEAHORSE_STATE_INIT
SEAHORSE_STATE_MAIN
.endenum

.define seahorse_states \
  seahorse_state_init, \
  seahorse_state_main

seahorse_lo:
  .lobytes seahorse_states

seahorse_hi:
  .hibytes seahorse_states

seahorse_update:

  entity_state_switchboard seahorse_lo, seahorse_hi

seahorse_state_init:

  jsr entity_set_drawable

  lda #<seahorse_side
  sta entity_animation_address_lo,x
  lda #>seahorse_side
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SEAHORSE_WIDTH
  sta entity_width,x
  lda #SEAHORSE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_seahorse
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #SEAHORSE_STATE_MAIN
  sta entity_state,x

  rts

seahorse_state_main:

  jsr entity_update_animation

  rts

.endif
