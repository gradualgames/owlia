.linecont +
.ifndef JELLYFISH_INC
JELLYFISH_INC = 1

.enum
JELLYFISH_STATE_INIT
JELLYFISH_STATE_MAIN
.endenum

jellyfish_velocity_x_lo = entity_local0
jellyfish_velocity_x_hi = entity_local1
jellyfish_velocity_y_lo = entity_local2
jellyfish_velocity_y_hi = entity_local3
jellyfish_x_fine        = entity_local4
jellyfish_y_fine        = entity_local5

.define jellyfish_states \
  jellyfish_state_init, \
  jellyfish_state_main

jellyfish_lo:
  .lobytes jellyfish_states

jellyfish_hi:
  .hibytes jellyfish_states

jellyfish_update:

  entity_state_switchboard jellyfish_lo, jellyfish_hi

jellyfish_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #16
  sta entity_width,x
  lda #16
  sta entity_height,x

  ;intiialize fine x and y coordinates and velocity
  lda #0
  sta jellyfish_x_fine,x
  sta jellyfish_y_fine,x
  sta jellyfish_velocity_x_lo,x
  sta jellyfish_velocity_x_hi,x
  sta jellyfish_velocity_y_lo,x
  sta jellyfish_velocity_y_hi,x

  lda #<JellyFishFloat
  sta entity_animation_address_lo,x
  lda #>JellyFishFloat
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #$00
  sta entity_sprite_flags,x

  lda #JELLYFISH_STATE_MAIN
  sta entity_state,x

  rts

jellyfish_state_main:

  jsr hero_is_deadly
  beq hero_not_deadly

  jsr entity_test_hero_attack_rect
  bne hero_not_deadly

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  lda #entity_index_explosion
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

hero_not_deadly:

  jsr familiar_is_deadly
  beq familiar_not_deadly

  jsr entity_test_familiar_rect
  bne familiar_not_deadly

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  lda #entity_index_explosion
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  jsr familiar_hit_enemy

familiar_not_deadly:

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  lda #$ff
  sta b0
  jsr hero_hurt

entity_not_hitting_hero:

  ;use b0 to count whether both X and Y are close enough
  lda #0
  sta b0

  .scope
  ;calculate distance between "goal" and X coordinate
  sec
  lda hero_x
  sbc entity_x_lo,x
  sta jellyfish_velocity_x_lo,x
  lda hero_x+1
  sbc entity_x_hi,x
  sta jellyfish_velocity_x_hi,x

  ;do an 16 bit arithmetic left shift on this value
  asl jellyfish_velocity_x_lo,x
  rol jellyfish_velocity_x_hi,x
  asl jellyfish_velocity_x_lo,x
  rol jellyfish_velocity_x_hi,x
  asl jellyfish_velocity_x_lo,x
  rol jellyfish_velocity_x_hi,x
  .endscope

  .scope
  ;calculate distance between "goal" and Y coordinate
  sec
  lda hero_y
  sbc entity_y_lo,x
  sta jellyfish_velocity_y_lo,x
  lda hero_y+1
  sbc entity_y_hi,x
  sta jellyfish_velocity_y_hi,x

  ;do an 16 bit arithmetic left shift on this value
  asl jellyfish_velocity_y_lo,x
  rol jellyfish_velocity_y_hi,x
  asl jellyfish_velocity_y_lo,x
  rol jellyfish_velocity_y_hi,x
  asl jellyfish_velocity_y_lo,x
  rol jellyfish_velocity_y_hi,x
  .endscope

  .scope
  lda jellyfish_velocity_x_lo,x
  sta w0
  lda jellyfish_velocity_x_hi,x
  sta w0+1
  bpl not_negative
  ;find absolute value
  lda w0
  eor #$ff
  adc #$01
  sta w0
  lda w0+1
  eor #$ff
  adc #$00
  sta w0+1
not_negative:
  .endscope

  .scope
  lda jellyfish_velocity_y_lo,x
  sta w1
  lda jellyfish_velocity_y_hi,x
  sta w1+1
  bpl not_negative
  ;find absolute value
  lda w1
  eor #$ff
  adc #$01
  sta w1
  lda w1+1
  eor #$ff
  adc #$00
  sta w1+1
not_negative:
  .endscope

  .scope
  lda w0+1
  sbc #1
  bpl do_not_move
  lda w1+1
  sbc #1
  bpl do_not_move

  ;add 16 bit velocity to 24 bit coordinate with sign extension
  .scope
  clc
  lda jellyfish_velocity_x_lo,x
  adc jellyfish_x_fine,x
  sta jellyfish_x_fine,x
  lda jellyfish_velocity_x_hi,x
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
  lda jellyfish_velocity_y_lo,x
  adc jellyfish_y_fine,x
  sta jellyfish_y_fine,x
  lda jellyfish_velocity_y_hi,x
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

do_not_move:
  .endscope

  jsr entity_update_animation

  rts

.endif
