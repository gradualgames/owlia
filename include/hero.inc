.include "zp.inc"
.include "ram.inc"
.include "sprites_and_animations_data.inc"
.include "entity.inc"
.include "controller.inc"
.include "map.inc"

.ifndef HERO_INC
HERO_INC = 1

HERO_STATE_INIT = 0
HERO_STATE_MAIN = 1

hero_lo:
  .byte <hero_state_init
  .byte <hero_state_main

hero_hi:
  .byte >hero_state_init
  .byte >hero_state_main
  
hero_update:

  entity_state_switchboard hero_lo, hero_hi

hero_state_init:

  lda #HERO_STATE_MAIN
  sta entity_state,x

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x
  
  lda #50
  sta entity_x_lo,x
  lda #0
  sta entity_x_hi,x
  lda #50
  sta entity_y_lo,x
  lda #0
  sta entity_y_hi,x
  
  lda #0
  sta entity_animation_frame,x
  lda #1
  sta entity_animation_counter,x
  
  lda #0
  sta entity_sprite_group_offset,x
  sta entity_sprite_flags,x
  
  lda #<WalkSide
  sta entity_animation_address_lo,x
  lda #>WalkSide
  sta entity_animation_address_hi,x
  
  rts

hero_state_main:

  lda buffer_controller+buttons::_left
  and #%00000011
  cmp #%00000011
  bne skip_left
  
  lda entity_x_lo,x
  ora entity_x_hi,x
  beq skip_left
  
  sec
  lda entity_x_lo,x
  sbc #$02
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #$00
  sta entity_x_hi,x
  
  lda #%01000000
  sta entity_sprite_flags,x
  
  lda #<WalkSide
  sta entity_animation_address_lo,x
  lda #>WalkSide
  sta entity_animation_address_hi,x

skip_left:

  lda buffer_controller+buttons::_right
  and #%00000011
  cmp #%00000011
  bne skip_right
  
  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1
  
  jsr map_test_collision
  
  lda b0
  and #FLAG_SOLID
  bne skip_right
  
  clc
  lda entity_x_lo,x
  adc #$02
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #$00
  sta entity_x_hi,x
  
  lda #%00000000
  sta entity_sprite_flags,x
  
  lda #<WalkSide
  sta entity_animation_address_lo,x
  lda #>WalkSide
  sta entity_animation_address_hi,x

skip_right:

  lda buffer_controller+buttons::_up
  and #%00000011
  cmp #%00000011
  bne skip_up
  
  lda entity_y_lo,x
  ora entity_y_hi,x
  beq skip_up
  
  sec
  lda entity_y_lo,x
  sbc #$02
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #$00
  sta entity_y_hi,x
  
  lda #<WalkUp
  sta entity_animation_address_lo,x
  lda #>WalkUp
  sta entity_animation_address_hi,x

skip_up:

  lda buffer_controller+buttons::_down
  and #%00000011
  cmp #%00000011
  bne skip_down
  
  clc
  lda entity_y_lo,x
  adc #$02
  sta entity_y_lo,x
  lda entity_y_hi,x
  adc #$00
  sta entity_y_hi,x
  
  lda #<WalkDown
  sta entity_animation_address_lo,x
  lda #>WalkDown
  sta entity_animation_address_hi,x

skip_down:

  lda entity_animation_address_lo,x
  sta w2
  lda entity_animation_address_hi,x
  sta w2+1
  jsr entity_update_animation

  rts

.endif
