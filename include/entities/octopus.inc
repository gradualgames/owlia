.linecont +
.ifndef OCTOPUS_INC
OCTOPUS_INC = 1

OCTOPUS_INITIAL_HEALTH = 2

OCTOPUS_ATTACKED_LENGTH = 30

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
octopus_health            = entity_local6
octopus_attacked_counter = entity_local7

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

  ;intiialize fine x and y coordinates and velocity
  lda #0
  sta octopus_x_fine,x
  sta octopus_y_fine,x
  sta octopus_velocity_x_lo,x
  sta octopus_velocity_x_hi,x
  sta octopus_velocity_y_lo,x
  sta octopus_velocity_y_hi,x

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

  lda #OCTOPUS_STATE_MAIN
  sta entity_state,x

  rts

octopus_state_main:

  lda #OCTOPUS_ATTACKED_LENGTH
  sta b0
  lda #<octopus_attacked_counter
  sta w0
  lda #>octopus_attacked_counter
  sta w0+1
  lda #<octopus_health
  sta w1
  lda #>octopus_health
  sta w1+1
  jsr entity_combat

  .scope
  ;calculate distance between "goal" and X coordinate
  sec
  lda hero_x
  sbc entity_x_lo,x
  sta octopus_velocity_x_lo,x
  lda hero_x+1
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
  lda hero_y
  sbc entity_y_lo,x
  sta octopus_velocity_y_lo,x
  lda hero_y+1
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

.endif
