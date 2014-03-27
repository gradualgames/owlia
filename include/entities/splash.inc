.linecont +
.ifndef SPLASH_INC
SPLASH_INC = 1

.include "splash_constants.inc"

SPLASH_WIDTH = $0f
SPLASH_HEIGHT = $0f

.define splash_states \
  splash_state_init, \
  splash_state_splash, \
  splash_state_hide, \
  splash_state_show

splash_lo:
  .lobytes splash_states

splash_hi:
  .hibytes splash_states

splash_update:

  entity_state_switchboard splash_lo, splash_hi

splash_state_init:

  jsr entity_clear_drawable

  lda #<Splash
  sta entity_animation_address_lo,x
  lda #>Splash
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SPLASH_WIDTH
  sta entity_width,x
  lda #SPLASH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_splash
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #SPLASH_STATE_SHOW
  sta entity_state,x

  rts

splash_state_splash:

  jsr entity_set_sorted

  jsr entity_update_animation

  rts

splash_state_hide:

  jsr entity_clear_drawable

  lda #SPLASH_STATE_SPLASH
  sta entity_state,x

  jmp splash_state_splash

splash_state_show:

  jsr entity_set_drawable

  lda #SPLASH_STATE_SPLASH
  sta entity_state,x

  jmp splash_state_splash

.endif
