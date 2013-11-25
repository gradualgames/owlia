.linecont +
.ifndef OCTOBOSS_LEGS_INC
OCTOBOSS_LEGS_INC = 1

OCTOBOSS_LEGS_WIDTH = $0f
OCTOBOSS_LEGS_HEIGHT = $0f

.enum
OCTOBOSS_LEGS_STATE_INIT
OCTOBOSS_LEGS_STATE_MAIN
.endenum

.define octoboss_legs_states \
  octoboss_legs_state_init, \
  octoboss_legs_state_main

octoboss_legs_lo:
  .lobytes octoboss_legs_states

octoboss_legs_hi:
  .hibytes octoboss_legs_states

octoboss_legs_update:

  entity_state_switchboard octoboss_legs_lo, octoboss_legs_hi

octoboss_legs_state_init:

  jsr entity_set_drawable

  lda #<OctobossLegsDangle
  sta entity_animation_address_lo,x
  lda #>OctobossLegsDangle
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #OCTOBOSS_LEGS_WIDTH
  sta entity_width,x
  lda #OCTOBOSS_LEGS_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_octoboss
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #OCTOBOSS_LEGS_STATE_MAIN
  sta entity_state,x

  rts

octoboss_legs_state_main:

  jsr entity_update_animation

  rts

.endif
