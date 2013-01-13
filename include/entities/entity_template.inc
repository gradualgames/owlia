.linecont +
.ifndef TEMPLATE_INC
TEMPLATE_INC = 1

.enum
TEMPLATE_STATE_INIT
TEMPLATE_STATE_MAIN
.endenum

.define template_states \
  template_state_init, \
  template_state_main

template_lo:
  .lobytes template_states

template_hi:
  .hibytes template_states

template_update:

  entity_state_switchboard template_lo, template_hi

template_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #<Template
  sta entity_animation_address_lo,x
  lda #>Template
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ;ldy #entity_chr_index_template
  ;lda entity_type_chr_offsets,y
  ;sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #TEMPLATE_STATE_MAIN
  sta entity_state,x

  rts

template_state_main:

  jsr entity_update_animation

  rts

.endif
