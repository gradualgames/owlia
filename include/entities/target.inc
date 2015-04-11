.linecont +
.ifndef TARGET_INC
TARGET_INC = 1

TARGET_WIDTH = $0f
TARGET_HEIGHT = $0f

.enum
TARGET_STATE_INIT
TARGET_STATE_MAIN
.endenum

define_lohi_tables target, \
 {target_state_init, \
  target_state_main}

target_update:

  entity_state_switchboard target_lo, target_hi

target_state_init:

  jsr entity_set_drawable

  lda #<ship
  sta entity_animation_address_lo,x
  lda #>ship
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #TARGET_WIDTH
  sta entity_width,x
  lda #TARGET_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_minigame
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #TARGET_STATE_MAIN
  sta entity_state,x

  rts

target_state_main:

  jsr entity_update_animation

  rts

.endif
