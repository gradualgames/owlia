.linecont +
.include "familiar.inc"
.include "familiar_constants.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprites_and_animations_data.inc"
.include "entities.inc"
.include "sprite.inc"

.segment "CODE"

;initializes the familiar module
.proc familiar_init

  lda #0
  sta familiar_state
  sta familiar_flags

  rts

.endproc

;sets the familiar to be alive.
.proc familiar_spawn

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_INIT
  sta familiar_state

  rts

.endproc

;draws the familiar
.proc familiar_draw

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_TEST
  beq familiar_not_alive
  ;calculate screen coordinates based on the camera coordinates
  sec
  lda familiar_x
  sbc camera_x
  sta w3
  lda familiar_x+1
  sbc camera_x+1
  sta w3+1

  sec
  lda familiar_y
  sbc camera_y
  sta w4
  lda familiar_y+1
  sbc camera_y+1
  sta w4+1

  ;subtract 8 to correct for the needed nametable offset to straddle metatile updates
  ;between the topmost row of nametable tiles and the bottommost row of nametable tiles
  clc
  lda w4
  adc #$08
  sta w4
  lda w4+1
  adc #$00
  sta w4+1

  lda familiar_sprite_group_offset
  sta sprite_group_offset

  lda familiar_sprite_flags
  sta b2

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  jsr sprite_draw_animation
familiar_not_alive:

  rts

.endproc

familiar_direction_speed_x_lo:
  .byte FAMILIAR_SPEED, -FAMILIAR_SPEED, 0, 0

familiar_direction_speed_x_hi:
  .byte 0, -1, 0, 0

familiar_direction_speed_y_lo:
  .byte 0, 0, FAMILIAR_SPEED, -FAMILIAR_SPEED

familiar_direction_speed_y_hi:
  .byte 0, 0, 0, -1

.define familiar_states \
    familiar_state_init, \
    familiar_state_main

familiar_lo:
  .lobytes familiar_states

familiar_hi:
  .hibytes familiar_states

familiar_update:

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_TEST
  beq familiar_not_alive
  lda familiar_state
  tay
  lda familiar_lo,y
  sta w0
  lda familiar_hi,y
  sta w0+1
  jmp (w0)
familiar_not_alive:

  rts

familiar_state_init:

  lda #<FamiliarFly
  sta familiar_animation_address
  sta w2
  lda #>FamiliarFly
  sta familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  jsr sprite_reset_animation

  lda #entity_index_familiar
  tay
  lda entity_type_chr_offsets,y
  sta familiar_sprite_group_offset

  lda #0
  sta familiar_sprite_flags

  lda #FAMILIAR_STATE_MAIN
  sta familiar_state

  rts

familiar_state_main:

  ldy familiar_direction
  clc
  lda familiar_x
  adc familiar_direction_speed_x_lo,y
  sta familiar_x
  lda familiar_x+1
  adc familiar_direction_speed_x_hi,y
  sta familiar_x+1

  clc
  lda familiar_y
  adc familiar_direction_speed_y_lo,y
  sta familiar_y
  lda familiar_y+1
  adc familiar_direction_speed_y_hi,y
  sta familiar_y+1

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1

  jsr sprite_update_animation

  rts
