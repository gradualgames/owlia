.linecont +
.ifndef BOMB_INC
BOMB_INC = 1

.include "bomb_constants.inc"

.define bomb_states \
  bomb_state_init_carried, \
  bomb_state_carried, \
  bomb_state_init_fall, \
  bomb_state_fall

bomb_lo:
  .lobytes bomb_states

bomb_hi:
  .hibytes bomb_states

bomb_update:

  entity_state_switchboard bomb_lo, bomb_hi

bomb_state_init_carried:

  jsr entity_clear_drawable

  jsr entity_set_not_pausable

  jsr entity_clear_shadow_spot

  lda #<bomb
  sta entity_animation_address_lo,x
  lda #>bomb
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #BOMB_WIDTH
  sta entity_width,x
  lda #BOMB_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_bomb
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #BOMB_CARRIED_X_OFFSET
  sta familiar_carried_entity_x_offset
  lda #BOMB_CARRIED_Y_OFFSET
  sta familiar_carried_entity_y_offset

  lda #BOMB_STATE_CARRIED
  sta entity_state,x

  rts

bomb_state_carried:

  jsr entity_update_animation

  rts

bomb_state_init_fall:

  jsr entity_set_drawable

  jsr entity_set_not_pausable

  jsr entity_set_shadow_spot

  lda #<bomb
  sta entity_animation_address_lo,x
  lda #>bomb
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #BOMB_WIDTH
  sta entity_width,x
  lda #BOMB_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_bomb
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  jsr bomb_set_shadow_spot

  ;initialize bounce offset
  lda #<(-BOMB_INITIAL_BOUNCE_OFFSET)
  sta bomb_bounce_offset_y_lo,x
  lda #>(-BOMB_INITIAL_BOUNCE_OFFSET)
  sta bomb_bounce_offset_y_hi,x
  lda #0
  sta bomb_bounce_offset_y_fine,x

  ;initialize bounce y velocity
  lda #0
  sta bomb_bounce_y_velocity_lo,x
  sta bomb_bounce_y_velocity_hi,x

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

  jsr eject_bomb_target

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

  ;this counts how many frames it has been since we reversed directions
  lda #0
  sta bomb_frames_since_last_direction_negation,x

  ;initialize bounce counter
  lda #BOMB_BOUNCES
  sta bomb_bounces,x

  ;initialize bomb timer
  lda #BOMB_TIMER
  sta bomb_timer,x

  lda #BOMB_STATE_FALL
  sta entity_state,x

  rts

;this is a helper routine which ejects the bomb's initial target x and y
;position so it is above a non-solid tile.
eject_bomb_target:

  ;now, assuming that the target X and Y sliding velocities have been
  ;parameterized by a parent entity (the familiar), we use them to determine
  ;in which direction to eject the target to ensure the bomb does not get stuck
  ;inside a solid tile.
  lda bomb_target_y_velocity_lo,x
  ora bomb_target_y_velocity_hi,x
  beq do_not_eject_vertically
  jsr vertical_eject
do_not_eject_vertically:
  lda bomb_target_x_velocity_lo,x
  ora bomb_target_x_velocity_hi,x
  beq do_not_eject_horizontally
  jsr horizontal_eject
do_not_eject_horizontally:

  rts

vertical_eject:

  .scope
  lda bomb_target_y_velocity_hi,x
  bmi eject_downwards
eject_upwards:

  ;test point in the middle of the bottommost row of pixels of the bomb to see if
  ;it is inside a solid tile
  clc
  lda bomb_target_x_lo,x
  adc #BOMB_HALF_WIDTH
  sta w0
  lda bomb_target_x_hi,x
  adc #0
  sta w0+1

  clc
  lda bomb_target_y_lo,x
  adc #BOMB_HEIGHT
  sta w1
  lda bomb_target_y_hi,x
  adc #$00
  sta w1+1

  ;add known positive y velocity to the point we are testing to keep bomb from getting stuck
  clc
  lda w1
  adc bomb_target_y_velocity_hi,x
  sta w1
  lda w1+1
  adc #$00
  sta w1+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  beq done

  ;the point was solid, eject the target Y upwards and try again
  sec
  lda bomb_target_y_lo,x
  and #%11110000
  sbc #$10
  sta bomb_target_y_lo,x
  lda bomb_target_y_hi,x
  sbc #$00
  sta bomb_target_y_hi,x

  jmp eject_upwards

  jmp done
eject_downwards:

  ;test point in the middle of the topmost row of pixels of the bomb to see if
  ;it is inside a solid tile
  clc
  lda bomb_target_x_lo,x
  adc #BOMB_HALF_WIDTH
  sta w0
  lda bomb_target_x_hi,x
  adc #0
  sta w0+1

  ;add known negative y velocity to point we are testing to keep bomb from getting stuck
  clc
  lda bomb_target_y_lo,x
  adc bomb_target_y_velocity_hi,x
  sta w1
  lda bomb_target_y_hi,x
  adc #$ff
  sta w1+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  beq done

  ;the point was solid, eject the target Y downwards and try again
  clc
  lda bomb_target_y_lo,x
  and #%11110000
  adc #$10
  sta bomb_target_y_lo,x
  lda bomb_target_y_hi,x
  adc #$00
  sta bomb_target_y_hi,x

  jmp eject_downwards

done:
  .endscope

  rts

horizontal_eject:

  .scope
  lda bomb_target_x_velocity_hi,x
  bmi eject_right
eject_left:

  ;test point in the middle of the rightmost column of pixels of the bomb to see if
  ;it is inside a solid tile
  clc
  lda bomb_target_x_lo,x
  adc #BOMB_WIDTH
  sta w0
  lda bomb_target_x_hi,x
  adc #$00
  sta w0+1

  ;subtract the known positive x velocity to make sure bomb can't get stuck on next frame
  sec
  lda w0
  sbc bomb_target_x_velocity_hi,x
  sta w0
  lda w0+1
  sbc #$00
  sta w0+1

  clc
  lda bomb_target_y_lo,x
  adc #BOMB_HALF_HEIGHT
  sta w1
  lda bomb_target_y_hi,x
  adc #$00
  sta w1+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  beq done

  ;the point was solid, eject the target X left and try again
  sec
  lda bomb_target_x_lo,x
  and #%11110000
  sbc #$10
  sta bomb_target_x_lo,x
  lda bomb_target_x_hi,x
  sbc #$00
  sta bomb_target_x_hi,x

  jmp eject_left

  jmp done
eject_right:

  ;test point in the middle of the leftmost column of pixels of the bomb to see if
  ;it is inside a solid tile
  lda bomb_target_x_lo,x
  sta w0
  lda bomb_target_x_hi,x
  sta w0+1

  ;add the known negative x velocity to make sure bomb can't get stuck on next frame
  clc
  lda w0
  adc bomb_target_x_velocity_hi,x
  sta w0
  lda w0+1
  adc #$ff
  sta w0+1

  clc
  lda bomb_target_y_lo,x
  adc #BOMB_HALF_HEIGHT
  sta w1
  lda bomb_target_y_hi,x
  adc #$00
  sta w1+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  beq done

  ;the point was solid, eject the target Y downwards and try again
  clc
  lda bomb_target_x_lo,x
  and #%11110000
  adc #$10
  sta bomb_target_x_lo,x
  lda bomb_target_x_hi,x
  adc #$00
  sta bomb_target_x_hi,x

  jmp eject_right

done:
  .endscope

  rts

bomb_state_fall:

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
  ora bomb_target_x_velocity_hi,x
  beq done
  lda bomb_target_x_velocity_hi,x
  bmi add
subtract:
  sec
  lda bomb_target_x_velocity_lo,x
  sbc #BOMB_SLIDING_DECELERATION
  sta bomb_target_x_velocity_lo,x
  lda bomb_target_x_velocity_hi,x
  sbc #$00
  sta bomb_target_x_velocity_hi,x
  jmp done
add:
  clc
  lda bomb_target_x_velocity_lo,x
  adc #BOMB_SLIDING_DECELERATION
  sta bomb_target_x_velocity_lo,x
  lda bomb_target_x_velocity_hi,x
  adc #$00
  sta bomb_target_x_velocity_hi,x
done:
  .endscope

  .scope
  lda bomb_target_y_velocity_lo,x
  ora bomb_target_y_velocity_hi,x
  beq done
  lda bomb_target_y_velocity_hi,x
  bmi add
subtract:
  sec
  lda bomb_target_y_velocity_lo,x
  sbc #BOMB_SLIDING_DECELERATION
  sta bomb_target_y_velocity_lo,x
  lda bomb_target_y_velocity_hi,x
  sbc #$00
  sta bomb_target_y_velocity_hi,x
  jmp done
add:
  clc
  lda bomb_target_y_velocity_lo,x
  adc #BOMB_SLIDING_DECELERATION
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

  jsr test_collision_horizontally_impl

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

  lda bomb_frames_since_last_direction_negation,x
  cmp #2
  bmi do_not_reverse_direction

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

  ;reset counter for last time we switched direction
  lda #0
  sta bomb_frames_since_last_direction_negation,x

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

  lda bomb_frames_since_last_direction_negation,x
  cmp #2
  bmi do_not_reverse_direction

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

  ;reset counter for last time we switched direction
  lda #0
  sta bomb_frames_since_last_direction_negation,x

do_not_reverse_direction:
  .endscope

done:
  .endscope

done:
  ;count how many frames since last time we reversed direction
  inc bomb_frames_since_last_direction_negation,x
  .endscope

  .scope
  dec bomb_timer,x

  ;check to see if we are on the second to last frame of the timer
  lda bomb_timer,x
  cmp #1
  bne do_not_spawn_explosion

  ;grab action rect 2 and make it attack
  lda #ENTITY_ACTION_ATTACK
  sta entity_action_rect2_action
  lda #ENTITY_ACTION_FROM_BOMB
  sta entity_action_rect2_from
  lda #ENTITY_DIRECTION_NONE
  sta entity_action_rect2_direction

  clc
  lda entity_x_lo,x
  adc #<BOMB_BLAST_X_OFFSET
  sta entity_action_rect2_x
  lda entity_x_hi,x
  adc #>BOMB_BLAST_X_OFFSET
  sta entity_action_rect2_x+1

  clc
  lda entity_y_lo,x
  adc #<BOMB_BLAST_Y_OFFSET
  sta entity_action_rect2_y
  lda entity_y_hi,x
  adc #>BOMB_BLAST_Y_OFFSET
  sta entity_action_rect2_y+1

  lda #BOMB_BLAST_WIDTH
  sta entity_action_rect2_width
  lda #BOMB_BLAST_HEIGHT
  sta entity_action_rect2_height

  ;spawn an explosion entity
  lda #entity_index_explosion
  sta b0

  sec
  lda entity_x_lo,x
  sbc #BOMB_HALF_WIDTH
  sta w0
  lda entity_x_hi,x
  sbc #0
  sta w0+1
  sec
  lda entity_y_lo,x
  sbc #BOMB_HALF_HEIGHT
  sta w1
  lda entity_y_hi,x
  sbc #0
  sta w1+1

  jsr entity_spawn

do_not_spawn_explosion:

  ;check to see if we are on last frame of timer and die
  lda bomb_timer,x
  bne do_not_die

  ;reset action rect to nop
  lda #ACTION_NOP
  sta entity_action_rect2_action
  lda #ENTITY_ACTION_FROM_NOBODY
  sta entity_action_rect2_from

  ;die
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  ;exit
  rts
do_not_die:

  .endscope

  jsr bomb_set_shadow_spot

  jsr entity_update_animation

  rts

test_collision_horizontally_impl:

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

  lda bomb_frames_since_last_direction_negation,x
  cmp #2
  bmi do_not_reverse_direction

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

  ;reset counter for last time we switched direction
  lda #0
  sta bomb_frames_since_last_direction_negation,x

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

  lda bomb_frames_since_last_direction_negation,x
  cmp #2
  bmi do_not_reverse_direction

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

  ;reset counter for last time we switched direction
  lda #0
  sta bomb_frames_since_last_direction_negation,x

do_not_reverse_direction:
  .endscope

done:
  .endscope

  rts

.proc bomb_set_shadow_spot

  lda #0
  sta entity_shadow_spot_x_lo,x
  lda #0
  sta entity_shadow_spot_x_hi,x

  sec
  lda bomb_target_y_lo,x
  sbc entity_y_lo,x
  sta entity_shadow_spot_y_lo,x
  lda bomb_target_y_hi,x
  sbc entity_y_hi,x
  sta entity_shadow_spot_y_hi,x

  clc
  lda entity_shadow_spot_y_lo,x
  adc #<2
  sta entity_shadow_spot_y_lo,x
  lda entity_shadow_spot_y_hi,x
  adc #>2
  sta entity_shadow_spot_y_hi,x

  rts

.endproc

.endif
