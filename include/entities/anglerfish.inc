.linecont +
.ifndef ANGLERFISH_INC
ANGLERFISH_INC = 1

.include "anglerfish_constants.inc"

ANGLERFISH_WIDTH = $0f
ANGLERFISH_HEIGHT = $0f

ANGLERFISH_SPEED = 150

ANGLERFISH_TURN_LENGTH = 80

anglerfish_turn_mode = entity_local0
anglerfish_direction = entity_local1
anglerfish_x_fine = entity_local2
anglerfish_y_fine = entity_local3
anglerfish_turn_counter = entity_local4

anglerfish_turn_direction:
anglerfish_turnright_direction:
  .byte ANGLERFISH_DIRECTION_DOWN
  .byte ANGLERFISH_DIRECTION_UP
  .byte ANGLERFISH_DIRECTION_LEFT
  .byte ANGLERFISH_DIRECTION_RIGHT

anglerfish_turnleft_direction:
  .byte ANGLERFISH_DIRECTION_UP
  .byte ANGLERFISH_DIRECTION_DOWN
  .byte ANGLERFISH_DIRECTION_RIGHT
  .byte ANGLERFISH_DIRECTION_LEFT

.define anglerfish_animation_addresses \
  AnglerFishSide, \
  AnglerFishSide, \
  AnglerFishDown, \
  AnglerFishUp

anglerfish_animation_addresses_lo:
  .lobytes anglerfish_animation_addresses

anglerfish_animation_addresses_hi:
  .hibytes anglerfish_animation_addresses

anglerfish_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000
  .byte %00000000, %01000000, %00000000, %00000000

.define anglerfish_direction_speed_x ANGLERFISH_SPEED, -ANGLERFISH_SPEED, 0, 0

anglerfish_direction_speed_x_lo:
  .lobytes anglerfish_direction_speed_x

anglerfish_direction_speed_x_hi:
  .hibytes anglerfish_direction_speed_x

.define anglerfish_direction_speed_y 0, 0, ANGLERFISH_SPEED, -ANGLERFISH_SPEED

anglerfish_direction_speed_y_lo:
  .lobytes anglerfish_direction_speed_y

anglerfish_direction_speed_y_hi:
  .hibytes anglerfish_direction_speed_y

.enum
ANGLERFISH_STATE_INIT
ANGLERFISH_STATE_MAIN
.endenum

.define anglerfish_states \
  anglerfish_state_init, \
  anglerfish_state_main

anglerfish_lo:
  .lobytes anglerfish_states

anglerfish_hi:
  .hibytes anglerfish_states

anglerfish_update:

  entity_state_switchboard anglerfish_lo, anglerfish_hi

anglerfish_state_init:

  jsr entity_set_drawable

  lda #<AnglerFishSide
  sta entity_animation_address_lo,x
  lda #>AnglerFishSide
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #ANGLERFISH_WIDTH
  sta entity_width,x
  lda #ANGLERFISH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_anglerfish
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #$00
  sta anglerfish_x_fine,x
  sta anglerfish_y_fine,x

  lda #ANGLERFISH_TURN_LENGTH
  sta anglerfish_turn_counter,x

  ; ;spawn a spotlight entity
  ; txa
  ; pha

  ; lda #entity_index_spotlight
  ; sta b0

  ; lda entity_x_lo,x
  ; sta w0
  ; lda entity_x_hi,x
  ; sta w0+1
  ; lda entity_y_lo,x
  ; sta w1
  ; lda entity_y_hi,x
  ; sta w1+1

  ; jsr entity_spawn

  ; pla
  ; tax

  lda #ANGLERFISH_STATE_MAIN
  sta entity_state,x

  rts

anglerfish_state_main:

  dec anglerfish_turn_counter,x
  bne do_not_turn_anglerfish

  clc
  lda anglerfish_direction,x
  adc anglerfish_turn_mode,x
  tay
  lda anglerfish_turn_direction,y
  sta anglerfish_direction,x

  lda #ANGLERFISH_TURN_LENGTH
  sta anglerfish_turn_counter,x

do_not_turn_anglerfish:

  ldy anglerfish_direction,x
  .scope
  lda anglerfish_direction_speed_x_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda anglerfish_x_fine,x
  adc anglerfish_direction_speed_x_lo,y
  sta anglerfish_x_fine,x
  lda entity_x_lo,x
  adc anglerfish_direction_speed_x_hi,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x
  jmp done
sign_extend_negative:
  clc
  lda anglerfish_x_fine,x
  adc anglerfish_direction_speed_x_lo,y
  sta anglerfish_x_fine,x
  lda entity_x_lo,x
  adc anglerfish_direction_speed_x_hi,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$ff
  sta entity_x_hi,x
done:
  .endscope

  .scope
  lda anglerfish_direction_speed_y_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda anglerfish_y_fine,x
  adc anglerfish_direction_speed_y_lo,y
  sta anglerfish_y_fine,x
  lda entity_y_lo,x
  adc anglerfish_direction_speed_y_hi,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x
  jmp done
sign_extend_negative:
  clc
  lda anglerfish_y_fine,x
  adc anglerfish_direction_speed_y_lo,y
  sta anglerfish_y_fine,x
  lda entity_y_lo,x
  adc anglerfish_direction_speed_y_hi,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$ff
  sta entity_y_hi,x
done:
  .endscope

  clc
  ldy anglerfish_direction,x
  lda anglerfish_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda anglerfish_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda anglerfish_sprite_flags_direction,y
  sta entity_sprite_flags,x

  jsr entity_update_animation

  rts

.endif
