.linecont +
.ifndef BOTTLE_INC
BOTTLE_INC = 1

BOTTLE_WIDTH = $0f
BOTTLE_HEIGHT = $0f

.enum
BOTTLE_STATE_INIT
BOTTLE_STATE_MAIN
.endenum

define_lohi_tables bottle, \
 {bottle_state_init, \
  bottle_state_main}

bottle_update:

  entity_state_switchboard bottle_lo, bottle_hi

bottle_state_init:

  jsr entity_set_drawable

  lda #<bottle
  sta entity_animation_address_lo,x
  lda #>bottle
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #BOTTLE_WIDTH
  sta entity_width,x
  lda #BOTTLE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_minigame
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #BOTTLE_STATE_MAIN
  sta entity_state,x

  rts

bottle_state_main:

  jsr entity_update_animation

  rts

.endif
