.linecont +
.ifndef CRAB_INC
CRAB_INC = 1

CRAB_WIDTH = (8 * 3 - 1)
CRAB_HALFWIDTH = (CRAB_WIDTH>>1)
CRAB_HEIGHT = (8 * 3 - 1)
CRAB_HALFHEIGHT = (CRAB_HEIGHT>1)

CRAB_SPEED = 150

CRAB_ATTACKED_LENGTH = 30

.enum
CRAB_DIRECTION_RIGHT
CRAB_DIRECTION_LEFT
CRAB_DIRECTION_DOWN
CRAB_DIRECTION_UP
.endenum

CRAB_INITIAL_DIRECTION = CRAB_DIRECTION_DOWN
CRAB_INITIAL_HEALTH = 3

crab_direction = entity_local0
crab_random_turnleft_counter = entity_local1
crab_random_turnright_counter = entity_local2
crab_pseudo_random_number = entity_local3
crab_x_fine = entity_local4
crab_y_fine = entity_local5
crab_health = entity_local6
crab_attacked_counter = entity_local7

.enum
CRAB_STATE_INIT
CRAB_STATE_MAIN
.endenum

crab_turnright_direction:
  .byte CRAB_DIRECTION_DOWN
  .byte CRAB_DIRECTION_UP
  .byte CRAB_DIRECTION_LEFT
  .byte CRAB_DIRECTION_RIGHT

crab_turnleft_direction:
  .byte CRAB_DIRECTION_UP
  .byte CRAB_DIRECTION_DOWN
  .byte CRAB_DIRECTION_RIGHT
  .byte CRAB_DIRECTION_LEFT

.define crab_direction_speed_x CRAB_SPEED, -CRAB_SPEED, 0, 0

crab_direction_speed_x_lo:
  .lobytes crab_direction_speed_x

crab_direction_speed_x_hi:
  .hibytes crab_direction_speed_x

.define crab_direction_speed_y 0, 0, CRAB_SPEED, -CRAB_SPEED

crab_direction_speed_y_lo:
  .lobytes crab_direction_speed_y

crab_direction_speed_y_hi:
  .hibytes crab_direction_speed_y

.define crab_collision_offset_x \
  CRAB_WIDTH, \
  0, \
  CRAB_HALFWIDTH, \
  CRAB_HALFWIDTH

crab_collision_offset_x_lo:
  .lobytes crab_collision_offset_x

crab_collision_offset_x_hi:
  .hibytes crab_collision_offset_x

.define crab_collision_offset_y \
  CRAB_HALFHEIGHT, \
  CRAB_HALFHEIGHT, \
  CRAB_HEIGHT, \
  0

crab_collision_offset_y_lo:
  .lobytes crab_collision_offset_y

crab_collision_offset_y_hi:
  .hibytes crab_collision_offset_y

.define crab_states \
  crab_state_init, \
  crab_state_main

crab_lo:
  .lobytes crab_states

crab_hi:
  .hibytes crab_states

crab_update:

  entity_state_switchboard crab_lo, crab_hi

crab_state_init:

  jsr entity_set_drawable

  lda #<CrabWalk
  sta entity_animation_address_lo,x
  lda #>CrabWalk
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CRAB_WIDTH
  sta entity_width,x
  lda #CRAB_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_crab
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #0
  sta crab_x_fine,x
  sta crab_y_fine,x

  lda #CRAB_INITIAL_DIRECTION
  sta crab_direction,x
  lda #1
  sta crab_random_turnleft_counter,x
  sta crab_random_turnright_counter,x

  lda #CRAB_INITIAL_HEALTH
  sta crab_health,x

  lda #0
  sta crab_attacked_counter,x

  lda #CRAB_STATE_MAIN
  sta entity_state,x

  rts

crab_state_main:

  lda #CRAB_ATTACKED_LENGTH
  sta b0
  lda #<crab_attacked_counter
  sta w0
  lda #>crab_attacked_counter
  sta w0+1
  lda #<crab_health
  sta w1
  lda #>crab_health
  sta w1+1
  jsr entity_combat

  ;permute the pseudo random number
  .scope
: lda crab_pseudo_random_number,x
  beq doEor
  asl
  beq noEor ;if the input was $80, skip the EOR
  bcc noEor
doEor:
  eor stream_read_address_lo
noEor:
  sta crab_pseudo_random_number,x
  dey
  bne :-

  sta crab_pseudo_random_number,x
  .endscope

  .scope
  dec crab_random_turnleft_counter,x
  bne do_not_turn_crab

  ldy crab_direction,x
  lda crab_turnleft_direction,y
  sta crab_direction,x

  lda crab_pseudo_random_number,x
  sta crab_random_turnleft_counter,x

do_not_turn_crab:
  .endscope

  .scope
  dec crab_random_turnright_counter,x
  bne do_not_turn_crab

  ldy crab_direction,x
  lda crab_turnright_direction,y
  sta crab_direction,x

  ;select random number with an offset
  clc
  lda crab_pseudo_random_number,x
  adc #128
  sta crab_random_turnleft_counter,x

do_not_turn_crab:
  .endscope

  ldy crab_direction,x
  .scope
  lda crab_direction_speed_x_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda crab_x_fine,x
  adc crab_direction_speed_x_lo,y
  sta crab_x_fine,x
  lda entity_x_lo,x
  adc crab_direction_speed_x_hi,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x
  jmp done
sign_extend_negative:
  clc
  lda crab_x_fine,x
  adc crab_direction_speed_x_lo,y
  sta crab_x_fine,x
  lda entity_x_lo,x
  adc crab_direction_speed_x_hi,y
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$ff
  sta entity_x_hi,x
done:
  .endscope

  .scope
  lda crab_direction_speed_y_hi,y
  bmi sign_extend_negative
sign_extend_positive:
  clc
  lda crab_y_fine,x
  adc crab_direction_speed_y_lo,y
  sta crab_y_fine,x
  lda entity_y_lo,x
  adc crab_direction_speed_y_hi,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x
  jmp done
sign_extend_negative:
  clc
  lda crab_y_fine,x
  adc crab_direction_speed_y_lo,y
  sta crab_y_fine,x
  lda entity_y_lo,x
  adc crab_direction_speed_y_hi,y
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$ff
  sta entity_y_hi,x
done:
  .endscope

  ;test for collision offset from crab
  ldy crab_direction,x
  clc
  lda entity_x_lo,x
  adc crab_collision_offset_x_lo,y
  sta w0
  lda entity_x_hi,x
  adc crab_collision_offset_x_hi,y
  sta w0+1
  clc
  lda entity_y_lo,x
  adc crab_collision_offset_y_lo,y
  sta w1
  lda entity_y_hi,x
  adc crab_collision_offset_y_hi,y
  sta w1+1
  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  beq do_not_turn_crab

  ldy crab_direction,x
  lda crab_turnleft_direction,y
  sta crab_direction,x

do_not_turn_crab:

  jsr entity_update_animation

  rts

.endif
