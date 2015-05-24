.linecont +
.ifndef KRAKEN_INC
KRAKEN_INC = 1

KRAKEN_WIDTH = $0f
KRAKEN_HEIGHT = $0f

.enum
KRAKEN_STATE_INIT
KRAKEN_STATE_MAIN
.endenum

define_lohi_tables kraken, \
 {kraken_state_init, \
  kraken_state_main}

kraken_update:

  entity_state_switchboard kraken_lo, kraken_hi

kraken_state_init:

  jsr entity_set_is_enemy

  jsr entity_set_drawable

  lda #<kraken_tentacle_attack_bent
  sta entity_animation_address_lo,x
  lda #>kraken_tentacle_attack_bent
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #KRAKEN_WIDTH
  sta entity_width,x
  lda #KRAKEN_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_kraken
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #KRAKEN_STATE_MAIN
  sta entity_state,x

  rts

kraken_state_main:

  jsr entity_update_animation

  rts

.endif
