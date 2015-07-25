.linecont +
.ifndef MERMON_TORSO_INC
MERMON_TORSO_INC = 1

.include "projectile_constants.inc"

MERMON_TAIL_X_OFFSET = 0
MERMON_TAIL_Y_OFFSET = 16

MERMON_HORIZONTAL_MID_POINT = 172
MERMON_VERTICAL_MID_POINT = 40

MERMON_HORIZONTAL_ACCELERATION = 15
MERMON_VERTICAL_ACCELERATION = 15

MERMON_LEFT_PROJECTILE_X_OFFSET = 20
MERMON_LEFT_PROJECTILE_Y_OFFSET = 16

MERMON_RIGHT_PROJECTILE_X_OFFSET = 4
MERMON_RIGHT_PROJECTILE_Y_OFFSET = 16

MERMON_PROJECTILE_FREQUENCY = 12

MERMON_TORSO_WIDTH = $0f
MERMON_TORSO_HEIGHT = $0f

MERMON_TORSO_STATE_MAIN_LENGTH = 200
MERMON_TORSO_STATE_FLING_LENGTH = 60

mermon_x_lo = entity_x_lo
mermon_x_hi = entity_x_hi
mermon_y_lo = entity_y_lo
mermon_y_hi = entity_y_hi

define_entity_properties mermon_tail_index,\
                         mermon_x_fine,\
                         mermon_y_fine,\
                         mermon_x_velocity_lo,\
                         mermon_x_velocity_hi,\
                         mermon_y_velocity_lo,\
                         mermon_y_velocity_hi, \
                         mermon_state_counter, \
                         mermon_projectile_state_counter, \
                         mermon_projectile_direction_counter

.enum
MERMON_TORSO_STATE_INIT
MERMON_TORSO_STATE_MAIN
MERMON_TORSO_STATE_FLING
.endenum

define_lohi_tables mermon_torso, \
 {mermon_torso_state_init, \
  mermon_torso_state_main, \
  mermon_torso_state_fling}

mermon_torso_update:

  entity_state_switchboard mermon_torso_lo, mermon_torso_hi

mermon_torso_state_init:

  jsr entity_set_drawable

  jsr entity_set_shadow_spot

  entity_lda16 entity_shadow_spot_x, 12
  entity_lda16 entity_shadow_spot_y, 64

  lda #<mermon_torso_fly
  sta entity_animation_address_lo,x
  lda #>mermon_torso_fly
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_TORSO_WIDTH
  sta entity_width,x
  lda #MERMON_TORSO_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_mermon
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #%01000000
  sta entity_sprite_flags,x

  ;find the tail entity
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_type,y
  cmp #entity_index_mermon_tail
  beq done

  dey
  bpl next_entity
done:
  tya
  sta mermon_tail_index,x
  .endscope

  lda #0
  sta mermon_x_fine,x
  sta mermon_y_fine,x

  entity_lda16 mermon_x_velocity, 0
  entity_lda16 mermon_y_velocity, 0

  jsr mermon_position_tail

  lda #MERMON_TORSO_STATE_MAIN_LENGTH
  sta mermon_state_counter,x

  lda #MERMON_TORSO_STATE_MAIN
  sta entity_state,x

  rts

mermon_torso_state_main:

  entity_add_velocity mermon_x, mermon_x_velocity
  entity_add_velocity mermon_y, mermon_y_velocity

  .scope
  sec
  lda mermon_x_lo,x
  sbc #<MERMON_HORIZONTAL_MID_POINT
  lda mermon_x_hi,x
  sbc #>MERMON_HORIZONTAL_MID_POINT
  bmi accelerate_right
accelerate_left:

  entity_add_acceleration mermon_x_velocity, -MERMON_HORIZONTAL_ACCELERATION

  jmp done
accelerate_right:

  entity_add_acceleration mermon_x_velocity, MERMON_HORIZONTAL_ACCELERATION

done:
  .endscope

  .scope
  sec
  lda mermon_y_lo,x
  sbc #<MERMON_VERTICAL_MID_POINT
  lda mermon_y_hi,x
  sbc #>MERMON_VERTICAL_MID_POINT
  bmi accelerate_up
accelerate_down:

  entity_add_acceleration mermon_y_velocity, -MERMON_VERTICAL_ACCELERATION

  jmp done
accelerate_up:

  entity_add_acceleration mermon_y_velocity, MERMON_VERTICAL_ACCELERATION

done:
  .endscope

  .scope
  lda mermon_x_velocity_hi,x
  bmi left
right:

  lda #%01000000
  sta entity_sprite_flags,x

  jmp done
left:

  lda #%00000000
  sta entity_sprite_flags,x

done:
  .endscope

  jsr mermon_position_tail

  jsr entity_update_animation

  .scope
  dec mermon_state_counter,x
  bne do_not_transition_yet

  lda #2
  sta mermon_projectile_direction_counter,x

  lda #<mermon_torso_toss
  sta entity_animation_address_lo,x
  lda #>mermon_torso_toss
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_PROJECTILE_FREQUENCY
  sta mermon_projectile_state_counter,x

  lda #MERMON_TORSO_STATE_FLING_LENGTH
  sta mermon_state_counter,x

  lda #MERMON_TORSO_STATE_FLING
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

mermon_torso_state_fling:

  .scope
  dec mermon_projectile_state_counter,x
  bne do_not_fire_projectile

  lda #MERMON_PROJECTILE_FREQUENCY
  sta mermon_projectile_state_counter,x

  lda #entity_index_projectile
  sta b0

  entity_to_zp16 entity_x, w0
  entity_to_zp16 entity_y, w1

  .scope
  lda mermon_x_velocity_hi,x
  bmi left
right:
  zp16_add_im8 w0, MERMON_RIGHT_PROJECTILE_X_OFFSET
  zp16_add_im8 w1, MERMON_RIGHT_PROJECTILE_Y_OFFSET
  jmp done
left:
  zp16_add_im8 w0, MERMON_LEFT_PROJECTILE_X_OFFSET
  zp16_add_im8 w1, MERMON_LEFT_PROJECTILE_Y_OFFSET
done:
  .endscope

  jsr entity_spawn

  ldy spawned_entity
  lda mermon_projectile_direction_counter,x
  sta projectile_direction,y

  lda #PROJECTILE_MODE_FAST
  sta projectile_mode,y

  inc mermon_projectile_direction_counter,x
do_not_fire_projectile:
  .endscope

  jsr entity_update_animation

  .scope
  dec mermon_state_counter,x
  bne do_not_transition_yet

  lda #<mermon_torso_fly
  sta entity_animation_address_lo,x
  lda #>mermon_torso_fly
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_TORSO_STATE_MAIN_LENGTH
  sta mermon_state_counter,x

  lda #MERMON_TORSO_STATE_MAIN
  sta entity_state,x

do_not_transition_yet:
  .endscope

  rts

.proc mermon_position_tail

  ldy mermon_tail_index,x

  clc
  lda entity_x_lo,x
  adc #<MERMON_TAIL_X_OFFSET
  sta entity_x_lo,y
  lda entity_x_hi,x
  adc #>MERMON_TAIL_X_OFFSET
  sta entity_x_hi,y

  clc
  lda entity_y_lo,x
  adc #<MERMON_TAIL_Y_OFFSET
  sta entity_y_lo,y
  lda entity_y_hi,x
  adc #>MERMON_TAIL_Y_OFFSET
  sta entity_y_hi,y

  lda entity_sprite_flags,x
  sta entity_sprite_flags,y

  rts

.endproc

.endif
