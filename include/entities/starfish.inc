.linecont +
.ifndef STARFISH_INC
STARFISH_INC = 1

STARFISH_WIDTH = $0f
STARFISH_HEIGHT = $0f

.enum
STARFISH_STATE_INIT
STARFISH_STATE_MAIN
.endenum

.define starfish_states \
  starfish_state_init, \
  starfish_state_main

starfish_lo:
  .lobytes starfish_states

starfish_hi:
  .hibytes starfish_states

starfish_update:

  entity_state_switchboard starfish_lo, starfish_hi

starfish_state_init:

  jsr entity_set_drawable

  lda #<starfish
  sta entity_animation_address_lo,x
  lda #>starfish
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #STARFISH_WIDTH
  sta entity_width,x
  lda #STARFISH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_starfish
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #STARFISH_STATE_MAIN
  sta entity_state,x

  rts

starfish_state_main:

  jsr entity_update_animation

  rts

.endif
