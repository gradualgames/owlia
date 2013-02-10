.linecont +
.include "hero.inc"
.include "hero_constants.inc"
.include "entity.inc"
.include "sprite_chr_data.inc"
.include "familiar.inc"
.include "ram.inc"
.include "zp.inc"
.include "play_state.inc"
.include "controller.inc"
.include "actions.inc"
.include "map.inc"
.include "sprites_and_animations_data.inc"
.include "soundengine.inc"
.include "sfx_data.inc"
.include "sprite.inc"
.include "geotests.inc"
.include "camera.inc"
.include "textbox.inc"

.segment "CODE"

.proc hero_init

  lda #HERO_STATE_INIT
  sta hero_state

  rts

.endproc

.proc hero_face_in_current_direction

  lda hero_direction
  tay
  lda main_animation_addresses_lo,y
  sta hero_animation_address
  sta w2
  lda main_animation_addresses_hi,y
  sta hero_animation_address+1
  sta w2+1
  lda sprite_flags_direction,y
  sta hero_sprite_flags

  rts

.endproc

.proc hero_prepare_familiar_carry_hero
tile_x = w7
tile_y = w8

  ;check to see if the metatile the hero is currently standing on contains ACTION_CARRY_TO
  clc
  lda hero_x
  sta tile_x
  sta w0
  lda hero_x+1
  sta tile_x+1
  sta w0+1

  clc
  lda hero_y
  adc #(HERO_HEIGHT-2)
  sta tile_y
  sta w1
  lda hero_y+1
  adc #0
  sta tile_y+1
  sta w1+1

  jsr map_test_collision

  ;find out if this action is indeed ACTION_CARRY_TO
  .scope
  ;get action
  lda b0
  and #ISOLATE_ACTION_MASK
  cmp #ACTION_CARRY_TO
  bne skip_carry_to

  jsr compute_destination_coordinates

  lda #HERO_STATE_CARRIED
  sta hero_state

skip_carry_to:
  .endscope

  rts

compute_destination_coordinates:
  ;now extract two signed, 4 bit offsets from the param, sign extend them
  ;to 16 bits wide, and pass these values into parameters for the familiar
  ;to interpret as the destination to which to carry the hero, in metatile
  ;units.

  ;get signed 4 bit x offset from param. This is in the hi nybble.
  lda b1
  and #$f0
  lsr
  lsr
  lsr
  lsr
  sta familiar_param_w0

  ;sign extend to all 12 higher bits by testing bit 3 (the x offset sign)
  .scope
  and #%00001000
  beq positive
negative:
  lda familiar_param_w0
  ora #$f0
  sta familiar_param_w0
  lda #$ff
  sta familiar_param_w0+1
  jmp done
positive:
  lda #$00
  sta familiar_param_w0+1
done:
  .endscope

  ;get signed 4 bit y offset from param. This is in the lo nybble.
  lda b1
  and #$0f
  sta familiar_param_w1

  ;sign extend to all 12 higher bits by testing bit 3 (the y offset sign)
  .scope
  and #%00001000
  beq positive
negative:
  lda familiar_param_w1
  ora #$f0
  sta familiar_param_w1
  lda #$ff
  sta familiar_param_w1+1
  jmp done
positive:
  lda #$00
  sta familiar_param_w1+1
done:
  .endscope

  ;now the familiar params contain sign extended offsets extracted from the param.
  ;arithmetically shift left both values by 4 to multiply by 16, the size of a
  ;meta tile. After this, they will be true offsets in 16 bit map coordinates to
  ;add to the hero's current position.

  lda familiar_param_w0+1
  asl familiar_param_w0
  rol
  asl familiar_param_w0
  rol
  asl familiar_param_w0
  rol
  asl familiar_param_w0
  rol
  sta familiar_param_w0+1

  lda familiar_param_w1+1
  asl familiar_param_w1
  rol
  asl familiar_param_w1
  rol
  asl familiar_param_w1
  rol
  asl familiar_param_w1
  rol
  sta familiar_param_w1+1

  ;before computing destination coordinates, infer direction that
  ;the hero and the familiar ought to point based on the signs of
  ;the x and y offsets.
  .scope
  ;if x offset is zero, assume this is a vertical offset
  lda familiar_param_w0
  ora familiar_param_w0+1
  beq infer_from_y_offset
infer_from_x_offset:

  .scope
  lda familiar_param_w0+1
  bmi left
right:
  lda #HERO_DIRECTION_RIGHT
  sta hero_direction
  jmp done
left:
  lda #HERO_DIRECTION_LEFT
  sta hero_direction
done:
  .endscope

  jmp done
infer_from_y_offset:

  .scope
  lda familiar_param_w1+1
  bmi up
down:
  lda #HERO_DIRECTION_DOWN
  sta hero_direction
  jmp done
up:
  lda #HERO_DIRECTION_UP
  sta hero_direction
done:
  .endscope

done:
  .endscope

  ;Now compute destination coordinates for carrying the hero
  ;by adding the original tile location we found earlier to
  ;the two offset params we just computed.
  clc
  lda familiar_param_w0
  adc tile_x
  sta familiar_param_w0
  lda familiar_param_w0+1
  adc tile_x+1
  sta familiar_param_w0+1

  clc
  lda familiar_param_w1
  adc tile_y
  sta familiar_param_w1
  lda familiar_param_w1+1
  adc tile_y+1
  sta familiar_param_w1+1

  rts

.endproc

.proc hero_set_has_key

  lda hero_flags
  ora #HERO_FLAGS_HAS_KEY_SET
  sta hero_flags
  rts

.endproc

.proc hero_clear_has_key

  lda hero_flags
  and #HERO_FLAGS_HAS_KEY_CLEAR
  sta hero_flags
  rts

.endproc

;sets up the hero's state to start flashing invincibility frames and
;get knocked back in a certain direction for a few frames.
;expects b0 to contain cardinal direction to knock the hero back in.
;it is expected to be one of the four HERO_DIRECTION enum values. A
;negative value means to knock the hero in the opposite direction that
;she is facing.
.proc hero_hurt
hero_knockback_direction = b0

  ; -if hero_invincibility_counter is 0
  lda hero_invincibility_counter
  bne hero_invincible
  ; -if cardinal direction param is none,
  lda hero_knockback_direction
  bpl skip_lookup_opposite_direction
    ; -look up opposite direction for hero_direction.
  ldy hero_direction
  lda hero_opposite_direction,y
  tay
skip_lookup_opposite_direction:
  ; -look up direction handlers index from hero_knockback_direction
  lda hero_direction_to_direction_handlers_index,y
  ; -store this in hero_knockback_direction
  sta hero_knockback_direction_handler
  ; -set hero_knockback_counter
  lda #HERO_KNOCKBACK_LENGTH
  sta hero_knockback_counter
  ; -set hero_invincibility_counter
  lda #HERO_INVINCIBILITY_LENGTH
  sta hero_invincibility_counter
  ; -set hero speed while hurt
  lda #HERO_KNOCKBACK_SPEED
  sta hero_speed

  ;play a sound
  txa
  pha

  lda #<sfx_test
  sta sound_param_word_0
  lda #>sfx_test
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

hero_invincible:

  rts

.endproc

;sets up the attack state to begin executing on
;the next frame. By default, this is what is called
;when the a button is pressed. Entities can override
;this behavior by calling another state setup routine
;to cancel the attack.
.proc hero_attack

  lda hero_flags
  ora #HERO_FLAGS_DEADLY_SET
  sta hero_flags

  lda #HERO_STATE_ATTACK
  sta hero_state

  lda #HERO_STATE_ATTACK_LENGTH
  sta hero_state_counter

  lda hero_direction
  tay
  lda attack_animation_addresses_lo,y
  sta hero_animation_address
  sta w2
  lda attack_animation_addresses_hi,y
  sta hero_animation_address+1
  sta w2+1

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1

  jsr sprite_reset_animation

  ;play a sound
  txa
  pha

  lda #<sfx_sword
  sta sound_param_word_0
  lda #>sfx_sword
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  rts

.endproc

;used by the familiar when setting down the hero after carrying her.
.proc hero_set_down

  lda hero_flags
  and #HERO_FLAGS_DEADLY_CLEAR
  sta hero_flags

  lda #HERO_STATE_MAIN
  sta hero_state

  rts

.endproc

;used by NPCs to cancel the default behavior from hitting the
;a button which is to attack. This restores the state to a normal
;walking state, and also stops the sound effect that was loaded
;by the attack routine from playing.
.proc hero_cancel_attack

  ;get the direction we're facing and look up the animation address
  lda hero_direction
  tay
  lda main_animation_addresses_lo,y
  sta hero_animation_address
  sta w2
  lda main_animation_addresses_hi,y
  sta hero_animation_address+1
  sta w2+1

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1

  jsr sprite_reset_animation

  lda hero_flags
  and #HERO_FLAGS_DEADLY_CLEAR
  sta hero_flags

  lda #HERO_STATE_MAIN
  sta hero_state

  ;cancel the attack sound
  txa
  pha

  ldx #soundeffect_one
  jsr stream_stop

  pla
  tax

  rts

.endproc

.proc align_hero_if_occluded_by_textbox

  ;transfer hero rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda hero_screen_x
  sta w2
  lda hero_screen_x+1
  sta w2+1
  lda hero_screen_y
  sta w3
  lda hero_screen_y+1
  sta w3+1
  lda hero_width
  sta b2
  lda hero_height
  sta b3

  ;transfer textbox rectangle to w4 = left and w5 = top and b4 = width and b5 = height
  lda #TEXTBOX_SCREEN_X
  sta w4
  lda #0
  sta w4+1
  lda #TEXTBOX_SCREEN_Y
  sta w5
  lda #0
  sta w5+1
  lda #TEXTBOX_WIDTH
  sta b4
  lda #TEXTBOX_HEIGHT
  sta b5

  jsr geotests_rect_in_rect_16bit
  bne does_not_intersect_textbox

  lda hero_screen_y
  and #%00000100
  bne round_up
round_down:
  lda hero_screen_y
  and #%11111000
  sec
  sbc #$01
  sta hero_screen_y
  jmp done
round_up:
  lda hero_screen_y
  and #%11111000
  clc
  adc #$07
  sta hero_screen_y
done:

does_not_intersect_textbox:
  rts

.endproc

.proc hero_calculate_screen_coordinates

  sec
  lda hero_x
  sbc camera_x
  sta hero_screen_x
  lda hero_x+1
  sbc camera_x+1
  sta hero_screen_x+1

  sec
  lda hero_y
  sbc camera_y
  sta hero_screen_y
  lda hero_y+1
  sbc camera_y+1
  sta hero_screen_y+1

  ;add camera screen origin to the screen coordinates. This is needed
  ;because the camera screen origin is not at 0,0, it is at 0,8.
  clc
  lda hero_screen_y
  adc #CAMERA_SCREEN_ORIGIN_Y
  sta hero_screen_y
  lda hero_screen_y+1
  adc #$00
  sta hero_screen_y+1

  rts

.endproc

.proc hero_draw

  lda hero_flags
  and #HERO_FLAGS_DRAWABLE_TEST
  beq do_not_draw

  ;get screen coordinates
  lda hero_screen_x
  sta w3
  lda hero_screen_x+1
  sta w3+1

  lda hero_screen_y
  sta w4
  lda hero_screen_y+1
  sta w4+1

  lda hero_sprite_group_offset
  sta sprite_group_offset

  lda hero_sprite_flags
  sta b2

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1
  lda hero_animation_address
  sta w2
  lda hero_animation_address+1
  sta w2+1

  jsr sprite_draw_animation
do_not_draw:

  rts

.endproc

;clears zero flag if hero is moving, set it if not
.proc hero_is_moving

  lda hero_flags
  and #HERO_FLAGS_MOVING_TEST

  rts

.endproc

;clears zero flag if hero is deadly, set it if not.
.proc hero_is_deadly

  lda hero_flags
  and #HERO_FLAGS_DEADLY_TEST

  rts

.endproc

.macro test_collision x_offset_lo, x_offset_hi, y_offset_lo, y_offset_hi, destination_if_solid

  clc
  lda hero_x
  adc #x_offset_lo
  sta w0
  lda hero_x+1
  adc #x_offset_hi
  sta w0+1

  clc
  lda hero_y
  adc #y_offset_lo
  sta w1
  lda hero_y+1
  adc #y_offset_hi
  sta w1+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  bne destination_if_solid

.endmacro

.macro test_not_collision x_offset_lo, x_offset_hi, y_offset_lo, y_offset_hi, destination_if_not_solid

  clc
  lda hero_x
  adc #x_offset_lo
  sta w0
  lda hero_x+1
  adc #x_offset_hi
  sta w0+1

  clc
  lda hero_y
  adc #y_offset_lo
  sta w1
  lda hero_y+1
  adc #y_offset_hi
  sta w1+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  beq destination_if_not_solid

.endmacro

.macro test_action x_offset_lo, x_offset_hi, y_offset_lo, y_offset_hi

  clc
  lda hero_x
  adc #x_offset_lo
  sta w0
  lda hero_x+1
  adc #x_offset_hi
  sta w0+1

  clc
  lda hero_y
  adc #y_offset_lo
  sta w1
  lda hero_y+1
  adc #y_offset_hi
  sta w1+1

  jsr map_test_collision

  .scope
  lda b0
  and #ISOLATE_ACTION_MASK
  cmp #ACTION_GOTO_LOCATION_GROUP1
  bne skip_goto_location
  lda #ACTION_GOTO_LOCATION_GROUP1
  sta state_control_params+play_state_control::action
  lda b1
  sta state_control_params+play_state_control::param
skip_goto_location:
  .endscope

.endmacro

.define direction_handlers \
  hero_direction_nop_handler,\
  hero_direction_right_handler,\
  hero_direction_left_handler,\
  hero_direction_nop_handler,\
  hero_direction_down_handler,\
  hero_direction_down_and_right_handler,\
  hero_direction_down_and_left_handler,\
  hero_direction_nop_handler,\
  hero_direction_up_handler,\
  hero_direction_up_and_right_handler,\
  hero_direction_up_and_left_handler,\
  hero_direction_nop_handler,\
  hero_direction_nop_handler,\
  hero_direction_nop_handler,\
  hero_direction_nop_handler,\
  hero_direction_nop_handler

direction_handlers_lo:
  .lobytes direction_handlers

direction_handlers_hi:
  .hibytes direction_handlers

hero_direction_to_direction_handlers_index:
  .byte 1, 2, 4, 8

.define main_animation_addresses\
  WalkSide,\
  WalkSide,\
  WalkDown,\
  WalkUp

main_animation_addresses_lo:
  .lobytes main_animation_addresses

main_animation_addresses_hi:
  .hibytes main_animation_addresses

.define attack_animation_addresses\
  FightSide,\
  FightSide,\
  FightDown,\
  FightUp

attack_animation_addresses_lo:
  .lobytes attack_animation_addresses

attack_animation_addresses_hi:
  .hibytes attack_animation_addresses

.define hero_states \
    hero_state_init, \
    hero_state_main, \
    hero_state_attack, \
    hero_state_carried

hero_lo:
  .lobytes hero_states

hero_hi:
  .hibytes hero_states

hero_opposite_direction:
  .byte HERO_DIRECTION_LEFT
  .byte HERO_DIRECTION_RIGHT
  .byte HERO_DIRECTION_UP
  .byte HERO_DIRECTION_DOWN

sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000

attack_rect_offset_x_lo:
  .byte 16, -16, 0, 0

attack_rect_offset_x_hi:
  .byte 0, $ff, 0, 0

attack_rect_offset_y_lo:
  .byte 4, 4, 24, -16

attack_rect_offset_y_hi:
  .byte 0, 0, 0, $ff

.segment "ROM02"

hero_update:

  lda hero_state
  tay
  lda hero_lo,y
  sta w0
  lda hero_hi,y
  sta w0+1
  jmp (w0)

hero_state_init:

  lda #HERO_STATE_MAIN
  sta hero_state

  lda #HERO_FLAGS_DRAWABLE_SET
  sta hero_flags
  lda #0
  sta hero_attack_rect_x
  sta hero_attack_rect_x+1
  sta hero_attack_rect_y
  sta hero_attack_rect_y+1
  sta hero_attack_rect_width
  sta hero_attack_rect_height

  lda #HERO_WIDTH
  sta hero_width
  lda #HERO_HEIGHT
  sta hero_height

  lda #HERO_SPEED
  sta hero_speed

  ldy hero_direction
  lda main_animation_addresses_lo,y
  sta hero_animation_address
  sta w2
  lda main_animation_addresses_hi,y
  sta hero_animation_address+1
  sta w2+1

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1
  jsr sprite_reset_animation

  ldy hero_direction
  lda sprite_flags_direction,y
  sta hero_sprite_flags

  lda #sprite_chr_group_index_hero
  tay
  lda sprite_chr_group_offsets,y
  sta hero_sprite_group_offset

  lda #0
  sta hero_invincibility_counter
  sta hero_knockback_counter

  rts

hero_state_carried:

  rts

hero_state_main:

  lda buffer_controller+buttons::_b
  and #%00000011
  cmp #%00000001
  bne skip_spawn_familiar_test

  jsr hero_prepare_familiar_carry_hero
  lda hero_state
  cmp #HERO_STATE_CARRIED
  bne skip_spawn_familiar_test
  jsr familiar_spawn_carry_hero

skip_spawn_familiar_test:

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne skip_attack_test

  jsr hero_attack

  rts

skip_attack_test:

  ;check to see if hero is hurt. if not, use controller to choose
  ;direction handler. if so, use hero_knockback_direction_handler to choose
  ;the direction handler.
  lda hero_knockback_counter
  beq hero_not_knockback

  lda #HERO_KNOCKBACK_SPEED
  sta hero_speed

  ldy hero_knockback_direction_handler
  lda direction_handlers_lo,y
  sta w0
  lda direction_handlers_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  ;get the opposite direction we're being knocked in and look up the animation for it
  lda hero_direction
  tay
  lda hero_opposite_direction,y
  tay
  lda main_animation_addresses_lo,y
  sta hero_animation_address
  lda main_animation_addresses_hi,y
  sta hero_animation_address+1

  ;decrement the knockback counter
  dec hero_knockback_counter

  ;on zero, flip the direction the hero is facing permanently
  bne hero_knockback_counter_not_zero

  lda hero_direction
  tay
  lda hero_opposite_direction,y
  sta hero_direction
  tay
  lda main_animation_addresses_lo,y
  sta hero_animation_address
  lda main_animation_addresses_hi,y
  sta hero_animation_address+1

hero_knockback_counter_not_zero:

  jmp skip_choose_direction_handler_from_controller

hero_not_knockback:

  ;get up, down, left, right into a single bit field
  lda #0
  sta b0
  lda buffer_controller+buttons::_up
  ror
  rol b0
  lda buffer_controller+buttons::_down
  ror
  rol b0
  lda buffer_controller+buttons::_left
  ror
  rol b0
  lda buffer_controller+buttons::_right
  ror
  rol b0

  lda #HERO_SPEED
  sta hero_speed

  ;use this as an index into a direction handlers lut
  ldy b0
  lda direction_handlers_lo,y
  sta w0
  lda direction_handlers_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  ;get the direction we're facing and look up the animation address
  lda hero_direction
  tay
  lda main_animation_addresses_lo,y
  sta hero_animation_address
  lda main_animation_addresses_hi,y
  sta hero_animation_address+1

skip_choose_direction_handler_from_controller:

  ;advance the current invincibility frames state if the counter is nonzero
  .scope
  lda hero_invincibility_counter
  beq hero_not_invincible

  dec hero_invincibility_counter

  lda hero_invincibility_counter
  and #%00000001
  beq do_not_flip_drawable_bit

  lda hero_flags
  eor #HERO_FLAGS_DRAWABLE_SET
  sta hero_flags

do_not_flip_drawable_bit:
hero_not_invincible:
  .endscope

  lda sprite_flags_direction,y
  sta hero_sprite_flags

  lda hero_flags
  and #HERO_FLAGS_MOVING_TEST
  beq do_not_animate_hero
  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1
  lda hero_animation_address
  sta w2
  lda hero_animation_address+1
  sta w2+1
  jsr sprite_update_animation
do_not_animate_hero:

  rts

hero_state_attack:

  ;advance the current invincibility frames state if the counter is nonzero
  .scope
  lda hero_invincibility_counter
  beq hero_not_invincible

  dec hero_invincibility_counter

  lda hero_invincibility_counter
  and #%00000001
  beq do_not_flip_drawable_bit

  lda hero_flags
  eor #HERO_FLAGS_DRAWABLE_SET
  sta hero_flags

do_not_flip_drawable_bit:
hero_not_invincible:
  .endscope

  ;compute top left of attack rect based on direction
  ldy hero_direction
  clc
  lda attack_rect_offset_x_lo,y
  adc hero_x
  sta hero_attack_rect_x
  lda attack_rect_offset_x_hi,y
  adc hero_x+1
  sta hero_attack_rect_x+1

  clc
  lda attack_rect_offset_y_lo,y
  adc hero_y
  sta hero_attack_rect_y
  lda attack_rect_offset_y_hi,y
  adc hero_y+1
  sta hero_attack_rect_y+1

  lda #16
  sta hero_attack_rect_width
  sta hero_attack_rect_height

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1

  lda hero_animation_address
  sta w2
  lda hero_animation_address+1
  sta w2+1
  jsr sprite_update_animation

  dec hero_state_counter
  bne attack_not_done

  ;get the direction we're facing and look up the animation address
  lda hero_direction
  tay
  lda main_animation_addresses_lo,y
  sta hero_animation_address
  lda main_animation_addresses_hi,y
  sta hero_animation_address+1

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1

  jsr sprite_reset_animation

  lda hero_flags
  and #HERO_FLAGS_DEADLY_CLEAR
  sta hero_flags

  lda #HERO_STATE_MAIN
  sta hero_state

attack_not_done:

  rts

indirect_jsr_w0:
  jmp (w0)

hero_direction_nop_handler:

  lda hero_flags
  and #HERO_FLAGS_MOVING_CLEAR
  sta hero_flags

  rts

hero_direction_right_handler:

  .scope
  test_action HERO_WIDTH, 0, (HERO_HEIGHT/2), 0

  ;collect collision information in a local variable
  ;we use b2 because the below code calls map_test_collision which uses
  ;b0 and b1.
  collision_flags = b2
  lda #0
  sta collision_flags

  ;test top right of the hero
  test_not_collision HERO_WIDTH, 0, (HERO_HEIGHT/2), 0, no_top_right_collision

  ;set the 0th bit of the collision flags variable
  lda collision_flags
  ora #%00000001
  sta collision_flags

no_top_right_collision:

  ;test bottom right of the hero
  test_not_collision HERO_WIDTH, 0, HERO_HEIGHT-1, 0, no_bottom_right_collision

  ;set the 1st bit of the collision flags variable
  lda collision_flags
  ora #%00000010
  sta collision_flags

no_bottom_right_collision:

  ;now we can easily choose which branch to execute (actually move right,
  ;slide up, or slide down)

  lda collision_flags
  cmp #%00000000
  beq move_right
  cmp #%00000001
  beq slide_down
  cmp #%00000010
  beq slide_up
  ;only case remaining is that both collision tests succeeded. skip
  ;every case handler.
  jmp done
move_right:
  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
  jmp done
slide_up:

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #$00
  sta hero_y+1

  jmp done
slide_down:

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

done:
  .endscope

  lda #HERO_DIRECTION_RIGHT
  sta hero_direction

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

hero_direction_left_handler:

  .scope
  test_action $ff, $ff, (HERO_HEIGHT/2), 0

  ;collect collision information in a local variable
  ;we use b2 because the below code calls map_test_collision which uses
  ;b0 and b1.
  collision_flags = b2
  lda #0
  sta collision_flags

  ;test top left of the hero
  test_not_collision $ff, $ff, (HERO_HEIGHT/2), 0,  no_top_left_collision

  ;set the 0th bit of the collision flags variable
  lda collision_flags
  ora #%00000001
  sta collision_flags

no_top_left_collision:

  ;test bottom left of the hero
  test_not_collision $ff, $ff, (HERO_HEIGHT-1), 0, no_bottom_left_collision

  ;set the 1st bit of the collision flags variable
  lda collision_flags
  ora #%00000010
  sta collision_flags

no_bottom_left_collision:

  ;now we can easily choose which branch to execute (actually move left,
  ;slide up, or slide down)

  lda collision_flags
  cmp #%00000000
  beq move_left
  cmp #%00000001
  beq slide_down
  cmp #%00000010
  beq slide_up
  ;only case remaining is that both collision tests succeeded. skip
  ;every case handler.
  jmp done
move_left:
  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1
  jmp done
slide_up:

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #$00
  sta hero_y+1

  jmp done
slide_down:

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

done:
  .endscope

  lda #HERO_DIRECTION_LEFT
  sta hero_direction

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

hero_direction_down_handler:

  .scope
  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT), 0

  ;collect collision information in a local variable
  ;we use b2 because the below code calls map_test_collision which uses
  ;b0 and b1.
  collision_flags = b2
  lda #0
  sta collision_flags

  ;test bottom left of the hero
  test_not_collision 0, 0, (HERO_HEIGHT), 0, no_bottom_left_collision

  ;set the 0th bit of the collision flags variable
  lda collision_flags
  ora #%00000001
  sta collision_flags

no_bottom_left_collision:

  ;test bottom right of the hero
  test_not_collision HERO_WIDTH-1, 0, (HERO_HEIGHT), 0, no_bottom_right_collision

  ;set the 1st bit of the collision flags variable
  lda collision_flags
  ora #%00000010
  sta collision_flags

no_bottom_right_collision:

  ;now we can easily choose which branch to execute (actually move down,
  ;slide left, or slide right)

  lda collision_flags
  cmp #%00000000
  beq move_down
  cmp #%00000001
  beq slide_right
  cmp #%00000010
  beq slide_left
  ;only case remaining is that both collision tests succeeded. skip
  ;every case handler.
  jmp done
move_down:
  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1
  jmp done
slide_right:

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1

  jmp done
slide_left:

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1

done:
  .endscope

  lda #HERO_DIRECTION_DOWN
  sta hero_direction

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

hero_direction_down_and_right_handler:

  .scope
  ;validate that previous direction was down or right.
  ;if not, the animation is wrong, replace it with default down
  lda hero_direction
  cmp #HERO_DIRECTION_DOWN
  beq legal_direction
  cmp #HERO_DIRECTION_RIGHT
  beq legal_direction
illegal_direction:

  lda #HERO_DIRECTION_DOWN
  sta hero_direction

legal_direction:

  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT), 0
  test_action HERO_WIDTH, 0, (HERO_HEIGHT/2), 0
  test_collision 0, 0, (HERO_HEIGHT), 0, found_collision_down_side
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT), 0, found_collision_down_side

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1
found_collision_down_side:

  test_collision (HERO_WIDTH), 0, (HERO_HEIGHT/2), 0, found_collision_right_side
  test_collision (HERO_WIDTH), 0, (HERO_HEIGHT-1), 0, found_collision_right_side

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
found_collision_right_side:
  .endscope

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

hero_direction_down_and_left_handler:

  .scope
  ;validate that previous direction was down or left.
  ;if not, the animation is wrong, replace it with default down
  lda hero_direction
  cmp #HERO_DIRECTION_DOWN
  beq legal_direction
  cmp #HERO_DIRECTION_LEFT
  beq legal_direction
illegal_direction:

  lda #HERO_DIRECTION_DOWN
  sta hero_direction

legal_direction:

  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT), 0
  test_action $ff, $ff, (HERO_HEIGHT/2), 0
  test_collision 0, 0, (HERO_HEIGHT), 0, found_collision_down_side
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT), 0, found_collision_down_side

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1
found_collision_down_side:

  test_collision $ff, $ff, (HERO_HEIGHT/2), 0, found_collision_left_side
  test_collision $ff, $ff, (HERO_HEIGHT-1), 0, found_collision_left_side

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1
found_collision_left_side:
  .endscope

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

hero_direction_up_handler:

  .scope
  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT/2-1), 0

  ;collect collision information in a local variable
  ;we use b2 because the below code calls map_test_collision which uses
  ;b0 and b1.
  collision_flags = b2
  lda #0
  sta collision_flags

  ;test top left of the hero
  test_not_collision 0, 0, (HERO_HEIGHT/2-1), 0, no_top_left_collision

  ;set the 0th bit of the collision flags variable
  lda collision_flags
  ora #%00000001
  sta collision_flags

no_top_left_collision:

  ;test top right of the hero
  test_not_collision HERO_WIDTH-1, 0, (HERO_HEIGHT/2-1), 0, no_top_right_collision

  ;set the 1st bit of the collision flags variable
  lda collision_flags
  ora #%00000010
  sta collision_flags

no_top_right_collision:

  ;now we can easily choose which branch to execute (actually move up,
  ;slide left, or slide right)

  lda collision_flags
  cmp #%00000000
  beq move_up
  cmp #%00000001
  beq slide_right
  cmp #%00000010
  beq slide_left
  ;only case remaining is that both collision tests succeeded. skip
  ;every case handler.
  jmp done
move_up:
  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #$00
  sta hero_y+1
  jmp done
slide_right:

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1

  jmp done
slide_left:

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1

done:
  .endscope

  lda #HERO_DIRECTION_UP
  sta hero_direction

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

hero_direction_up_and_right_handler:

  .scope
  ;validate that previous direction was up or right.
  ;if not, the animation is wrong, replace it with default up
  lda hero_direction
  cmp #HERO_DIRECTION_UP
  beq legal_direction
  cmp #HERO_DIRECTION_RIGHT
  beq legal_direction
illegal_direction:

  lda #HERO_DIRECTION_UP
  sta hero_direction

legal_direction:

  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT/2-1), 0
  test_action HERO_WIDTH, 0, (HERO_HEIGHT/2), 0
  test_collision 0, 0, (HERO_HEIGHT/2-1), 0, found_collision_up_side
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT/2-1), 0, found_collision_up_side

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #$00
  sta hero_y+1
found_collision_up_side:

  test_collision (HERO_WIDTH), 0, (HERO_HEIGHT/2), 0, found_collision_right_side
  test_collision (HERO_WIDTH), 0, (HERO_HEIGHT-1), 0, found_collision_right_side

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1

found_collision_right_side:

skip_direction_up_and_right_handler:

  .endscope

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

hero_direction_up_and_left_handler:

  .scope
  ;validate that previous direction was up or left.
  ;if not, the animation is wrong, replace it with default up
  lda hero_direction
  cmp #HERO_DIRECTION_UP
  beq legal_direction
  cmp #HERO_DIRECTION_LEFT
  beq legal_direction
illegal_direction:

  lda #HERO_DIRECTION_UP
  sta hero_direction

legal_direction:

  test_action (HERO_WIDTH/2), 0, (HERO_HEIGHT/2-1), 0
  test_action $ff, $ff, (HERO_HEIGHT/2), 0
  test_collision 0, 0, (HERO_HEIGHT/2-1), 0, found_collision_up_side
  test_collision HERO_WIDTH-1, 0, (HERO_HEIGHT/2-1), 0, found_collision_up_side

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #$00
  sta hero_y+1

found_collision_up_side:

  test_collision $ff, $ff, (HERO_HEIGHT/2), 0, found_collision_left_side
  test_collision $ff, $ff, (HERO_HEIGHT-1), 0, found_collision_left_side

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1
found_collision_left_side:

  .endscope

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts
