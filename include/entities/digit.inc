.linecont +
.ifndef DIGIT_INC
DIGIT_INC = 1

.enum
DIGIT_STATE_INIT
DIGIT_STATE_MAIN
.endenum

define_lohi_tables digit, \
 {digit_state_init, \
  digit_state_main}

digit_update:

  entity_state_switchboard digit_lo, digit_hi

digit_state_init:

  jsr entity_set_drawable

  jsr entity_set_not_pausable

  lda #<digit
  sta entity_animation_address_lo,x
  lda #>digit
  sta entity_animation_address_hi,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_dropshadow_digits
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #DIGIT_STATE_MAIN
  sta entity_state,x

  rts

digit_state_main:

  rts

.endif
