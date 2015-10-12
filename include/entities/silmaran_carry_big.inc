.linecont +
.ifndef SILMARAN_CARRY_BIG_INC
SILMARAN_CARRY_BIG_INC = 1

SILMARAN_CARRY_BIG_WIDTH = $0f
SILMARAN_CARRY_BIG_HEIGHT = $0f

.enum
SILMARAN_CARRY_BIG_STATE_INIT
SILMARAN_CARRY_BIG_STATE_MAIN
.endenum

define_lohi_tables silmaran_carry_big, \
 {silmaran_carry_big_state_init, \
  silmaran_carry_big_state_main}

silmaran_carry_big_update:

  entity_state_switchboard silmaran_carry_big_lo, silmaran_carry_big_hi

silmaran_carry_big_state_init:

  jsr entity_set_drawable

  lda #<silmaran_carry_big
  sta entity_animation_address_lo,x
  lda #>silmaran_carry_big
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SILMARAN_CARRY_BIG_WIDTH
  sta entity_width,x
  lda #SILMARAN_CARRY_BIG_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_silmaran_carry_big
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  jsr controller_clear
  set_controller_routine controller_nop

  lda hero_flags
  and #HERO_FLAGS_DRAWABLE_CLEAR
  ora #HERO_FLAGS_HIDE_STATUS_SET
  sta hero_flags

  lda #SILMARAN_CARRY_BIG_STATE_MAIN
  sta entity_state,x

  rts

silmaran_carry_big_state_main:

  jsr entity_update_animation

  rts

.endif
