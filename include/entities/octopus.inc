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

define_entity_properties octopus_velocity_x_lo,\
                         octopus_velocity_x_hi,\
                         octopus_velocity_y_lo,\
                         octopus_velocity_y_hi,\
                         octopus_x_fine,\
                         octopus_y_fine,\
                         octopus_range_rect_x_lo,\
                         octopus_range_rect_x_hi,\
                         octopus_range_rect_y_lo,\
                         octopus_range_rect_y_hi,\
                         octopus_initial_x_lo,\
                         octopus_initial_x_hi,\
                         octopus_initial_y_lo,\
                         octopus_initial_y_hi,\
                         octopus_direction,\
                         octopus_health,\
                         octopus_knockback_counter,\
                         octopus_flash_counter

define_lohi_tables octopus,\
                   {octopus_state_init,\
                   octopus_state_main}

octopus_update:

  entity_state_switchboard octopus_lo, octopus_hi

octopus_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  jsr entity_set_shadow_spot

  lda #23
  sta entity_width,x
  lda #23
  sta entity_height,x

  lda #sprite_chr_group_index_octopus
  sta b0
  jsr entity_lookup_sprite_chr_offset

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

  jsr octopus_set_shadow_spot

  lda #<octopus_fly
  sta entity_animation_address_lo,x
  lda #>octopus_fly
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #$00
  sta entity_sprite_flags,x

  lda #OCTOPUS_INITIAL_HEALTH
  sta octopus_health,x

  lda #0
  sta octopus_flash_counter,x
  sta octopus_knockback_counter,x

  lda #OCTOPUS_STATE_MAIN
  sta entity_state,x

  rts

octopus_state_main:

  entity_combat #OCTOPUS_ATTACKED_LENGTH, #OCTOPUS_KNOCKBACK_LENGTH, octopus_flash_counter, octopus_knockback_counter, octopus_health, octopus_direction, "entity_drop_random_item", "entity_spawn_explosion"

  ;determine whether hero is within range rect
  .scope
  lda octopus_knockback_counter,x
  bne use_initial_location
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

  jsr octopus_move

  jsr entity_update_animation

  rts

.proc octopus_set_shadow_spot

  lda #$08
  sta entity_shadow_spot_x_lo,x
  lda #$00
  sta entity_shadow_spot_x_hi,x

  lda #$18
  sta entity_shadow_spot_y_lo,x
  lda #$00
  sta entity_shadow_spot_y_hi,x

  rts

.endproc

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

  jsr geotests_rect_in_rect_size

  rts

.endproc

.proc octopus_move

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
