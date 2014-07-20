.feature force_range
.linecont +
.include "hero.inc"
.include "hero_constants.inc"
.include "entity.inc"
.include "entities.inc"
.include "sprite_chr_data.inc"
.include "familiar.inc"
.include "familiar_constants.inc"
.include "monolith_constants.inc"
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
.include "inventory.inc"
.include "mapper.inc"

.segment "ROM02"

.proc hero_module_init

  lda #$00
  ldx #(hero_ram_end - hero_ram_start - 1)
: sta hero_ram_start,x
  dex
  bpl :-

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

.proc hero_turn_clockwise
  ldy hero_direction
  lda hero_turn_right_direction,y
  sta hero_direction
  rts

.endproc

.proc hero_spawn_familiar_spawn_rush

  far_call #FAMILIAR_BANK, familiar_spawn_rush

  rts

.endproc

.proc hero_spawn_familiar_spawn_fetch

  far_call #FAMILIAR_BANK, familiar_spawn_fetch

  rts

.endproc

.proc hero_spawn_familiar_spawn_unlock

  .ifndef INFINITE_ITEMS
  lda inventory_keys
  beq no_keys_left
  dec inventory_keys
  .endif

  ;clear out the keyed monolith entity index in case we do not find one
  lda #$ff
  sta familiar_param_keyed_monolith_entity_index

  ;search for a keyed monolith that is up and store its index
  ldx #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq not_keyed_monolith
  lda entity_type,x
  cmp #entity_index_monolith
  bne not_keyed_monolith
  lda monolith_flags,x
  and #MONOLITH_TYPE_ISOLATE
  cmp #MONOLITH_TYPE_KEYED
  bne not_keyed_monolith
  lda monolith_flags,x
  and #MONOLITH_FLAGS_UNLOCKED_TEST
  bne already_unlocked

  stx familiar_param_keyed_monolith_entity_index
  jmp found_keyed_monolith

already_unlocked:
not_keyed_monolith:

  dex
  bpl next_entity
found_keyed_monolith:

  lda familiar_param_keyed_monolith_entity_index
  bmi no_keyed_monolith_found

  ;compute the x and y coordinate of the keyhole
  clc
  lda entity_x_lo,x
  adc #<MONOLITH_KEYHOLE_X_OFFSET
  sta familiar_param_keyhole_x
  lda entity_x_hi,x
  adc #>MONOLITH_KEYHOLE_X_OFFSET
  sta familiar_param_keyhole_x+1

  clc
  lda entity_y_lo,x
  adc #<MONOLITH_KEYHOLE_Y_OFFSET
  sta familiar_param_keyhole_y
  lda entity_y_hi,x
  adc #>MONOLITH_KEYHOLE_Y_OFFSET
  sta familiar_param_keyhole_y+1

  far_call #FAMILIAR_BANK, familiar_spawn_unlock

  rts
no_keys_left:
no_keyed_monolith_found:

  ;play a sound
  txa
  pha

  lda #<sfx_error
  sta sound_param_word_0
  lda #>sfx_error
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  rts

.endproc

.proc hero_prepare_familiar_carry_hero
tile_x = w7
tile_y = w8
  ;check to see if the metatile the hero is currently standing on contains ACTION_CARRY_TO
  clc
  lda hero_x
  adc #(HERO_HALF_WIDTH)
  and #$f0
  sta tile_x
  sta w0
  lda hero_x+1
  adc #0
  sta tile_x+1
  sta w0+1

  clc
  lda hero_y
  adc #((HERO_HEIGHT/4)*3)
  and #$f0
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
  sta familiar_param_destination_x

  ;sign extend to all 12 higher bits by testing bit 3 (the x offset sign)
  .scope
  and #%00001000
  beq positive
negative:
  lda familiar_param_destination_x
  ora #$f0
  sta familiar_param_destination_x
  lda #$ff
  sta familiar_param_destination_x+1
  jmp done
positive:
  lda #$00
  sta familiar_param_destination_x+1
done:
  .endscope

  ;get signed 4 bit y offset from param. This is in the lo nybble.
  lda b1
  and #$0f
  sta familiar_param_destination_y

  ;sign extend to all 12 higher bits by testing bit 3 (the y offset sign)
  .scope
  and #%00001000
  beq positive
negative:
  lda familiar_param_destination_y
  ora #$f0
  sta familiar_param_destination_y
  lda #$ff
  sta familiar_param_destination_y+1
  jmp done
positive:
  lda #$00
  sta familiar_param_destination_y+1
done:
  .endscope

  ;now the familiar params contain sign extended offsets extracted from the param.
  ;arithmetically shift left both values by 4 to multiply by 16, the size of a
  ;meta tile. After this, they will be true offsets in 16 bit map coordinates to
  ;add to the hero's current position.

  lda familiar_param_destination_x+1
  asl familiar_param_destination_x
  rol
  asl familiar_param_destination_x
  rol
  asl familiar_param_destination_x
  rol
  asl familiar_param_destination_x
  rol
  sta familiar_param_destination_x+1

  lda familiar_param_destination_y+1
  asl familiar_param_destination_y
  rol
  asl familiar_param_destination_y
  rol
  asl familiar_param_destination_y
  rol
  asl familiar_param_destination_y
  rol
  sta familiar_param_destination_y+1

  ;before computing destination coordinates, infer direction that
  ;the hero and the familiar ought to point based on the signs of
  ;the x and y offsets.
  .scope
  ;if x offset is zero, assume this is a vertical offset
  lda familiar_param_destination_x
  ora familiar_param_destination_x+1
  beq infer_from_y_offset
infer_from_x_offset:

  .scope
  lda familiar_param_destination_x+1
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
  lda familiar_param_destination_y+1
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
  ;use the tile location x when carrying horizontally to
  ;align to a metatile boundary, and use tile location y when
  ;carrying vertically to align to a metatile boundary.
  .scope
  lda hero_direction
  cmp #HERO_DIRECTION_UP
  beq use_vertical_offset
  cmp #HERO_DIRECTION_DOWN
  beq use_vertical_offset
use_horizontal_offset:
  clc
  lda familiar_param_destination_x
  adc tile_x
  sta familiar_param_destination_x
  lda familiar_param_destination_x+1
  adc tile_x+1
  sta familiar_param_destination_x+1

  lda hero_y
  sta familiar_param_destination_y
  lda hero_y+1
  sta familiar_param_destination_y+1
  jmp done
use_vertical_offset:
  clc
  lda familiar_param_destination_y
  adc tile_y
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  adc tile_y+1
  sta familiar_param_destination_y+1

  sec
  lda familiar_param_destination_y
  sbc #$10
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  sbc #$00
  sta familiar_param_destination_y+1

  lda hero_x
  sta familiar_param_destination_x
  lda hero_x+1
  sta familiar_param_destination_x+1
done:
  .endscope

  rts

.endproc

;this routine first prepares the hero's state so it
;can work in tandem with the familiar as it carries
;the hero across a ravine. The prepare routine first
;tests to see if carrying should even occur (standing
;on a tile that has the carry action).
.proc hero_spawn_familiar_spawn_carry_hero
  jsr hero_prepare_familiar_carry_hero
  lda hero_state
  cmp #HERO_STATE_CARRIED
  bne skip_spawn_carry_hero
  far_call #FAMILIAR_BANK, familiar_spawn_carry_hero
skip_spawn_carry_hero:

  rts

.endproc

;This routine is just a wrapper for the familiar's carry bomb spawn routine and checks the bomb
;inventory to see if it is even possible to spawn this technique right now.
.proc hero_spawn_familiar_spawn_carry_bomb
  .ifndef INFINITE_ITEMS
  lda inventory_bombs
  beq no_bombs_left
  dec inventory_bombs
  .endif
  far_call #FAMILIAR_BANK, familiar_spawn_carry_bomb

  rts

no_bombs_left:

  ;play a sound
  txa
  pha

  lda #<sfx_error
  sta sound_param_word_0
  lda #>sfx_error
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  rts

.endproc

;This routine is just a wrapper for the familiar's carry lantern spawn routine and checks the lantern
;inventory to see if it is even possible to spawn this technique right now.
.proc hero_spawn_familiar_spawn_carry_lantern
  .ifndef INFINITE_ITEMS
  lda inventory_lanterns
  beq no_lanterns_left
  dec inventory_lanterns
  .endif

  far_call #FAMILIAR_BANK, familiar_spawn_carry_lantern

  rts

no_lanterns_left:

  ;play a sound
  txa
  pha

  lda #<sfx_error
  sta sound_param_word_0
  lda #>sfx_error
  sta sound_param_word_0+1

  lda #0
  sta sound_param_byte_0

  ldx #soundeffect_one
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  rts

.endproc

.proc hero_spawn_familiar_spawn_shield

  far_call #FAMILIAR_BANK, familiar_spawn_shield

  rts

.endproc

.proc hero_spawn_familiar_spawn_homing

  far_call #FAMILIAR_BANK, familiar_spawn_homing

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

  .ifndef INVINCIBLE
  ; -if hero_invincibility_counter is 0
  lda hero_invincibility_counter
  bne hero_invincible
  ; -if cardinal direction param is none (-1),
  ldy hero_knockback_direction
  bpl skip_lookup_opposite_direction
    ; -look up opposite direction for hero_direction.
  ldy hero_direction
  lda hero_opposite_direction,y
  tay
skip_lookup_opposite_direction:
  ; -look up direction handlers index from hero_knockback_direction
  lda hero_direction_to_direction_handlers_index,y
  ; -store this in hero_knockback_direction
  sta hero_direction_handler
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
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  ;decrement hero's health
  dec hero_health
  bne hero_not_dead

  ;tell play state to transition to game over on next frame
  lda #ACTION_GAME_OVER
  sta state_control_params+play_state_control::action

hero_not_dead:

  lda #HERO_STATE_KNOCKBACK
  sta hero_state

hero_invincible:
  .endif

  rts

.endproc

;sets up the attack state to begin executing on
;the next frame. By default, this is what is called
;when the a button is pressed. Entities can override
;this behavior by calling another state setup routine
;to cancel the attack.
.proc hero_attack
  lda #ACTION_NOP
  sta entity_action_rect1_action

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

  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
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
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  rts

.endproc

.define familiar_spawn_tech \
  hero_spawn_familiar_spawn_rush, \
  hero_spawn_familiar_spawn_fetch, \
  hero_spawn_familiar_spawn_unlock, \
  hero_spawn_familiar_spawn_carry_bomb, \
  hero_spawn_familiar_spawn_carry_lantern, \
  hero_spawn_familiar_spawn_carry_hero, \
  hero_spawn_familiar_spawn_shield, \
  hero_spawn_familiar_spawn_homing

familiar_spawn_tech_lo:
  .lobytes familiar_spawn_tech

familiar_spawn_tech_hi:
  .hibytes familiar_spawn_tech

;Spawns the familiar based on whether tech 1 or tech 2 is
;currently selected, and looks up the correct spawn routine.
.proc hero_spawn_familiar
  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_TEST
  bne familiar_still_alive
  lda inventory_selected_tech
  cmp #tech2
  beq tech2_selected
tech1_selected:
  ldx inventory_tech1
  jmp done
tech2_selected:
  ldx inventory_tech2
done:

  cpx #tech_carry_adlanniel
  beq do_not_switch_to_throw_state
  cpx #tech_carry_lantern
  beq do_not_switch_to_throw_state

  lda #HERO_STATE_THROW
  sta hero_state

  lda #HERO_STATE_THROW_LENGTH
  sta hero_state_counter

  lda hero_direction
  tay
  lda throw_animation_addresses_lo,y
  sta hero_animation_address
  sta w2
  lda throw_animation_addresses_hi,y
  sta hero_animation_address+1
  sta w2+1

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1

  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_reset_animation

do_not_switch_to_throw_state:

  lda familiar_spawn_tech_lo,x
  sta w0
  lda familiar_spawn_tech_hi,x
  sta w0+1
  jsr indirect_jsr_w0
familiar_still_alive:

  rts

.endproc

;used by the familiar when setting down the hero after carrying her.
.proc hero_set_down
  lda #ACTION_NOP
  sta entity_action_rect1_action

  lda #HERO_STATE_MAIN
  sta hero_state

  rts

.endproc

;used by any entity which is presenting some confirm/cancel dialog
;where it does not want the hero to respond to input for a few frames
;expects b0 to contain how many frames to wait
.proc hero_wait_frames

  lda b0
  sta hero_state_counter

  lda #ACTION_NOP
  sta entity_action_rect1_action

  lda hero_flags
  and #HERO_FLAGS_MOVING_CLEAR
  sta hero_flags

  lda #HERO_STATE_WAIT_FRAMES
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

  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_reset_animation

  lda #ACTION_NOP
  sta entity_action_rect1_action

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

  jsr geotests_rect_in_rect_size
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

.segment "CODE"

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
  sta chr_group_offset

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
  switch_bank_ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_draw_animation
do_not_draw:

  rts

.endproc

;Draws the hero's health status.
;This assumes the current bank is the sprites and animations bank!
.proc hero_draw_status
  switch_bank_ldy #HERO_SPRITES_AND_ANIMATIONS_BANK

  lda hero_sprite_group_offset
  sta chr_group_offset

  lda hero_health
  beq no_hearts
  sta b6

  lda #<heart0
  sta w0
  lda #>heart0
  sta w0+1

  lda #(CAMERA_SCREEN_ORIGIN_X+HERO_STATUS_X)
  sta w3
  lda #0
  sta w3+1

  lda #(CAMERA_SCREEN_ORIGIN_Y+HERO_STATUS_Y)
  sta w4
  lda #0
  sta w4+1

  lda #0
  sta b2

draw_next_heart:
  jsr sprite_draw_metasprite

  lda w3
  adc #$08
  sta w3

  dec b6
  bne draw_next_heart
no_hearts:

  lda inventory_selected_tech
  bne tech2
tech1:

  lda tech1_chr_offset
  sta chr_group_offset

  jmp done
tech2:

  lda tech2_chr_offset
  sta chr_group_offset

done:

  lda #<Tech0
  sta w0
  lda #>Tech0
  sta w0+1

  clc
  lda #(CAMERA_SCREEN_ORIGIN_X+HERO_STATUS_X)
  adc hero_status_flash_counter
  sta w3
  lda #0
  adc #0
  sta w3+1

  lda #(CAMERA_SCREEN_ORIGIN_Y+HERO_STATUS_Y+8)
  sta w4
  lda #0
  sta w4+1

  lda hero_status_flash_counter
  beq :+
  dec hero_status_flash_counter
:

  lda #0
  sta b2
  jsr sprite_draw_metasprite

  rts

.endproc

.segment "ROM02"

;clears zero flag if hero is moving, set it if not
.proc hero_is_moving

  lda hero_flags
  and #HERO_FLAGS_MOVING_TEST

  rts

.endproc

;sets zero flag if the hero is attacking, clears it if not.
;Kind of odd juxtaposed against hero_is_moving, however
;hero_is_moving is a sub-state of the main state, really,
;whereas the attack state is a separate state.
.proc hero_is_attacking

  lda hero_state
  cmp #HERO_STATE_ATTACK

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

hero_direction_to_direction_handlers_index:
  .byte 1, 2, 4, 8

.define main_animation_addresses\
  adlanniel_walk_side,\
  adlanniel_walk_side,\
  adlanniel_walk_down,\
  adlanniel_walk_up

main_animation_addresses_lo:
  .lobytes main_animation_addresses

main_animation_addresses_hi:
  .hibytes main_animation_addresses

.define attack_animation_addresses\
  adlanniel_fight_side,\
  adlanniel_fight_side,\
  adlanniel_fight_down,\
  adlanniel_fight_up

attack_animation_addresses_lo:
  .lobytes attack_animation_addresses

attack_animation_addresses_hi:
  .hibytes attack_animation_addresses

.define throw_animation_addresses\
  adlanniel_throw_side,\
  adlanniel_throw_side,\
  adlanniel_throw_down,\
  adlanniel_throw_up

throw_animation_addresses_lo:
  .lobytes throw_animation_addresses

throw_animation_addresses_hi:
  .hibytes throw_animation_addresses

.define hero_states \
    hero_state_init, \
    hero_state_main, \
    hero_state_knockback, \
    hero_state_attack, \
    hero_state_throw, \
    hero_state_carried, \
    hero_state_wait_frames

hero_lo:
  .lobytes hero_states

hero_hi:
  .hibytes hero_states

hero_opposite_direction:
  .byte HERO_DIRECTION_LEFT
  .byte HERO_DIRECTION_RIGHT
  .byte HERO_DIRECTION_UP
  .byte HERO_DIRECTION_DOWN

hero_turn_right_direction:
  .byte HERO_DIRECTION_DOWN
  .byte HERO_DIRECTION_UP
  .byte HERO_DIRECTION_LEFT
  .byte HERO_DIRECTION_RIGHT

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

hero_update:

  lda hero_state
  tay
  lda hero_lo,y
  sta w0
  lda hero_hi,y
  sta w0+1
  jmp (w0)

;****************************************************************
;The init state for the hero entity. This state transitions to
;the main walking state, sets the hero to be drawable, clears out
;action rect information, sets width and height, sets speed,
;loads animation for current direction, resets the animation
;object, loads the sprite chr offset, and clears other state
;information for knockback and invincibility frames.
;****************************************************************
hero_state_init:

  lda #HERO_STATE_MAIN
  sta hero_state

  lda #HERO_FLAGS_DRAWABLE_SET
  sta hero_flags
  lda #0
  sta entity_action_rect1_x
  sta entity_action_rect1_x+1
  sta entity_action_rect1_y
  sta entity_action_rect1_y+1
  sta entity_action_rect1_width
  sta entity_action_rect1_height
  lda #ACTION_NOP
  sta entity_action_rect1_action

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

  lda #0
  sta hero_direction_handler

  lda #0
  sta hero_status_flash_counter

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1
  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_reset_animation

  ldy hero_direction
  lda sprite_flags_direction,y
  sta hero_sprite_flags

  ldy #HERO_SPRITE_CHR_GROUPS_INDEX
  lda sprite_chr_group_offsets,y
  sta hero_sprite_group_offset

  lda #0
  sta hero_invincibility_counter
  sta hero_knockback_counter

  rts

;****************************************************************
;The carried state is totally passive. When the hero transitions
;into this state, the familiar takes over and will modify the
;hero's coordinates as it carries her across a body of water or
;pit or ravine. There is a routine above for transitioning the
;hero back into the main state from the carried state, called
;hero_set_down.
;****************************************************************
hero_state_carried:

  rts

;****************************************************************
;This is another passive state which does nothing for several
;frames (hero_state_counter) and then transitions back to the
;main state
;****************************************************************
hero_state_wait_frames:

  dec hero_state_counter
  bne :+

  lda #HERO_STATE_MAIN
  sta hero_state
:

  rts

;****************************************************************
;This is the main walking state. It checks the controller buffer
;for the A button (attack), B button (perform current owl tech),
;and d-pad. It also maintains state for knockback and invincibi-
;lity frames. It uses bits from the d-pad as an index into a look
;up table of direction handlers. These direction handlers are
;also relied upon for knockback so the hero doesn't go careening
;through any walls.
;****************************************************************
hero_state_main:

  ;get up, down, left, right into a single bit field
  lda #0
  sta hero_direction_handler
  lda buffer_controller+buttons::_up
  ror
  rol hero_direction_handler
  lda buffer_controller+buttons::_down
  ror
  rol hero_direction_handler
  lda buffer_controller+buttons::_left
  ror
  rol hero_direction_handler
  lda buffer_controller+buttons::_right
  ror
  rol hero_direction_handler

  lda #HERO_SPEED
  sta hero_speed

  ;use this as an index into a direction handlers lut
  ldy hero_direction_handler
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

  jsr hero_advance_invincibility_state

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
  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation
do_not_animate_hero:

  lda buffer_controller+buttons::_select
  and #%00000011
  cmp #%00000001
  bne skip_switch_selected_tech

  ;flip the only bit that is ever set in the selected tech, since
  ;it is only tech1 or tech2 (0 or 1)
  lda inventory_selected_tech
  eor #%00000001
  sta inventory_selected_tech

  ;start the status flash counter
  lda #HERO_STATUS_FLASH_DISTANCE
  sta hero_status_flash_counter

  ;play a sound
  txa
  pha

  lda #<sfx_select
  sta sound_param_word_0
  lda #>sfx_select
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  far_call #SFX_BANK, stream_initialize

  pla
  tax

skip_switch_selected_tech:

  lda buffer_controller+buttons::_b
  and #%00000011
  cmp #%00000001
  bne skip_spawn_familiar_test

  jsr hero_spawn_familiar

skip_spawn_familiar_test:

  lda buffer_controller+buttons::_a
  and #%00000011
  cmp #%00000001
  bne skip_attack_test

  jsr hero_attack

skip_attack_test:

  lda buffer_controller+buttons::_start
  and #%00000011
  cmp #%00000001
  bne skip_inventory_test

  lda #$ff
  sta buffer_controller+buttons::_start
  lda #ACTION_SHOW_INVENTORY_SCREEN
  sta state_control_params+play_state_control::action

skip_inventory_test:

  rts

;****************************************************************
;This is the knockback state. This state disallows any input from
;the controller while the hero is being knocked back.
;****************************************************************
hero_state_knockback:

  jsr hero_advance_invincibility_state

  lda #HERO_KNOCKBACK_SPEED
  sta hero_speed

  ldy hero_direction_handler
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

  ;transition back to the main state
  lda #HERO_STATE_MAIN
  sta hero_state

hero_knockback_counter_not_zero:

  rts

;****************************************************************
;This is the throw state. The hero transitions to this state
;immediately upon throwing the owl, except in the carried state.
;It  It updates the invincibility frames logic and displays the
;throwing animation, then returns control to the main state.
;****************************************************************
hero_state_throw:

  jsr hero_advance_invincibility_state

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1

  lda hero_animation_address
  sta w2
  lda hero_animation_address+1
  sta w2+1
  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation

  dec hero_state_counter
  bne throw_not_done

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
  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_reset_animation

  lda #ACTION_NOP
  sta entity_action_rect1_action

  lda #HERO_STATE_MAIN
  sta hero_state

throw_not_done:

  rts

;****************************************************************
;This is the attack state. It is the state the hero transitions
;to when the A button is pressed. The hero cannot walk while in
;this state. This state modifies the action rect and sets a flag
;in the hero indicating that it is deadly to enemies. This state
;also maintains invincibility frames state if carried over from
;getting hit.
;****************************************************************
hero_state_attack:

  jsr hero_advance_invincibility_state

  ;wait a few frames before activating the attack rect
  lda hero_state_counter
  cmp #HERO_ACTIVATE_ATTACK_RECT_WHEN_THIS_MANY_FRAMES_REMAINING
  bne :+
  lda #ACTION_ATTACK
  sta entity_action_rect1_action
  lda hero_direction
  sta entity_action_rect1_direction
:

  ;compute top left of action rect based on direction
  ldy hero_direction
  clc
  lda attack_rect_offset_x_lo,y
  adc hero_x
  sta entity_action_rect1_x
  lda attack_rect_offset_x_hi,y
  adc hero_x+1
  sta entity_action_rect1_x+1

  clc
  lda attack_rect_offset_y_lo,y
  adc hero_y
  sta entity_action_rect1_y
  lda attack_rect_offset_y_hi,y
  adc hero_y+1
  sta entity_action_rect1_y+1

  lda #16
  sta entity_action_rect1_width
  sta entity_action_rect1_height

  lda #<hero_animation_object
  sta w1
  lda #>hero_animation_object
  sta w1+1

  lda hero_animation_address
  sta w2
  lda hero_animation_address+1
  sta w2+1
  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
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
  ldy #HERO_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_reset_animation

  lda #ACTION_NOP
  sta entity_action_rect1_action

  lda #HERO_STATE_MAIN
  sta hero_state

attack_not_done:

  rts

.proc hero_advance_invincibility_state

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

  rts

.endproc

indirect_jsr_w0:
  jmp (w0)

;****************************************************************
;This is the callback listed in the direction handlers lut for
;all invalid combinations of direction. This should normally
;never happen, but this is here to protect the game from crashing
;if somehow an invalid direction is ever input.
;****************************************************************
hero_direction_nop_handler:

  lda hero_flags
  and #HERO_FLAGS_MOVING_CLEAR
  sta hero_flags

  rts

;****************************************************************
;The following direction handlers just move the hero in the
;direction she is facing, and tests for actions within the newly
;moved rect. They also flag that she is pointing in the new dir-
;ection and that she is moving. Diagonal direction handlers
;validate that the most recent direction was one of two possible
;cardinal directions and replaces it with a default one if
;violated. This allows the hero to continue facing in a direction
;while beginning to move diagonally.
;****************************************************************

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

;****************************************************************
;Handler for moving right
;****************************************************************
hero_direction_right_handler:

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1

  ;3/4 down right side of rect
  test_action (HERO_WIDTH), 0, (HERO_THREE_QUARTERS_DOWN), 0

  lda #HERO_DIRECTION_RIGHT
  sta hero_direction

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

;****************************************************************
;Handler for moving left
;****************************************************************
hero_direction_left_handler:

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1

  ;3/4 down left side of rect
  test_action 0, 0, ((HERO_HEIGHT/4)*3), 0

  lda #HERO_DIRECTION_LEFT
  sta hero_direction

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

;****************************************************************
;Handler for moving down
;****************************************************************
hero_direction_down_handler:

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

  ;middle of bottom of rect
  test_action (HERO_HALF_WIDTH), 0, (HERO_HEIGHT), 0

  lda #HERO_DIRECTION_DOWN
  sta hero_direction

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

;****************************************************************
;Handler for moving down and right
;****************************************************************
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
  .endscope

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1

  ;middle of bottom of rect
  test_action (HERO_HALF_WIDTH), 0, (HERO_HEIGHT), 0
  ;3/4 down right side of rect
  test_action (HERO_WIDTH), 0, (HERO_THREE_QUARTERS_DOWN), 0

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

;****************************************************************
;Handler for moving down and left
;****************************************************************
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
  .endscope

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1

  ;middle of bottom of rect
  test_action (HERO_HALF_WIDTH), 0, (HERO_HEIGHT), 0
  ;3/4 down left side of rect
  test_action 0, 0, ((HERO_HEIGHT/4)*3), 0

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

;****************************************************************
;Handler for moving up
;****************************************************************
hero_direction_up_handler:

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #$00
  sta hero_y+1

  ;middle of top of rect
  test_action (HERO_HALF_WIDTH), 0, (HERO_HALF_HEIGHT-HERO_SPEED*2), 0

  lda #HERO_DIRECTION_UP
  sta hero_direction

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

;****************************************************************
;Handler for moving up and right
;****************************************************************
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
  .endscope

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #$00
  sta hero_y+1

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1

  ;middle of top of rect
  test_action (HERO_HALF_WIDTH), 0, (HERO_HALF_HEIGHT), 0
  ;3/4 down right side of rect
  test_action (HERO_WIDTH), 0, ((HERO_HEIGHT/4)*3), 0

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

;****************************************************************
;Handler for moving up and left
;****************************************************************
hero_direction_up_and_left_handler:

  ;validate that previous direction was up or left.
  ;if not, the animation is wrong, replace it with default up
  .scope
  lda hero_direction
  cmp #HERO_DIRECTION_UP
  beq legal_direction
  cmp #HERO_DIRECTION_LEFT
  beq legal_direction
illegal_direction:

  lda #HERO_DIRECTION_UP
  sta hero_direction

legal_direction:
  .endscope

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #$00
  sta hero_y+1

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1

  ;middle of top of rect
  test_action (HERO_HALF_WIDTH), 0, (HERO_HALF_HEIGHT), 0
  ;3/4 down left side of rect
  test_action 0, 0, ((HERO_HEIGHT/4)*3), 0

  lda hero_flags
  ora #HERO_FLAGS_MOVING_SET
  sta hero_flags

  rts

;****************************************************************
;The following collision routines are used to eject Adlanniel
;from the map by performing as few tests as possible based on the
;direction she is moving in.
;****************************************************************
hero_eject_from_solid_tiles:

  lda hero_state
  cmp #HERO_STATE_CARRIED
  beq do_not_eject
  ldy hero_direction_handler
  lda collision_handlers_lo,y
  sta w0
  lda collision_handlers_hi,y
  sta w0+1
  jsr indirect_jsr_w0
do_not_eject:

  rts

.define collision_handlers \
  hero_collision_nop_handler,\
  hero_collision_right_handler,\
  hero_collision_left_handler,\
  hero_collision_nop_handler,\
  hero_collision_down_handler,\
  hero_collision_down_and_right_handler,\
  hero_collision_down_and_left_handler,\
  hero_collision_nop_handler,\
  hero_collision_up_handler,\
  hero_collision_up_and_right_handler,\
  hero_collision_up_and_left_handler,\
  hero_collision_nop_handler,\
  hero_collision_nop_handler,\
  hero_collision_nop_handler,\
  hero_collision_nop_handler,\
  hero_collision_nop_handler

collision_handlers_lo:
  .lobytes collision_handlers

collision_handlers_hi:
  .hibytes collision_handlers

;****************************************************************
;A nop handler for undefined indices (we have undefined indices
;here for the same reason as the direction handlers---we build
;an index from bits rotated into the controller buffer, and some
;combinations do not have meaning).
;****************************************************************
hero_collision_nop_handler:

  rts

;****************************************************************
;Tests for collisions to the right of the hero
;****************************************************************
.proc hero_collision_right_handler

  lda #0
  sta b7
  .scope
  test_not_collision (HERO_WIDTH), 0, (HERO_HALF_HEIGHT), 0, no_collision
  lda b7
  ora #%00000001
  sta b7
no_collision:
  .endscope

  .scope
  test_not_collision (HERO_WIDTH), 0, (HERO_HEIGHT), 0, no_collision
  lda b7
  ora #%00000010
  sta b7
no_collision:
  .endscope

  ;select ejection handler based on the above results
  ldy b7
  lda hero_collision_right_handler_ejection_handlers_lo,y
  sta w0
  lda hero_collision_right_handler_ejection_handlers_hi,y
  sta w0+1
  jmp (w0)

.define hero_collision_right_handler_ejection_handlers \
  eject_nop,\
  eject_slide_down,\
  eject_slide_up,\
  eject_horizontally

hero_collision_right_handler_ejection_handlers_lo:
  .lobytes hero_collision_right_handler_ejection_handlers

hero_collision_right_handler_ejection_handlers_hi:
  .hibytes hero_collision_right_handler_ejection_handlers

eject_nop:

  rts

eject_slide_up:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the left side of a tile so round down
  lda hero_x
  and #%11110000
  sta hero_x

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #0
  sta hero_y+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_UP
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

eject_slide_down:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the left side of a tile so round down
  lda hero_x
  and #%11110000
  sta hero_x

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #0
  sta hero_y+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_DOWN
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

eject_horizontally:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the left side of a tile so round down
  lda hero_x
  and #%11110000
  sta hero_x

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_LEFT
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

.endproc

;****************************************************************
;Tests for collisions to the left of the hero
;****************************************************************
.proc hero_collision_left_handler

  lda #0
  sta b7
  .scope
  test_not_collision 0, 0, (HERO_HALF_HEIGHT), 0, no_collision
  lda b7
  ora #%00000001
  sta b7
no_collision:
  .endscope

  .scope
  test_not_collision 0, 0, (HERO_HEIGHT), 0, no_collision
  lda b7
  ora #%00000010
  sta b7
no_collision:
  .endscope

  ;select ejection handler based on the above results
  ldy b7
  lda hero_collision_left_handler_ejection_handlers_lo,y
  sta w0
  lda hero_collision_left_handler_ejection_handlers_hi,y
  sta w0+1
  jmp (w0)

.define hero_collision_left_handler_ejection_handlers \
  eject_nop,\
  eject_slide_down,\
  eject_slide_up,\
  eject_horizontally

hero_collision_left_handler_ejection_handlers_lo:
  .lobytes hero_collision_left_handler_ejection_handlers

hero_collision_left_handler_ejection_handlers_hi:
  .hibytes hero_collision_left_handler_ejection_handlers

eject_nop:

  rts

eject_slide_up:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the right side of a tile so round up
  clc
  lda hero_x
  and #%11110000
  adc #$10
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
  sta hero_x+1

  sec
  lda hero_y
  sbc hero_speed
  sta hero_y
  lda hero_y+1
  sbc #0
  sta hero_y+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_UP
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

eject_slide_down:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the right side of a tile so round up
  clc
  lda hero_x
  and #%11110000
  adc #$10
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
  sta hero_x+1

  clc
  lda hero_y
  adc hero_speed
  sta hero_y
  lda hero_y+1
  adc #0
  sta hero_y+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_DOWN
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

eject_horizontally:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the right side of a tile so round up
  clc
  lda hero_x
  and #%11110000
  adc #$10
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
  sta hero_x+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_RIGHT
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

.endproc

;****************************************************************
;Tests for collisions below the hero
;****************************************************************
.proc hero_collision_down_handler

  lda #0
  sta b7
  .scope
  test_not_collision 0, 0, (HERO_HEIGHT), 0, no_collision
  lda b7
  ora #%00000001
  sta b7
no_collision:
  .endscope

  .scope
  test_not_collision (HERO_WIDTH), 0, (HERO_HEIGHT), 0, no_collision
  lda b7
  ora #%00000010
  sta b7
no_collision:
  .endscope

  ;select ejection handler based on the above results
  ldy b7
  lda hero_collision_down_handler_ejection_handlers_lo,y
  sta w0
  lda hero_collision_down_handler_ejection_handlers_hi,y
  sta w0+1
  jmp (w0)

.define hero_collision_down_handler_ejection_handlers \
  eject_nop,\
  eject_slide_right,\
  eject_slide_left,\
  eject_vertically

hero_collision_down_handler_ejection_handlers_lo:
  .lobytes hero_collision_down_handler_ejection_handlers

hero_collision_down_handler_ejection_handlers_hi:
  .hibytes hero_collision_down_handler_ejection_handlers

eject_nop:

  rts

eject_slide_left:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the top of a tile, so round down
  lda hero_y
  and #%11110000
  sta hero_y

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #0
  sta hero_x+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_LEFT
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

eject_slide_right:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the top of a tile, so round down
  lda hero_y
  and #%11110000
  sta hero_y

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #0
  sta hero_x+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_RIGHT
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

eject_vertically:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the top of a tile, so round down
  lda hero_y
  and #%11110000
  sta hero_y

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_UP
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

.endproc

;****************************************************************
;Tests for collisions above the hero
;****************************************************************
.proc hero_collision_up_handler

  lda #0
  sta b7
  .scope
  test_not_collision 0, 0, (HERO_HALF_HEIGHT), 0, no_collision
  lda b7
  ora #%00000001
  sta b7
no_collision:
  .endscope

  .scope
  test_not_collision (HERO_WIDTH), 0, (HERO_HALF_HEIGHT), 0, no_collision
  lda b7
  ora #%00000010
  sta b7
no_collision:
  .endscope

  ;select ejection handler based on the above results
  ldy b7
  lda hero_collision_up_handler_ejection_handlers_lo,y
  sta w0
  lda hero_collision_up_handler_ejection_handlers_hi,y
  sta w0+1
  jmp (w0)

.define hero_collision_up_handler_ejection_handlers \
  eject_nop,\
  eject_slide_right,\
  eject_slide_left,\
  eject_vertically

hero_collision_up_handler_ejection_handlers_lo:
  .lobytes hero_collision_up_handler_ejection_handlers

hero_collision_up_handler_ejection_handlers_hi:
  .hibytes hero_collision_up_handler_ejection_handlers

eject_nop:

  rts

eject_slide_left:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the bottom of a tile, so round up
  clc
  lda hero_y
  and #%11110000
  adc #$10
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

  sec
  lda hero_x
  sbc hero_speed
  sta hero_x
  lda hero_x+1
  sbc #0
  sta hero_x+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_LEFT
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

eject_slide_right:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the bottom of a tile, so round up
  clc
  lda hero_y
  and #%11110000
  adc #$10
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

  clc
  lda hero_x
  adc hero_speed
  sta hero_x
  lda hero_x+1
  adc #0
  sta hero_x+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_RIGHT
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

eject_vertically:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the bottom of a tile, so round up
  clc
  lda hero_y
  and #%11110000
  adc #$10
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

  ;the hero has changed direction due to map ejection;
  ;make sure we keep track of this here so the camera uses
  ;the correct follow handler
  ldx #HERO_DIRECTION_DOWN
  lda hero_direction_to_direction_handlers_index,x
  sta hero_direction_handler

  rts

.endproc

;****************************************************************
;Tests for collisions down and to the right of the hero
;****************************************************************
hero_collision_down_and_right_handler:

  ;save hero x and y before ejection
  lda hero_x
  pha
  lda hero_y
  pha

  .scope
  ;testing bottom left of rect
  test_not_collision 0, 0, (HERO_HEIGHT), 0, no_collision
  ;eject hero to align with metatile grid
  ;hero is cutting in to the top of a tile, so round down
  lda hero_y
  and #%11110000
  sta hero_y
no_collision:
  .endscope

  .scope
  ;testing right side of rect
  test_not_collision (HERO_WIDTH), 0, (HERO_HALF_HEIGHT), 0, no_collision
  ;eject hero to align with metatile grid
  ;hero is cutting in to the left side of a tile so round down
  lda hero_x
  and #%11110000
  sta hero_x
no_collision:
  .endscope

  .scope
  ;test bottom right corner
  test_not_collision (HERO_WIDTH), 0, (HERO_HEIGHT), 0, no_collision

  ;find out which ejection would be smaller
  lda hero_y
  and #%00001111
  sta b0
  lda hero_x
  and #%00001111
  cmp b0
  bmi y_ejection_larger_so_eject_x
x_ejection_larger_so_eject_y:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the top of a tile, so round down
  lda hero_y
  and #%11110000
  sta hero_y

  jmp no_collision
y_ejection_larger_so_eject_x:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the left side of a tile so round down
  clc
  lda hero_x
  and #%11110000
  sta hero_x

no_collision:
  .endscope

  ;restore previous hero x and hero y from before ejection
  pla
  sta b0
  pla
  sta b1

  .scope
  lda b0
  cmp hero_y
  bne ejected
  lda b1
  cmp hero_x
  bne ejected
not_ejected:

  ;test to see if both hero x and hero y are along the worst-case
  ;diagonal (this diagonal will cause camera updates to upload both
  ;a row and a column). If so, bump the hero away from this diagonal
  ;to prevent these worst case updates.
  lda hero_x
  and #%00000111
  sta b0
  lda hero_y
  and #%00000111
  sta b1
  lda b0
  cmp b1
  bne :+

  sec
  lda hero_x
  sbc #HERO_SPEED
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1

:
ejected:
  .endscope

  rts

;****************************************************************
;Tests for collisions down and to the left of the hero
;****************************************************************
hero_collision_down_and_left_handler:

  ;save hero x and y before ejection
  lda hero_x
  pha
  lda hero_y
  pha

  .scope
  ;testing bottom right of rect
  test_not_collision (HERO_WIDTH), 0, (HERO_HEIGHT), 0, no_collision
  ;eject hero to align with metatile grid
  ;hero is cutting in to the top of a tile, so round down
  lda hero_y
  and #%11110000
  sta hero_y
no_collision:
  .endscope

  .scope
  ;testing left side of rect
  test_not_collision 0, 0, (HERO_HALF_HEIGHT), 0, no_collision
  ;eject hero to align with metatile grid
  ;hero is cutting in to the right side of a tile so round up
  clc
  lda hero_x
  and #%11110000
  adc #$10
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
  sta hero_x+1
no_collision:
  .endscope

  .scope
  ;test bottom left corner
  test_not_collision 0, 0, (HERO_HEIGHT), 0, no_collision

  ;find out which ejection would be smaller
  lda hero_y
  and #%00001111
  sta b0
  lda hero_x
  and #%00001111
  eor #%00001111
  clc
  adc #$01
  cmp b0
  bmi y_ejection_larger_so_eject_x
x_ejection_larger_so_eject_y:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the top of a tile, so round down
  lda hero_y
  and #%11110000
  sta hero_y

  jmp no_collision
y_ejection_larger_so_eject_x:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the right side of a tile so round up
  clc
  lda hero_x
  and #%11110000
  adc #$10
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
  sta hero_x+1

no_collision:
  .endscope

  ;restore previous hero x and hero y from before ejection
  pla
  sta b0
  pla
  sta b1

  .scope
  lda b0
  cmp hero_y
  bne ejected
  lda b1
  cmp hero_x
  bne ejected
not_ejected:

  ;test to see if both hero x and hero y are along the worst-case
  ;diagonal (this diagonal will cause camera updates to upload both
  ;a row and a column). If so, bump the hero away from this diagonal
  ;to prevent these worst case updates.
  lda hero_x
  and #%00000111
  sta b0
  lda hero_y
  and #%00000111
  sta b1
  lda b0
  cmp b1
  bne :+

  clc
  lda hero_x
  adc #HERO_SPEED
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1

:
ejected:
  .endscope

  rts

;****************************************************************
;Tests for collisions up and to the right of the hero
;****************************************************************
hero_collision_up_and_right_handler:

  ;save hero x and y before ejection
  lda hero_x
  pha
  lda hero_y
  pha

  .scope
  ;testing top left of rect
  test_not_collision 0, 0, (HERO_HALF_HEIGHT), 0, no_collision
  ;eject hero to align with metatile grid
  ;hero is cutting in to the bottom of a tile, so round up
  clc
  lda hero_y
  and #%11110000
  adc #$10
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1
no_collision:
  .endscope

  .scope
  ;testing bottom right of rect
  test_not_collision (HERO_WIDTH), 0, (HERO_HEIGHT), 0, no_collision
  ;eject hero to align with metatile grid
  ;hero is cutting in to the left side of a tile so round down
  lda hero_x
  and #%11110000
  sta hero_x
no_collision:
  .endscope

  .scope
  ;test top right corner
  test_not_collision (HERO_WIDTH), 0, (HERO_HALF_HEIGHT), 0, no_collision

  ;find out which ejection would be smaller
  lda hero_y
  and #%00001111
  eor #%00001111
  clc
  adc #$01
  sta b0
  lda hero_x
  and #%00001111
  cmp b0
  bmi y_ejection_larger_so_eject_x
x_ejection_larger_so_eject_y:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the bottom of a tile, so round up
  clc
  lda hero_y
  and #%11110000
  adc #$10
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

  jmp no_collision
y_ejection_larger_so_eject_x:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the left side of a tile so round down
  clc
  lda hero_x
  and #%11110000
  sta hero_x

no_collision:
  .endscope

  ;restore previous hero x and hero y from before ejection
  pla
  sta b0
  pla
  sta b1

  .scope
  lda b0
  cmp hero_y
  bne ejected
  lda b1
  cmp hero_x
  bne ejected
not_ejected:

  ;test to see if both hero x and hero y are along the worst-case
  ;diagonal (this diagonal will cause camera updates to upload both
  ;a row and a column). If so, bump the hero away from this diagonal
  ;to prevent these worst case updates.
  lda hero_x
  and #%00000111
  sta b0
  lda hero_y
  and #%00000111
  sta b1
  lda b0
  cmp b1
  bne :+

  sec
  lda hero_x
  sbc #HERO_SPEED
  sta hero_x
  lda hero_x+1
  sbc #$00
  sta hero_x+1

:
ejected:
  .endscope

  rts

;****************************************************************
;Tests for collisions up and to the left of the hero
;****************************************************************
hero_collision_up_and_left_handler:

  ;save hero x and y before ejection
  lda hero_x
  pha
  lda hero_y
  pha

  .scope
  ;testing top right of rect
  test_not_collision (HERO_WIDTH), 0, (HERO_HALF_HEIGHT), 0, no_collision
  ;eject hero to align with metatile grid
  ;hero is cutting in to the bottom of a tile, so round up
  clc
  lda hero_y
  and #%11110000
  adc #$10
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1
no_collision:
  .endscope

  .scope
  ;testing left side of rect
  test_not_collision 0, 0, (HERO_HEIGHT), 0, no_collision
  ;eject hero to align with metatile grid
  ;hero is cutting in to the right side of a tile so round up
  clc
  lda hero_x
  and #%11110000
  adc #$10
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
  sta hero_x+1
no_collision:
  .endscope

  .scope
  ;test top left corner
  test_not_collision 0, 0, (HERO_HALF_HEIGHT), 0, no_collision

  ;find out which ejection would be smaller
  lda hero_y
  and #%00001111
  eor #%00001111
  clc
  adc #$01
  sta b0
  lda hero_x
  and #%00001111
  eor #%00001111
  clc
  adc #$01
  cmp b0
  bmi y_ejection_larger_so_eject_x
x_ejection_larger_so_eject_y:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the bottom of a tile, so round up
  clc
  lda hero_y
  and #%11110000
  adc #$10
  sta hero_y
  lda hero_y+1
  adc #$00
  sta hero_y+1

  jmp no_collision
y_ejection_larger_so_eject_x:

  ;eject hero to align with metatile grid
  ;hero is cutting in to the right side of a tile so round up
  clc
  lda hero_x
  and #%11110000
  adc #$10
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1
  sta hero_x+1

no_collision:
  .endscope

  ;restore previous hero x and hero y from before ejection
  pla
  sta b0
  pla
  sta b1

  .scope
  lda b0
  cmp hero_y
  bne ejected
  lda b1
  cmp hero_x
  bne ejected
not_ejected:

  ;test to see if both hero x and hero y are along the worst-case
  ;diagonal (this diagonal will cause camera updates to upload both
  ;a row and a column). If so, bump the hero away from this diagonal
  ;to prevent these worst case updates.
  lda hero_x
  and #%00000111
  sta b0
  lda hero_y
  and #%00000111
  sta b1
  lda b0
  cmp b1
  bne :+

  clc
  lda hero_x
  adc #HERO_SPEED
  sta hero_x
  lda hero_x+1
  adc #$00
  sta hero_x+1

:
ejected:
  .endscope

  rts
