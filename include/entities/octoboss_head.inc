.linecont +
.ifndef OCTOBOSS_HEAD_INC
OCTOBOSS_HEAD_INC = 1

OCTOBOSS_HEAD_WIDTH = $0f
OCTOBOSS_HEAD_HEIGHT = $0f

.enum
OCTOBOSS_HEAD_STATE_INIT
OCTOBOSS_HEAD_STATE_MAIN
.endenum

.define octoboss_head_states \
  octoboss_head_state_init, \
  octoboss_head_state_main

octoboss_head_lo:
  .lobytes octoboss_head_states

octoboss_head_hi:
  .hibytes octoboss_head_states

octoboss_head_update:

  entity_state_switchboard octoboss_head_lo, octoboss_head_hi

octoboss_head_state_init:

  jsr entity_set_drawable

  lda #<OctobossHead
  sta entity_animation_address_lo,x
  lda #>OctobossHead
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #OCTOBOSS_HEAD_WIDTH
  sta entity_width,x
  lda #OCTOBOSS_HEAD_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_octoboss
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #OCTOBOSS_HEAD_STATE_MAIN
  sta entity_state,x

  rts

octoboss_head_state_main:

  jsr entity_update_animation

  rts

.endif
