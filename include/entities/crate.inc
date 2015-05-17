.linecont +
.ifndef CRATE_INC
CRATE_INC = 1

CRATE_WIDTH = $0f
CRATE_HEIGHT = $0f

.enum
CRATE_STATE_INIT
CRATE_STATE_MAIN
.endenum

define_lohi_tables crate, \
 {crate_state_init, \
  crate_state_main}

crate_update:

  entity_state_switchboard crate_lo, crate_hi

crate_state_init:

  jsr entity_set_drawable

  lda #<crate
  sta entity_animation_address_lo,x
  lda #>crate
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CRATE_WIDTH
  sta entity_width,x
  lda #CRATE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_crate
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  jsr crate_make_impassable

  lda #CRATE_STATE_MAIN
  sta entity_state,x

  rts

crate_state_main:

  jsr entity_update_animation

  rts

.proc crate_make_impassable

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  clc
  lda entity_x_lo,x
  adc #<16
  sta w0
  lda entity_x_hi,x
  adc #>16
  sta w0+1

  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<16
  sta w1
  lda entity_y_hi,x
  adc #>16
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  clc
  lda entity_x_lo,x
  adc #<16
  sta w0
  lda entity_x_hi,x
  adc #>16
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #<16
  sta w1
  lda entity_y_hi,x
  adc #>16
  sta w1+1

  jsr set_dynamic_single_screen_collision_field_bit

  rts

.endproc

.endif
