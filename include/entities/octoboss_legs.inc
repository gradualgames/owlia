.linecont +
.ifndef OCTOBOSS_LEGS_INC
OCTOBOSS_LEGS_INC = 1

.include "octoboss_legs_constants.inc"

OCTOBOSS_LEGS_WIDTH = $0f
OCTOBOSS_LEGS_HEIGHT = $0f

OCTOBOSS_LEGS_STATE_PUNCH_LENGTH = 80

octoboss_legs_state_counter = entity_local0

.define octoboss_legs_states \
  octoboss_legs_state_init, \
  octoboss_legs_state_nop, \
  octoboss_legs_state_dangle_init, \
  octoboss_legs_state_dangle, \
  octoboss_legs_state_punch_init, \
  octoboss_legs_state_punch

octoboss_legs_lo:
  .lobytes octoboss_legs_states

octoboss_legs_hi:
  .hibytes octoboss_legs_states

octoboss_legs_update:

  entity_state_switchboard octoboss_legs_lo, octoboss_legs_hi

octoboss_legs_state_init:

  jsr entity_clear_drawable

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

  ;put legs into a passive state til the head tells them what to do
  lda #OCTOBOSS_LEGS_STATE_NOP
  sta entity_state,x

  rts

octoboss_legs_state_nop:

  rts

octoboss_legs_state_dangle_init:

  jsr entity_set_drawable

  lda #<OctobossLegsDangle
  sta entity_animation_address_lo,x
  lda #>OctobossLegsDangle
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #OCTOBOSS_LEGS_STATE_DANGLE
  sta entity_state,x

  jmp octoboss_legs_state_dangle

octoboss_legs_state_dangle:

  jsr entity_update_animation

  rts

octoboss_legs_state_punch_init:

  lda #<OctobossLegsPunch
  sta entity_animation_address_lo,x
  lda #>OctobossLegsPunch
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #OCTOBOSS_LEGS_STATE_PUNCH_LENGTH
  sta octoboss_legs_state_counter,x

  lda #OCTOBOSS_LEGS_STATE_PUNCH
  sta entity_state,x
  jmp octoboss_legs_state_punch

octoboss_legs_state_punch:

  jsr entity_update_animation

  .scope
  dec octoboss_legs_state_counter,x
  bne do_not_switch_state

  lda #OCTOBOSS_LEGS_STATE_DANGLE_INIT
  sta entity_state,x

do_not_switch_state:
  .endscope

  rts

.endif
