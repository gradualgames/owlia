.linecont +
.ifndef ENDING_INC
ENDING_INC = 1

ENDING_WIDTH = $0f
ENDING_HEIGHT = $0f

.enum
ENDING_STATE_INIT
ENDING_STATE_MAIN
.endenum

define_lohi_tables ending, \
 {ending_state_init, \
  ending_state_main}

ending_update:

  entity_state_switchboard ending_lo, ending_hi

ending_state_init:

  ; jsr entity_set_drawable

  ; lda #<ending
  ; sta entity_animation_address_lo,x
  ; lda #>ending
  ; sta entity_animation_address_hi,x

  ; jsr entity_reset_animation

  ; lda #ENDING_WIDTH
  ; sta entity_width,x
  ; lda #ENDING_HEIGHT
  ; sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ;lda #sprite_chr_group_index_ending
  ;sta b0
  ;jsr entity_lookup_sprite_chr_offset

  ; lda #$00
  ; sta entity_sprite_flags,x

  jsr controller_clear
  set_controller_routine controller_nop

  lda hero_flags
  and #HERO_FLAGS_DRAWABLE_CLEAR
  sta hero_flags

  lda #ENDING_STATE_MAIN
  sta entity_state,x

  rts

ending_state_main:

  jsr entity_update_animation

  rts

.endif
