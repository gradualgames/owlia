.linecont +
.ifndef TREASURE_CHEST_INC
TREASURE_CHEST_INC = 1

TREASURE_CHEST_WIDTH = $0f
TREASURE_CHEST_HEIGHT = $0f

.enum
TREASURE_CHEST_STATE_INIT
TREASURE_CHEST_STATE_MAIN
.endenum

.define treasure_chest_states \
  treasure_chest_state_init, \
  treasure_chest_state_main

treasure_chest_lo:
  .lobytes treasure_chest_states

treasure_chest_hi:
  .hibytes treasure_chest_states

treasure_chest_update:

  entity_state_switchboard treasure_chest_lo, treasure_chest_hi

treasure_chest_state_init:

  jsr entity_set_drawable

  lda #<treasure_chest
  sta entity_animation_address_lo,x
  lda #>treasure_chest
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #TREASURE_CHEST_WIDTH
  sta entity_width,x
  lda #TREASURE_CHEST_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ;lda #sprite_chr_group_index_treasure_chest
  ;sta b0
  ;jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #TREASURE_CHEST_STATE_MAIN
  sta entity_state,x

  rts

treasure_chest_state_main:

  rts

.endif
