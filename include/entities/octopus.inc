.linecont +
.ifndef OCTOPUS_INC
OCTOPUS_INC = 1

OCTOPUS_RANGE_RECT_WIDTH = 128
OCTOPUS_RANGE_RECT_HEIGHT = 128
OCTOPUS_RANGE_RECT_X_OFFSET = 64
OCTOPUS_RANGE_RECT_Y_OFFSET = 64

OCTOPUS_INITIAL_HEALTH = 2

OCTOPUS_ATTACKED_LENGTH = 30

OCTOPUS_KNOCKBACK_LENGTH = 30

.enum
OCTOPUS_STATE_INIT
OCTOPUS_STATE_MAIN
.endenum

octopus_velocity_x_lo    = entity_local0
octopus_velocity_x_hi    = entity_local1
octopus_velocity_y_lo    = entity_local2
octopus_velocity_y_hi    = entity_local3
octopus_x_fine            = entity_local4
octopus_y_fine            = entity_local5
octopus_range_rect_x_lo   = entity_local6
octopus_range_rect_x_hi   = entity_local7
octopus_range_rect_y_lo   = entity_local8
octopus_range_rect_y_hi   = entity_local9
octopus_initial_x_lo      = entity_local10
octopus_initial_x_hi      = entity_local11
octopus_initial_y_lo      = entity_local12
octopus_initial_y_hi      = entity_local13
octopus_health            = entity_local17
octopus_knockback_counter = entity_local18
octopus_attacked_counter = entity_local19

.define octopus_states \
  octopus_state_init, \
  octopus_state_main

octopus_lo:
  .lobytes octopus_states

octopus_hi:
  .hibytes octopus_states

octopus_update:

  entity_state_switchboard octopus_lo, octopus_hi

octopus_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #23
  sta entity_width,x
  lda #23
  sta entity_height,x

  ldy #sprite_chr_group_index_octopus
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  ;save initial location
  lda entity_x_lo,x
  sta octopus_initial_x_lo,x
  lda entity_x_hi,x
  sta octopus_initial_x_hi,x
  lda entity_y_lo,x
  sta octopus_initial_y_lo,x
  lda entity_y_hi,x
  sta octopus_initial_y_hi,x

  ;initialize range rect based on initial location
  sec
  lda entity_x_lo,x
  sbc #<OCTOPUS_RANGE_RECT_X_OFFSET
  sta octopus_range_rect_x_lo,x
  lda entity_x_hi,x
  sbc #>OCTOPUS_RANGE_RECT_X_OFFSET
  sta octopus_range_rect_x_hi,x

  sec
  lda entity_y_lo,x
  sbc #<OCTOPUS_RANGE_RECT_Y_OFFSET
  sta octopus_range_rect_y_lo,x
  lda entity_y_hi,x
  sbc #>OCTOPUS_RANGE_RECT_Y_OFFSET
  sta octopus_range_rect_y_hi,x

  ;intiialize fine x and y coordinates and velocity
  lda #0
  sta octopus_x_fine,x
  sta octopus_y_fine,x
  sta octopus_velocity_x_lo,x
  sta octopus_velocity_x_hi,x
  sta octopus_velocity_y_lo,x
  sta octopus_velocity_y_hi,x

  clc
  lda entity_x_lo,x
  adc #$08
  sta w0
  lda entity_x_hi,x
  adc #$00
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #$18
  sta w1
  lda entity_y_hi,x
  adc #$00
  sta w1+1

  jsr sprite_add_shadow_spot

  lda #<OctopusFly
  sta entity_animation_address_lo,x
  lda #>OctopusFly
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #$00
  sta entity_sprite_flags,x

  lda #OCTOPUS_INITIAL_HEALTH
  sta octopus_health,x

  lda #0
  sta octopus_attacked_counter,x
  sta octopus_knockback_counter,x

  lda #OCTOPUS_STATE_MAIN
  sta entity_state,x

  rts

octopus_state_main:

  lda #OCTOPUS_ATTACKED_LENGTH
  sta b0
  lda #OCTOPUS_KNOCKBACK_LENGTH
  sta b1
  jsr entity_combat

  ;determine whether hero is within range rect
  .scope
  jsr octopus_test_range_rect
  beq use_hero_location
use_initial_location:

  lda octopus_initial_x_lo,x
  sta w0
  lda octopus_initial_x_hi,x
  sta w0+1

  lda octopus_initial_y_lo,x
  sta w1
  lda octopus_initial_y_hi,x
  sta w1+1

  jmp done
use_hero_location:

  lda hero_x
  sta w0
  lda hero_x+1
  sta w0+1

  lda hero_y
  sta w1
  lda hero_y+1
  sta w1+1

done:
  .endscope

  .scope
  ;calculate distance between "goal" and X coordinate
  sec
  lda w0
  sbc entity_x_lo,x
  sta octopus_velocity_x_lo,x
  lda w0+1
  sbc entity_x_hi,x
  sta octopus_velocity_x_hi,x

  ;do an 16 bit arithmetic left shift on this value
  asl octopus_velocity_x_lo,x
  rol octopus_velocity_x_hi,x
  asl octopus_velocity_x_lo,x
  rol octopus_velocity_x_hi,x
  asl octopus_velocity_x_lo,x
  rol octopus_velocity_x_hi,x
  .endscope

  .scope
  ;calculate distance between "goal" and Y coordinate
  sec
  lda w1
  sbc entity_y_lo,x
  sta octopus_velocity_y_lo,x
  lda w1+1
  sbc entity_y_hi,x
  sta octopus_velocity_y_hi,x

  ;do an 16 bit arithmetic left shift on this value
  asl octopus_velocity_y_lo,x
  rol octopus_velocity_y_hi,x
  asl octopus_velocity_y_lo,x
  rol octopus_velocity_y_hi,x
  asl octopus_velocity_y_lo,x
  rol octopus_velocity_y_hi,x
  .endscope

  .scope
  lda octopus_velocity_x_lo,x
  sta w10
  lda octopus_velocity_x_hi,x
  sta w10+1
  bpl not_negative
  ;find absolute value
  lda w10
  eor #$ff
  adc #$01
  sta w10
  lda w10+1
  eor #$ff
  adc #$00
  sta w10+1
not_negative:
  .endscope

  .scope
  lda octopus_velocity_y_lo,x
  sta w11
  lda octopus_velocity_y_hi,x
  sta w11+1
  bpl not_negative
  ;find absolute value
  lda w11
  eor #$ff
  adc #$01
  sta w11
  lda w11+1
  eor #$ff
  adc #$00
  sta w11+1
not_negative:
  .endscope

  .scope
  lda w10+1
  sbc #1
  bpl do_not_move
  lda w11+1
  sbc #1
  bpl do_not_move

  jsr octopus_move

do_not_move:
  .endscope

  clc
  lda entity_x_lo,x
  adc #$08
  sta w0
  lda entity_x_hi,x
  adc #$00
  sta w0+1

  clc
  lda entity_y_lo,x
  adc #$18
  sta w1
  lda entity_y_hi,x
  adc #$00
  sta w1+1

  jsr sprite_add_shadow_spot

  jsr entity_update_animation

  rts

.proc octopus_test_range_rect

  ;transfer range rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda octopus_range_rect_x_lo,x
  sta w2
  lda octopus_range_rect_x_hi,x
  sta w2+1
  lda octopus_range_rect_y_lo,x
  sta w3
  lda octopus_range_rect_y_hi,x
  sta w3+1
  lda #OCTOPUS_RANGE_RECT_WIDTH
  sta b2
  lda #OCTOPUS_RANGE_RECT_HEIGHT
  sta b3

  ;transfer hero rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda hero_x
  sta w4
  lda hero_x+1
  sta w4+1
  lda hero_y
  sta w5
  lda hero_y+1
  sta w5+1
  lda hero_width
  sta b4
  lda hero_height
  sta b5

  jsr geotests_rect_in_rect_16bit

  rts

.endproc

.proc octopus_move

  ;if knockback counter is nonzero, negate both x and y velocities
  ;to give the appearance the octopus is being knocked away
  .scope
  lda octopus_knockback_counter,x
  beq do_not_negate_x_and_y_velocities

  clc
  lda octopus_velocity_x_lo,x
  eor #$ff
  adc #$01
  sta octopus_velocity_x_lo,x
  lda octopus_velocity_x_hi,x
  eor #$ff
  adc #$00
  sta octopus_velocity_x_hi,x

  clc
  lda octopus_velocity_y_lo,x
  eor #$ff
  adc #$01
  sta octopus_velocity_y_lo,x
  lda octopus_velocity_y_hi,x
  eor #$ff
  adc #$00
  sta octopus_velocity_y_hi,x

do_not_negate_x_and_y_velocities:
  .endscope

  ;add 16 bit velocity to 24 bit coordinate with sign extension
  .scope
  clc
  lda octopus_velocity_x_lo,x
  adc octopus_x_fine,x
  sta octopus_x_fine,x
  lda octopus_velocity_x_hi,x
  bmi sign_extend

  adc entity_x_lo,x
  sta entity_x_lo,x

  lda entity_x_hi,x
  adc #0
  sta entity_x_hi,x

  jmp done
sign_extend:

  adc entity_x_lo,x
  sta entity_x_lo,x

  lda entity_x_hi,x
  adc #$ff
  sta entity_x_hi,x
done:
  .endscope

  .scope
  clc
  lda octopus_velocity_y_lo,x
  adc octopus_y_fine,x
  sta octopus_y_fine,x
  lda octopus_velocity_y_hi,x
  bmi sign_extend

  adc entity_y_lo,x
  sta entity_y_lo,x

  lda entity_y_hi,x
  adc #0
  sta entity_y_hi,x

  jmp done
sign_extend:

  adc entity_y_lo,x
  sta entity_y_lo,x

  lda entity_y_hi,x
  adc #$ff
  sta entity_y_hi,x
done:
  .endscope

  ;test sign of x velocity and flip the Octopus's animation flag accordingly
  .scope
  lda octopus_velocity_x_hi,x
  bmi octopus_face_left
octopus_face_right:

  lda entity_sprite_flags,x
  and #%10111111
  sta entity_sprite_flags,x

  jmp done
octopus_face_left:

  lda entity_sprite_flags,x
  ora #%01000000
  sta entity_sprite_flags,x

done:
  .endscope

  rts

.endproc

.endif
