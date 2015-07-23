.linecont +
.ifndef MERMON_TORSO_INC
MERMON_TORSO_INC = 1

MERMON_TORSO_WIDTH = $0f
MERMON_TORSO_HEIGHT = $0f

.enum
MERMON_TORSO_STATE_INIT
MERMON_TORSO_STATE_MAIN
.endenum

define_lohi_tables mermon_torso, \
 {mermon_torso_state_init, \
  mermon_torso_state_main}

mermon_torso_update:

  entity_state_switchboard mermon_torso_lo, mermon_torso_hi

mermon_torso_state_init:

  jsr entity_set_drawable

  lda #<mermon_torso_fly
  sta entity_animation_address_lo,x
  lda #>mermon_torso_fly
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_TORSO_WIDTH
  sta entity_width,x
  lda #MERMON_TORSO_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_mermon
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #MERMON_TORSO_STATE_MAIN
  sta entity_state,x

  rts

mermon_torso_state_main:

  jsr entity_update_animation

  rts

.endif
