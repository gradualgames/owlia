.linecont +
.ifndef BOMB_INC
BOMB_INC = 1

BOMB_INITIAL_BOUNCE_OFFSET = 10
BOMB_BOUNCE_Y_ACCELERATION = 50
BOMB_BOUNCES = 5

BOMB_WIDTH = 7
BOMB_HALF_WIDTH = 4
BOMB_HEIGHT = 7
BOMB_HALF_HEIGHT = 4

;the target is just an invisible moving spot the bomb bounces above.
;it slides while the bomb bounces above it, and these two constants
;define the initial velocity for the slide. We are constraining the
;movement to only ever be horizontal or vertical, since the familiar
;will only fly out from the hero horizontally or vertically.
BOMB_TARGET_X_DEFAULT_VELOCITY = 0
BOMB_TARGET_Y_DEFAULT_VELOCITY = 200

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

  lda #BOMB_WIDTH
  sta entity_width,x
  lda #BOMB_HEIGHT
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

  ; ;initialize target X sliding velocity
  ; lda #<BOMB_TARGET_X_DEFAULT_VELOCITY
  ; sta bomb_target_x_velocity_lo,x
  ; lda #>BOMB_TARGET_X_DEFAULT_VELOCITY
  ; sta bomb_target_x_velocity_hi,x

  ; ;initialize target Y sliding velocity
  ; lda #<BOMB_TARGET_Y_DEFAULT_VELOCITY
  ; sta bomb_target_y_velocity_lo,x
  ; lda #>BOMB_TARGET_Y_DEFAULT_VELOCITY
  ; sta bomb_target_y_velocity_hi,x

  ;initialize bounce counter
  lda #BOMB_BOUNCES
  sta bomb_bounces,x

  lda #BOMB_STATE_MAIN
  sta entity_state,x

  rts

bomb_state_main:

  ;add bounce velocity to bounce offset with sign extension
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

  ;move target X and target Y based on their sliding velocities
  .scope
  clc
  lda bomb_target_x_fine,x
  adc bomb_target_x_velocity_lo,x
  sta bomb_target_x_fine,x
  lda bomb_target_x_lo,x
  adc bomb_target_x_velocity_hi,x
  sta bomb_target_x_lo,x
  lda bomb_target_x_velocity_hi,x
  bmi sign_extend_negative
sign_extend_positive:
  lda bomb_target_x_hi,x
  adc #$00
  sta bomb_target_x_hi,x
  jmp done
sign_extend_negative:
  lda bomb_target_x_hi,x
  adc #$ff
  sta bomb_target_x_hi,x
done:
  .endscope

  .scope
  clc
  lda bomb_target_y_fine,x
  adc bomb_target_y_velocity_lo,x
  sta bomb_target_y_fine,x
  lda bomb_target_y_lo,x
  adc bomb_target_y_velocity_hi,x
  sta bomb_target_y_lo,x
  lda bomb_target_y_velocity_hi,x
  bmi sign_extend_negative
sign_extend_positive:
  lda bomb_target_y_hi,x
  adc #$00
  sta bomb_target_y_hi,x
  jmp done
sign_extend_negative:
  lda bomb_target_y_hi,x
  adc #$ff
  sta bomb_target_y_hi,x
done:
  .endscope

  ;decrease sliding velocities based on sign
  .scope
  lda bomb_target_x_velocity_lo,x
  beq done
  lda bomb_target_x_velocity_hi,x
  bmi add
subtract:
  sec
  lda bomb_target_x_velocity_lo,x
  sbc #$01
  sta bomb_target_x_velocity_lo,x
  lda bomb_target_x_velocity_hi,x
  sbc #$00
  sta bomb_target_x_velocity_hi,x
  jmp done
add:
  clc
  lda bomb_target_x_velocity_lo,x
  adc #$01
  sta bomb_target_x_velocity_lo,x
  lda bomb_target_x_velocity_hi,x
  adc #$00
  sta bomb_target_x_velocity_hi,x
done:
  .endscope

  .scope
  lda bomb_target_y_velocity_lo,x
  beq done
  lda bomb_target_y_velocity_hi,x
  bmi add
subtract:
  sec
  lda bomb_target_y_velocity_lo,x
  sbc #$01
  sta bomb_target_y_velocity_lo,x
  lda bomb_target_y_velocity_hi,x
  sbc #$00
  sta bomb_target_y_velocity_hi,x
  jmp done
add:
  clc
  lda bomb_target_y_velocity_lo,x
  adc #$01
  sta bomb_target_y_velocity_lo,x
  lda bomb_target_y_velocity_hi,x
  adc #$00
  sta bomb_target_y_velocity_hi,x
done:
  .endscope

  ;test map collisions based on the target x and y sliding velocities
  .scope
  lda bomb_target_x_velocity_lo,x
  beq test_collision_vertically
test_collision_horizontally:

;returns the properties byte for the metatile inside which the input point resides
;expects w0 and w1 to contain the X and Y coordinate of the point to test.
;expects to always be called from the current entities_bank, and will always switch
;returns metatile properties byte in b0
;temporarily to map_bank before switching back to entities_bank.
;.proc map_test_collision

  .scope
  lda bomb_target_x_velocity_hi,x
  bmi moving_left
moving_right:

  clc
  lda bomb_target_x_lo,x
  adc #BOMB_WIDTH
  sta w0
  lda bomb_target_x_hi,x
  adc #$00
  sta w0+1

  clc
  lda bomb_target_y_lo,x
  adc #BOMB_HALF_HEIGHT
  sta w1
  lda bomb_target_y_hi,x
  adc #$00
  sta w1+1

  jsr map_test_collision

  .scope
  lda b0
  and #FLAG_SOLID
  beq do_not_reverse_direction

  ;negate x velocity
  clc
  lda bomb_target_x_velocity_lo,x
  eor #$ff
  adc #$01
  sta bomb_target_x_velocity_lo,x
  lda bomb_target_x_velocity_hi,x
  eor #$ff
  adc #$00
  sta bomb_target_x_velocity_hi,x

do_not_reverse_direction:
  .endscope

moving_left:

  lda bomb_target_x_lo,x
  sta w0
  lda bomb_target_x_hi,x
  sta w0+1

  clc
  lda bomb_target_y_lo,x
  adc #BOMB_HALF_HEIGHT
  sta w1
  lda bomb_target_y_hi,x
  adc #$00
  sta w1+1

  jsr map_test_collision

  .scope
  lda b0
  and #FLAG_SOLID
  beq do_not_reverse_direction

  ;negate x velocity
  clc
  lda bomb_target_x_velocity_lo,x
  eor #$ff
  adc #$01
  sta bomb_target_x_velocity_lo,x
  lda bomb_target_x_velocity_hi,x
  eor #$ff
  adc #$00
  sta bomb_target_x_velocity_hi,x

do_not_reverse_direction:
  .endscope

done:
  .endscope

  jmp done
test_collision_vertically:

  .scope
  lda entity_y_hi,x
  bmi moving_up
moving_down:

  clc
  lda bomb_target_x_lo,x
  adc #BOMB_HALF_WIDTH
  sta w0
  lda bomb_target_x_hi,x
  adc #$00
  sta w0+1

  clc
  lda bomb_target_y_lo,x
  adc #BOMB_HEIGHT
  sta w1
  lda bomb_target_y_hi,x
  adc #$00
  sta w1+1

  jsr map_test_collision

  .scope
  lda b0
  and #FLAG_SOLID
  beq do_not_reverse_direction

  ;negate y velocity
  clc
  lda bomb_target_y_velocity_lo,x
  eor #$ff
  adc #$01
  sta bomb_target_y_velocity_lo,x
  lda bomb_target_y_velocity_hi,x
  eor #$ff
  adc #$00
  sta bomb_target_y_velocity_hi,x

do_not_reverse_direction:
  .endscope

moving_up:

  clc
  lda bomb_target_x_lo,x
  adc #BOMB_HALF_WIDTH
  sta w0
  lda bomb_target_x_hi,x
  adc #0
  sta w0+1

  lda bomb_target_y_lo,x
  sta w1
  lda bomb_target_y_hi,x
  sta w1+1

  jsr map_test_collision

  .scope
  lda b0
  and #FLAG_SOLID
  beq do_not_reverse_direction

  ;negate y velocity
  clc
  lda bomb_target_y_velocity_lo,x
  eor #$ff
  adc #$01
  sta bomb_target_y_velocity_lo,x
  lda bomb_target_y_velocity_hi,x
  eor #$ff
  adc #$00
  sta bomb_target_y_velocity_hi,x

do_not_reverse_direction:
  .endscope

done:
  .endscope

done:
  .endscope

  jsr entity_update_animation

  rts

.endif
