.linecont +
.include "familiar.inc"
.include "familiar_constants.inc"
.include "ram.inc"
.include "zp.inc"
.include "sprites_and_animations_data.inc"
.include "sprite_chr_data.inc"
.include "sprite.inc"
.include "soundengine.inc"
.include "sfx_data.inc"
.include "geotests.inc"
.include "camera.inc"
.include "textbox.inc"
.include "entity.inc"

.segment "CODE"

;initializes the familiar module
.proc familiar_init

  lda #0
  sta familiar_state
  sta familiar_flags

  rts

.endproc

;sets the familiar to be alive and initializes the rush attack.
.proc familiar_spawn_rush

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_RUSH_INIT
  sta familiar_state

  rts

.endproc

;sets the familiar to be alive and initializes the fetch technique.
.proc familiar_spawn_fetch

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_FETCH_INIT
  sta familiar_state

  rts

.endproc

;tests whether the familiar is deadly.
.proc familiar_is_deadly

  lda familiar_flags
  and #FAMILIAR_FLAGS_DEADLY_TEST

  rts

.endproc

;tests whether the familiar is in the fetch state
;when the zero flag is set, this indicates the familiar is fetching.
.proc familiar_is_fetching

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_TEST
  beq familiar_not_alive
  lda familiar_state
  cmp #FAMILIAR_STATE_FETCH
  rts
familiar_not_alive:
  ;clear zero flag.
  lda #$01

  rts

.endproc

;informs the familiar that it hit an entity that wants to be fetched
;back to the hero.
.proc familiar_fetch_return_to_hero

  lda #FAMILIAR_STATE_FETCH_HOME_IN_TO_HERO
  sta familiar_state
  rts

.endproc

;informs the familiar that it hit an enemy.
.proc familiar_hit_enemy

  ;home back in to the hero
  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

  rts

.endproc

.proc familiar_calculate_screen_coordinates

  sec
  lda familiar_x
  sbc camera_x
  sta familiar_screen_x
  lda familiar_x+1
  sbc camera_x+1
  sta familiar_screen_x+1

  sec
  lda familiar_y
  sbc camera_y
  sta familiar_screen_y
  lda familiar_y+1
  sbc camera_y+1
  sta familiar_screen_y+1

  ;add camera screen origin to the screen coordinates. This is needed
  ;because the camera screen origin is not at 0,0, it is at 0,8.
  clc
  lda familiar_screen_y
  adc #CAMERA_SCREEN_ORIGIN_Y
  sta familiar_screen_y
  lda familiar_screen_y+1
  adc #$00
  sta familiar_screen_y+1

  rts

.endproc

.proc align_familiar_if_occluded_by_textbox

  ;transfer familiar rectangle to w2 = left and w3 = top and b2 = width and b3 = height
  lda familiar_screen_x
  sta w2
  lda familiar_screen_x+1
  sta w2+1
  lda familiar_screen_y
  sta w3
  lda familiar_screen_y+1
  sta w3+1
  lda familiar_width
  sta b2
  lda familiar_height
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

  lda familiar_screen_y
  and #%00000100
  bne round_up
round_down:
  lda familiar_screen_y
  and #%11111000
  sec
  sbc #$01
  sta familiar_screen_y
  jmp done
round_up:
  lda familiar_screen_y
  and #%11111000
  clc
  adc #$07
  sta familiar_screen_y
done:

does_not_intersect_textbox:
  rts

.endproc

;draws the familiar
.proc familiar_draw

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_TEST
  beq familiar_not_alive

  ;get screen coordinates
  lda familiar_screen_x
  sta w3
  lda familiar_screen_x+1
  sta w3+1

  lda familiar_screen_y
  sta w4
  lda familiar_screen_y+1
  sta w4+1

  lda familiar_sprite_group_offset
  sta sprite_group_offset

  lda familiar_sprite_flags
  sta b2

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  jsr sprite_draw_animation
familiar_not_alive:

  rts

.endproc

.define familiar_animation_addresses\
  FamiliarFlySide,\
  FamiliarFlySide,\
  FamiliarFlyDown,\
  FamiliarFlyUp

familiar_animation_addresses_lo:
  .lobytes familiar_animation_addresses

familiar_animation_addresses_hi:
  .hibytes familiar_animation_addresses

familiar_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000

familiar_direction_speed_x_lo:
  .byte 0, 0, 0, 0

familiar_direction_speed_x_hi:
  .byte FAMILIAR_SPEED, -FAMILIAR_SPEED, 0, 0

familiar_direction_speed_y_lo:
  .byte 0, 0, 0, 0

familiar_direction_speed_y_hi:
  .byte 0, 0, FAMILIAR_SPEED, -FAMILIAR_SPEED

.define familiar_states \
    familiar_state_rush_init, \
    familiar_state_rush, \
    familiar_state_home_in_to_hero, \
    familiar_state_fetch_init, \
    familiar_state_fetch, \
    familiar_state_fetch_home_in_to_hero

familiar_lo:
  .lobytes familiar_states

familiar_hi:
  .hibytes familiar_states

.segment "ROM02"

familiar_update:

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_TEST
  beq familiar_not_alive
  lda familiar_state
  tay
  lda familiar_lo,y
  sta w0
  lda familiar_hi,y
  sta w0+1
  jmp (w0)
familiar_not_alive:

  rts

;this routine contains initialization logic common to every technique.
.proc familiar_common_init

  ;initialize width and height
  lda #FAMILIAR_WIDTH
  sta familiar_width
  lda #FAMILIAR_HEIGHT
  sta familiar_height

  ;use flying animation
  ldy familiar_direction
  lda familiar_animation_addresses_lo,y
  sta familiar_animation_address
  sta w2
  lda familiar_animation_addresses_hi,y
  sta familiar_animation_address+1
  sta w2+1
  lda familiar_sprite_flags_direction,y
  sta familiar_sprite_flags

  ;reset animation object
  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  jsr sprite_reset_animation

  ;load sprite group offset for the familiar
  lda #sprite_chr_group_index_familiar
  tay
  lda sprite_chr_group_offsets,y
  sta familiar_sprite_group_offset

  ;initialize x and y velocity
  ldy familiar_direction
  lda familiar_direction_speed_x_lo,y
  sta familiar_x_velocity
  lda familiar_direction_speed_x_hi,y
  sta familiar_x_velocity+1

  lda familiar_direction_speed_y_lo,y
  sta familiar_y_velocity
  lda familiar_direction_speed_y_hi,y
  sta familiar_y_velocity+1

  ;initialize fine x and y coordinates
  lda #0
  sta familiar_x_fine
  sta familiar_y_fine

  ;play a flapping sound
  txa
  pha

  lda #<sfx_flap
  sta sound_param_word_0
  lda #>sfx_flap
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  jsr stream_initialize

  pla
  tax

  ;clear fetched entity index
  lda #$ff
  sta familiar_fetched_entity_index
  rts

.endproc

.proc familiar_state_rush_init

  jsr familiar_common_init

  ;set the initial state counter
  lda #FAMILIAR_STATE_RUSH_LENGTH
  sta familiar_state_counter

  ;done initializing, set main state
  lda #FAMILIAR_STATE_RUSH
  sta familiar_state

  rts

.endproc

.proc familiar_state_rush

  lda familiar_flags
  ora #FAMILIAR_FLAGS_DEADLY_SET
  sta familiar_flags

  jsr familiar_move

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1

  jsr sprite_update_animation

  dec familiar_state_counter
  bne state_counter_not_zero

  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

state_counter_not_zero:

  rts

.endproc

.proc familiar_state_home_in_to_hero

  jsr familiar_home_in_to_hero

  rts

.endproc

.proc familiar_state_fetch_init

  jsr familiar_common_init

  ;set the initial state counter
  lda #FAMILIAR_STATE_FETCH_LENGTH
  sta familiar_state_counter

  ;done initializing, set main state
  lda #FAMILIAR_STATE_FETCH
  sta familiar_state

  rts

.endproc

.proc familiar_state_fetch

  lda familiar_flags
  and #FAMILIAR_FLAGS_DEADLY_CLEAR
  sta familiar_flags

  jsr familiar_move

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1

  jsr sprite_update_animation

  dec familiar_state_counter
  bne state_counter_not_zero

  lda #FAMILIAR_STATE_FETCH_HOME_IN_TO_HERO
  sta familiar_state

state_counter_not_zero:

  rts

.endproc

.proc familiar_state_fetch_home_in_to_hero

  ;now make the fetched entity match the familiar's coordinates if there is an entity
  ;being fetched and that entity is alive
  ldx familiar_fetched_entity_index
  bmi no_fetched_entity
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq no_fetched_entity

  clc
  lda familiar_x
  adc familiar_fetched_entity_x_offset
  sta entity_x_lo,x
  lda familiar_x+1
  adc #$00
  sta entity_x_hi,x

  clc
  lda familiar_y
  adc familiar_fetched_entity_y_offset
  sta entity_y_lo,x
  lda familiar_y+1
  adc #$00
  sta entity_y_hi,x

no_fetched_entity:

  jsr familiar_home_in_to_hero

  rts

.endproc

.proc familiar_home_in_to_hero

  ;use b0 to count whether both X and Y are close enough
  lda #0
  sta b0

  .scope
  ;calculate distance between "goal" and X coordinate
  sec
  lda hero_x
  sbc familiar_x
  sta familiar_x_velocity
  lda hero_x+1
  sbc familiar_x+1
  sta familiar_x_velocity+1

  .scope
  bmi hero_to_left
hero_to_right:
  ;velocity is positive
  .scope
  sec
  lda #4
  sbc familiar_x_velocity
  lda #0
  sbc familiar_x_velocity+1
  bmi velocity_greater_than
velocity_less_than:
  ;x is close enough to kill the familiar
  inc b0
velocity_greater_than:
  .endscope

  jmp done
hero_to_left:
  ;velocity is negative
  .scope
  clc
  lda #4
  adc familiar_x_velocity
  lda #0
  adc familiar_x_velocity+1
  bmi velocity_greater_than
velocity_less_than:
  ;x is close enough to kill the familiar
  inc b0
velocity_greater_than:
  .endscope
done:
  .endscope

  ;do an 16 bit arithmetic left shift on this value
  asl familiar_x_velocity
  rol familiar_x_velocity+1
  asl familiar_x_velocity
  rol familiar_x_velocity+1
  asl familiar_x_velocity
  rol familiar_x_velocity+1
  .endscope

  .scope
  ;calculate distance between "goal" and Y coordinate
  sec
  lda hero_y
  sbc familiar_y
  sta familiar_y_velocity
  lda hero_y+1
  sbc familiar_y+1
  sta familiar_y_velocity+1

  .scope
  bmi hero_above
hero_below:
  ;velocity is positive
  .scope
  sec
  lda #4
  sbc familiar_y_velocity
  lda #0
  sbc familiar_y_velocity+1
  bmi velocity_greater_than
velocity_less_than:
  ;y is close enough to kill the familiar
  inc b0
velocity_greater_than:
  .endscope

  jmp done
hero_above:
  ;velocity is negative
  .scope
  clc
  lda #4
  adc familiar_y_velocity
  lda #0
  adc familiar_y_velocity+1
  bmi velocity_greater_than
velocity_less_than:
  ;y is close enough to kill the familiar
  inc b0
velocity_greater_than:
  .endscope
done:
  .endscope

  ;do an 16 bit arithmetic left shift on this value
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  .endscope

  lda b0
  cmp #2
  bne do_not_kill_familiar

  ;clear the fetched entity index
  lda #$ff
  sta familiar_fetched_entity_index

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_CLEAR
  and #FAMILIAR_FLAGS_DEADLY_CLEAR
  sta familiar_flags

do_not_kill_familiar:

  .scope
  lda familiar_x_velocity
  sta w0
  lda familiar_x_velocity+1
  sta w0+1
  bpl not_negative
  ;find absolute value
  clc
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
  lda familiar_y_velocity
  sta w1
  lda familiar_y_velocity+1
  sta w1+1
  bpl not_negative
  ;find absolute value
  clc
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
  sec
  lda w0
  sbc w1
  lda w0+1
  sbc w1+1
  bmi y_velocity_bigger
x_velocity_bigger:

  ;keep a running tally of how often we are trying to infer direction from x velocity
  ;when bits are "1" that means we're trying to change direction from x velocity
  lda #1
  ror
  rol familiar_direction_change

  ;infer direction from homing velocity
  .scope
  lda familiar_x_velocity+1
  bmi left
right:
  lda #FAMILIAR_DIRECTION_RIGHT
  sta b0
  jmp done
left:
  lda #FAMILIAR_DIRECTION_LEFT
  sta b0
done:
  .endscope

  jmp done
y_velocity_bigger:

  ;keep a running tally of how often we are trying to infer direction from y velocity
  ;when bits are "0" that means we're trying to change direction from y velocity
  lda #0
  ror
  rol familiar_direction_change

  .scope
  lda familiar_y_velocity+1
  bmi up
down:
  lda #FAMILIAR_DIRECTION_DOWN
  sta b0
  jmp done
up:
  lda #FAMILIAR_DIRECTION_UP
  sta b0
done:
  .endscope
done:
  .endscope

  ;check familiar_direction_change to see if we've been trying to change direction
  ;from x velocity or y velocity for several frames. So isolate the several lowest
  ;bits, and then check for a string of several 1's or a string of several 0's. This
  ;eliminates the "wobble" problem when the familiar gets really close to the hero
  ;and the velocities are very close to one another in value.
  .scope
  lda familiar_direction_change
  and #%01111111
  cmp #%01111111
  beq change_direction
  cmp #%00000000
  beq change_direction
  jmp do_not_change_direction
change_direction:
  lda b0
  sta familiar_direction
do_not_change_direction:
  .endscope

  ;reload animation based on direction that is inferred from current homing velocity
  ldy familiar_direction
  lda familiar_animation_addresses_lo,y
  sta familiar_animation_address
  sta w2
  lda familiar_animation_addresses_hi,y
  sta familiar_animation_address+1
  sta w2+1
  lda familiar_sprite_flags_direction,y
  sta familiar_sprite_flags

  jsr familiar_move

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1

  jsr sprite_update_animation

  rts

.endproc

familiar_move:

  ;add 16 bit velocity to 24 bit coordinate with sign extension
  .scope
  clc
  lda familiar_x_velocity
  adc familiar_x_fine
  sta familiar_x_fine
  lda familiar_x_velocity+1
  bmi sign_extend

  adc familiar_x
  sta familiar_x

  lda familiar_x+1
  adc #0
  sta familiar_x+1

  jmp done
sign_extend:

  adc familiar_x
  sta familiar_x

  lda familiar_x+1
  adc #$ff
  sta familiar_x+1
done:
  .endscope

  .scope
  clc
  lda familiar_y_velocity
  adc familiar_y_fine
  sta familiar_y_fine
  lda familiar_y_velocity+1
  bmi sign_extend

  adc familiar_y
  sta familiar_y

  lda familiar_y+1
  adc #0
  sta familiar_y+1

  jmp done
sign_extend:

  adc familiar_y
  sta familiar_y

  lda familiar_y+1
  adc #$ff
  sta familiar_y+1
done:
  .endscope

  rts
