.linecont +
.ifndef BOMBABLE_WALL_INC
BOMBABLE_WALL_INC = 1

.include "bombable_wall_constants.inc"

.define bombable_wall_states \
  bombable_wall_state_init, \
  bombable_wall_state_main

bombable_wall_lo:
  .lobytes bombable_wall_states

bombable_wall_hi:
  .hibytes bombable_wall_states

bombable_wall_update:

  entity_state_switchboard bombable_wall_lo, bombable_wall_hi

bombable_wall_state_init:

  jsr entity_clear_drawable

  lda #BOMBABLE_WALL_WIDTH
  sta entity_width,x
  lda #BOMBABLE_WALL_HEIGHT
  sta entity_height,x

  lda #<BOMBABLE_WALL_INITIAL_PATCH_OFFSET_Y
  sta bombable_wall_patch_offset_y_lo,x
  lda #>BOMBABLE_WALL_INITIAL_PATCH_OFFSET_Y
  sta bombable_wall_patch_offset_y_hi,x

  lda #BOMBABLE_WALL_INITIAL_PATCH_ROW
  sta bombable_wall_patch_row,x

  lda #BOMBABLE_WALL_STATE_MAIN
  sta entity_state,x

  rts

bombable_wall_state_main:

  ;patch index
  lda #0
  sta b12

  ;patch row
  lda bombable_wall_patch_row,x
  sta b13

  ;patch attribute
  lda bombable_wall_corridor_attribute,x
  sta b14

  ;x offset at which to draw attribute up the corridor
  lda #16
  sta b15

  clc
  lda entity_x_lo,x
  adc #<BOMBABLE_WALL_PATCH_OFFSET_X
  sta w8
  lda entity_x_hi,x
  adc #>BOMBABLE_WALL_PATCH_OFFSET_X
  sta w8+1

  clc
  lda entity_y_lo,x
  adc bombable_wall_patch_offset_y_lo,x
  sta w9
  lda entity_y_hi,x
  adc bombable_wall_patch_offset_y_hi,x
  sta w9+1

  jsr decode_nametable_patch_row_and_poke_attribute

  dec bombable_wall_patch_row,x
  bmi bombable_wall_die

  sec
  lda bombable_wall_patch_offset_y_lo,x
  sbc #<8
  sta bombable_wall_patch_offset_y_lo,x
  lda bombable_wall_patch_offset_y_hi,x
  sbc #>8
  sta bombable_wall_patch_offset_y_hi,x

  rts

bombable_wall_die:
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

.endif
