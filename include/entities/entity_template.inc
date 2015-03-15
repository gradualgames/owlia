.linecont +
.ifndef TEMPLATE_INC
TEMPLATE_INC = 1

TEMPLATE_WIDTH = $0f
TEMPLATE_HEIGHT = $0f

.enum
TEMPLATE_STATE_INIT
TEMPLATE_STATE_MAIN
.endenum

define_lohi_tables template, \
 {template_state_init, \
  template_state_main}

template_update:

  entity_state_switchboard template_lo, template_hi

template_state_init:

  jsr entity_set_drawable

  lda #<template
  sta entity_animation_address_lo,x
  lda #>template
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #TEMPLATE_WIDTH
  sta entity_width,x
  lda #TEMPLATE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ;lda #sprite_chr_group_index_template
  ;sta b0
  ;jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #TEMPLATE_STATE_MAIN
  sta entity_state,x

  rts

template_state_main:

  jsr entity_update_animation

  rts

.endif
