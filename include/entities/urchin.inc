.linecont +
.ifndef URCHIN_INC
URCHIN_INC = 1

.include "urchin_constants.inc"

.define urchin_states \
  urchin_state_init, \
  urchin_state_pause, \
  urchin_state_slide

urchin_lo:
  .lobytes urchin_states

urchin_hi:
  .hibytes urchin_states

urchin_update:

  entity_state_switchboard urchin_lo, urchin_hi

urchin_state_init:

  jsr entity_set_drawable

  lda #<urchin
  sta entity_animation_address_lo,x
  lda #>urchin
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #URCHIN_WIDTH
  sta entity_width,x
  lda #URCHIN_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_urchin
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #0
  sta urchin_attacked_counter,x
  sta urchin_flash_counter,x
  sta urchin_knockback_counter,x
  sta urchin_direction,x
  lda #URCHIN_INITIAL_HEALTH
  sta urchin_health,x

  lda #$00
  sta urchin_x_fine,x
  sta urchin_y_fine,x

  lda urchin_pause_length,x
  sta urchin_frame_counter,x

  lda #URCHIN_STATE_PAUSE
  sta entity_state,x

  rts

urchin_state_pause:

  .scope
  dec urchin_frame_counter,x
  bne do_not_switch_state

  lda urchin_slide_length,x
  sta urchin_frame_counter,x

  lda #URCHIN_STATE_SLIDE
  sta entity_state,x

do_not_switch_state:
  .endscope

  jsr urchin_combat

  jsr entity_update_animation

  rts

urchin_state_slide:

  .scope
  dec urchin_frame_counter,x
  bne do_not_switch_state

  ;negate x and y velocity
  .scope
  clc
  lda urchin_x_velocity_lo,x
  eor #$ff
  adc #<1
  sta urchin_x_velocity_lo,x
  lda urchin_x_velocity_hi,x
  eor #$ff
  adc #>1
  sta urchin_x_velocity_hi,x
  .endscope

  .scope
  clc
  lda urchin_y_velocity_lo,x
  eor #$ff
  adc #<1
  sta urchin_y_velocity_lo,x
  lda urchin_y_velocity_hi,x
  eor #$ff
  adc #>1
  sta urchin_y_velocity_hi,x
  .endscope

  lda urchin_slide_length,x
  sta urchin_frame_counter,x

  lda #URCHIN_STATE_PAUSE
  sta entity_state,x

do_not_switch_state:
  .endscope

  ;add x and y velocity to coordinates with sign extension
  .scope
  lda #0
  sta b0
  lda urchin_x_velocity_hi,x
  bpl positive
  lda #$ff
  sta b0
positive:

  clc
  lda urchin_x_fine,x
  adc urchin_x_velocity_lo,x
  sta urchin_x_fine,x
  lda entity_x_lo,x
  adc urchin_x_velocity_hi,x
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc b0
  sta entity_x_hi,x
  .endscope

  .scope
  lda #0
  sta b0
  lda urchin_y_velocity_hi,x
  bpl positive
  lda #$ff
  sta b0
positive:

  clc
  lda urchin_y_fine,x
  adc urchin_y_velocity_lo,x
  sta urchin_y_fine,x
  lda entity_y_lo,x
  adc urchin_y_velocity_hi,x
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc b0
  sta entity_y_hi,x
  .endscope

  jsr urchin_combat

  jsr entity_update_animation

  rts

.proc urchin_combat

  entity_electric_bomb_combat #URCHIN_FLASH_LENGTH, #URCHIN_KNOCKBACK_LENGTH, urchin_flash_counter, urchin_knockback_counter, urchin_health, urchin_direction

  rts

.endproc

.endif
