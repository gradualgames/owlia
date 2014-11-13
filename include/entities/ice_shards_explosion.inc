.linecont +
.ifndef ICE_SHARDS_EXPLOSION_INC
ICE_SHARDS_EXPLOSION_INC = 1

ICE_SHARDS_EXPLOSION_WIDTH = $0f
ICE_SHARDS_EXPLOSION_HEIGHT = $0f

.enum
ICE_SHARDS_EXPLOSION_STATE_INIT
ICE_SHARDS_EXPLOSION_STATE_MAIN
.endenum

.define ice_shards_explosion_states \
  ice_shards_explosion_state_init, \
  ice_shards_explosion_state_main

ice_shards_explosion_lo:
  .lobytes ice_shards_explosion_states

ice_shards_explosion_hi:
  .hibytes ice_shards_explosion_states

ice_shards_explosion_update:

  entity_state_switchboard ice_shards_explosion_lo, ice_shards_explosion_hi

ice_shards_explosion_state_init:

  jsr entity_set_drawable

  lda #<shards
  sta entity_animation_address_lo,x
  lda #>shards
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #ICE_SHARDS_EXPLOSION_WIDTH
  sta entity_width,x
  lda #ICE_SHARDS_EXPLOSION_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_ice_shards
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #ICE_SHARDS_EXPLOSION_STATE_MAIN
  sta entity_state,x

  rts

ice_shards_explosion_state_main:

  jsr entity_update_animation

  rts

.endif
