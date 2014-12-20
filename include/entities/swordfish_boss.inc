.linecont +
.ifndef SWORDFISH_BOSS_INC
SWORDFISH_BOSS_INC = 1

SWORDFISH_BOSS_WIDTH = $0f
SWORDFISH_BOSS_HEIGHT = $0f

.enum
SWORDFISH_BOSS_STATE_INIT
SWORDFISH_BOSS_STATE_MAIN
.endenum

.define swordfish_boss_states \
  swordfish_boss_state_init, \
  swordfish_boss_state_main

swordfish_boss_lo:
  .lobytes swordfish_boss_states

swordfish_boss_hi:
  .hibytes swordfish_boss_states

swordfish_boss_update:

  entity_state_switchboard swordfish_boss_lo, swordfish_boss_hi

swordfish_boss_state_init:

  jsr entity_set_drawable

  lda #<swordfish_boss_swim
  sta entity_animation_address_lo,x
  lda #>swordfish_boss_swim
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SWORDFISH_BOSS_WIDTH
  sta entity_width,x
  lda #SWORDFISH_BOSS_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_swordfish_boss
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #SWORDFISH_BOSS_STATE_MAIN
  sta entity_state,x

  rts

swordfish_boss_state_main:

  jsr entity_update_animation

  rts

.endif
