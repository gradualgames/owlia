.linecont +
.ifndef BOMB_INC
BOMB_INC = 1

BOMB_INITIAL_BOUNCE_OFFSET = 10
BOMB_BOUNCE_Y_ACCELERATION = 50
BOMB_BOUNCES = 5

bomb_target_x_lo = entity_x_lo
bomb_target_x_hi = entity_x_hi
bomb_target_x_fine = entity_local0

bomb_target_y_lo = entity_local1
bomb_target_y_hi = entity_local2
bomb_target_y_fine = entity_local3

bomb_target_x_velocity_lo = entity_local4
bomb_target_x_velocity_hi = entity_local5

bomb_target_y_velocity_lo = entity_local6
bomb_target_y_velocity_hi = entity_local7

bomb_bounce_offset_y_lo = entity_local8
bomb_bounce_offset_y_hi = entity_local9
bomb_bounce_offset_y_fine = entity_local10

bomb_bounce_y_velocity_lo = entity_local11
bomb_bounce_y_velocity_hi = entity_local12

bomb_bounces = entity_local13

.enum
BOMB_STATE_INIT
BOMB_STATE_MAIN
.endenum

.define bomb_states \
  bomb_state_init, \
  bomb_state_main

bomb_lo:
  .lobytes bomb_states

bomb_hi:
  .hibytes bomb_states

bomb_update:

  entity_state_switchboard bomb_lo, bomb_hi

bomb_state_init:

  jsr entity_set_drawable_unsorted

  lda #<Bomb
  sta entity_animation_address_lo,x
  lda #>Bomb
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #$08
  sta entity_width,x
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_bomb
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  ;initialize bounce offset
  lda #<(-BOMB_INITIAL_BOUNCE_OFFSET)
  sta bomb_bounce_offset_y_lo,x
  lda #>(-BOMB_INITIAL_BOUNCE_OFFSET)
  sta bomb_bounce_offset_y_hi,x
  lda #0
  sta bomb_bounce_offset_y_fine,x

  ;initialize Y target based on the bounce offset (first frame will place
  ;Y coordinate at initial Y coordinate)
  clc
  lda entity_y_lo,x
  adc #BOMB_INITIAL_BOUNCE_OFFSET
  sta bomb_target_y_lo,x
  lda entity_y_hi,x
  adc #0
  sta bomb_target_y_hi,x
  lda #0
  sta bomb_target_y_fine,x

  ;initialize bounce y velocity
  lda #0
  sta bomb_bounce_y_velocity_lo,x
  sta bomb_bounce_y_velocity_hi,x

  ;initialize bounce counter
  lda #BOMB_BOUNCES
  sta bomb_bounces,x

  lda #BOMB_STATE_MAIN
  sta entity_state,x

  rts

bomb_state_main:

;  add bounce velocity to bounce offset with sign extension
  lda bomb_bounces,x
  beq no_more_bounces
  .scope
  clc
  lda bomb_bounce_offset_y_fine,x
  adc bomb_bounce_y_velocity_lo,x
  sta bomb_bounce_offset_y_fine,x

  lda bomb_bounce_offset_y_lo,x
  adc bomb_bounce_y_velocity_hi,x
  sta bomb_bounce_offset_y_lo,x

  lda bomb_bounce_y_velocity_hi,x
  bmi sign_extend_negative
sign_extend_positive:

  lda bomb_bounce_offset_y_hi,x
  adc #$00
  sta bomb_bounce_offset_y_hi,x

  jmp done
sign_extend_negative:

  lda bomb_bounce_offset_y_hi,x
  adc #$ff
  sta bomb_bounce_offset_y_hi,x
done:
  .endscope

  ;test bounce offset to see if it went positive or not, this is how we bounce
  .scope
  lda bomb_bounce_offset_y_hi,x
  bmi bounce_offset_still_negative

  ;decrement this bounce
  dec bomb_bounces,x

  ;bounce offset went positive, negate the y velocity to create the bounce
  clc
  lda bomb_bounce_y_velocity_lo,x
  eor #$ff
  adc #$01
  sta bomb_bounce_y_velocity_lo,x
  lda bomb_bounce_y_velocity_hi,x
  eor #$ff
  adc #$00
  sta bomb_bounce_y_velocity_hi,x
bounce_offset_still_negative:
  .endscope

  ;accelerate bounce velocity
  .scope
  clc
  lda bomb_bounce_y_velocity_lo,x
  adc #<BOMB_BOUNCE_Y_ACCELERATION
  sta bomb_bounce_y_velocity_lo,x

  lda bomb_bounce_y_velocity_hi,x
  adc #>BOMB_BOUNCE_Y_ACCELERATION
  sta bomb_bounce_y_velocity_hi,x
  .endscope
no_more_bounces:

  ;add bounce offset y to target y, this is the new y coordinate for this frame
  clc
  lda bomb_target_y_lo,x
  adc bomb_bounce_offset_y_lo,x
  sta entity_y_lo,x

  lda bomb_target_y_hi,x
  adc bomb_bounce_offset_y_hi,x
  sta entity_y_hi,x

  jsr entity_update_animation

  rts

.endif
