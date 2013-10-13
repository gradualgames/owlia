.linecont +
.include "hero.inc"
.include "hero_constants.inc"
.include "familiar.inc"
.include "familiar_constants.inc"
.include "bomb_constants.inc"
.include "lantern_constants.inc"
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
.include "actions.inc"
.include "entity.inc"
.include "entities.inc"
.include "map.inc"
.include "mapper.inc"

;this is just a placeholder until all techs are implemented
;so unimplemented ones can be selected from the inventory
;screen and not cause a crash.
.proc familiar_spawn_nop

  rts

.endproc

;sets the familiar to be alive and initializes the rush attack.
.segment "CODE"
.proc familiar_spawn_rush
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_RUSH_INIT
  sta familiar_state

  ;let the tech init state know to pause a few frames before passing
  ;control to the main tech state
  lda #FAMILIAR_LENGTH_BEFORE_TECH_INIT
  sta familiar_state_counter

  jsr familiar_setup_initial_location_and_direction

  jsr familiar_common_init

  rts

.endproc

;sets the familiar to be alive and initializes the fetch technique.
.segment "CODE"
.proc familiar_spawn_fetch
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_FETCH_INIT
  sta familiar_state

  ;let the tech init state know to pause a few frames before passing
  ;control to the main tech state
  lda #FAMILIAR_LENGTH_BEFORE_TECH_INIT
  sta familiar_state_counter

  jsr familiar_setup_initial_location_and_direction

  jsr familiar_common_init

  rts

.endproc

;sets the familiar to be alive and initializes the carry bomb technique.
.segment "CODE"
.proc familiar_spawn_carry_bomb
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_CARRY_BOMB_INIT
  sta familiar_state

  ;let the tech init state know to pause a few frames before passing
  ;control to the main tech state
  lda #FAMILIAR_LENGTH_BEFORE_TECH_INIT
  sta familiar_state_counter

  jsr familiar_setup_initial_location_and_direction

  jsr familiar_common_init

  ;spawn a bomb entity
  lda #entity_index_bomb
  sta b0

  lda familiar_x
  sta w0
  lda familiar_x+1
  sta w0+1
  lda familiar_y
  sta w1
  lda familiar_y+1
  sta w1+1

  jsr entity_spawn

  stx familiar_param_carry_bomb_entity_index

  rts

.endproc

;sets the familiar to be alive and initializes the carry lantern technique.
.segment "CODE"
.proc familiar_spawn_carry_lantern
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_CARRY_LANTERN_INIT
  sta familiar_state

  jsr familiar_setup_initial_location_and_direction

  ;spawn a lantern entity
  lda #entity_index_lantern
  sta b0

  lda familiar_x
  sta w0
  lda familiar_x+1
  sta w0+1
  lda familiar_y
  sta w1
  lda familiar_y+1
  sta w1+1

  jsr entity_spawn

  stx familiar_param_carry_lantern_entity_index

  rts

.endproc

;sets the familiar to be alive and initializes the carry hero technique.
.segment "CODE"
.proc familiar_spawn_carry_hero
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_CARRY_HERO_INIT
  sta familiar_state

  sec
  lda familiar_param_destination_y
  sbc #(FAMILIAR_HEIGHT)
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  sbc #0
  sta familiar_param_destination_y+1

  lda hero_x
  sta familiar_x
  lda hero_x+1
  sta familiar_x+1

  sec
  lda hero_y
  sbc #FAMILIAR_HEIGHT
  sta familiar_y
  lda hero_y+1
  sbc #0
  sta familiar_y+1

  lda hero_direction
  sta familiar_direction

  rts

.endproc

;sets the familiar to be alive and initializes the shield technique.
.segment "CODE"
.proc familiar_spawn_shield
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_SHIELD_INIT
  sta familiar_state

  jsr familiar_setup_initial_location_and_direction

  rts

.endproc

;sets the familiar to be alive and initializes the homing technique.
.segment "CODE"
.proc familiar_spawn_homing
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:

  lda familiar_flags
  ora #FAMILIAR_FLAGS_ALIVE_SET
  sta familiar_flags

  lda #FAMILIAR_STATE_HOMING_INIT
  sta familiar_state

  ;let the tech init state know to pause a few frames before passing
  ;control to the main tech state
  lda #FAMILIAR_LENGTH_BEFORE_TECH_INIT
  sta familiar_state_counter

  jsr familiar_setup_initial_location_and_direction

  jsr familiar_common_init

  rts

.endproc

.segment "CODE"
.proc familiar_setup_initial_location_and_direction
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:

  ;parameterize the familiar's location and direction
  ldy hero_direction
  clc
  lda hero_x
  adc familiar_spawn_offset_x_lo,y
  sta familiar_x
  lda hero_x+1
  adc familiar_spawn_offset_x_hi,y
  sta familiar_x+1

  clc
  lda hero_y
  adc familiar_spawn_offset_y_lo,y
  sta familiar_y
  lda hero_y+1
  adc familiar_spawn_offset_y_hi,y
  sta familiar_y+1

  lda hero_direction
  sta familiar_direction

  rts

.endproc

;informs the familiar that it hit an entity that wants to be fetched
;back to the hero.
.segment "CODE"
.proc familiar_fetch_return_to_hero

  lda #FAMILIAR_STATE_FETCH_HOME_IN_TO_HERO
  sta familiar_state
  rts

.endproc

;informs the familiar that it hit an enemy.
.segment "CODE"
.proc familiar_hit_enemy

  ;home back in to the hero
  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

  rts

.endproc

.segment "CODE"
.proc familiar_calculate_screen_coordinates
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:
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

.segment "CODE"
.proc align_familiar_if_occluded_by_textbox
  define_trampoline #FAMILIAR_BANK
.segment "ROM03"
impl:
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
.segment "CODE"
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
  sta chr_group_offset

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

  switch_bank_ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_draw_animation
familiar_not_alive:

  rts

.endproc

.segment "ROM03"
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

familiar_spawn_offset_x_lo:
  .byte 0, 0, 0, 0

familiar_spawn_offset_x_hi:
  .byte 0, 0, 0, 0

familiar_spawn_offset_y_lo:
  .byte 0, 0, 1, $ff

familiar_spawn_offset_y_hi:
  .byte 0, 0, 0, $ff

familiar_direction_speed_x_lo:
  .byte <FAMILIAR_SPEED, <(-FAMILIAR_SPEED), 0, 0

familiar_direction_speed_x_hi:
  .byte >FAMILIAR_SPEED, >(-FAMILIAR_SPEED), 0, 0

familiar_direction_speed_y_lo:
  .byte 0, 0, <FAMILIAR_SPEED, <(-FAMILIAR_SPEED)

familiar_direction_speed_y_hi:
  .byte 0, 0, >FAMILIAR_SPEED, >(-FAMILIAR_SPEED)

familiar_carry_bomb_direction_speed_x_lo:
  .byte 0, 0, 0, 0

familiar_carry_bomb_direction_speed_x_hi:
  .byte FAMILIAR_CARRY_BOMB_SPEED, -FAMILIAR_CARRY_BOMB_SPEED, 0, 0

familiar_carry_bomb_direction_speed_y_lo:
  .byte 0, 0, 0, 0

familiar_carry_bomb_direction_speed_y_hi:
  .byte 0, 0, FAMILIAR_CARRY_BOMB_SPEED, -FAMILIAR_CARRY_BOMB_SPEED

familiar_direction_change_init:
  .byte $ff, $ff, 0, 0

.define familiar_states \
    familiar_state_rush_init, \
    familiar_state_rush, \
    familiar_state_home_in_to_hero, \
    familiar_state_fetch_init, \
    familiar_state_fetch, \
    familiar_state_fetch_home_in_to_hero, \
    familiar_state_carry_bomb_init, \
    familiar_state_carry_bomb, \
    familiar_state_carry_bomb_home_in_to_hero, \
    familiar_state_carry_lantern_init, \
    familiar_state_carry_lantern, \
    familiar_state_carry_hero_init, \
    familiar_state_carry_hero, \
    familiar_state_shield_init, \
    familiar_state_shield, \
    familiar_state_homing_init, \
    familiar_state_homing

familiar_lo:
  .lobytes familiar_states

familiar_hi:
  .hibytes familiar_states

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

  ;initialize action rect2
  lda #ACTION_NOP
  sta entity_action_rect2_action
  lda familiar_x
  sta entity_action_rect2_x
  lda familiar_x+1
  sta entity_action_rect2_x+1
  lda familiar_y
  sta entity_action_rect2_y
  lda familiar_y+1
  sta entity_action_rect2_y+1
  lda familiar_width
  sta entity_action_rect2_width
  lda familiar_height
  sta entity_action_rect2_height

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

  ;reset direction change bit tally with all "tried to
  ;change based on X" or "tried to change based on Y"
  ;flags based on current direction. This ensures that
  ;the familiar will change direction immediately when
  ;first homing into the hero, but then continue to tally
  ;up requested direction changes and preserve the stabilization
  ;that this tally provides as the familiar gets closer to the
  ;hero.
  lda familiar_direction_change_init,y
  sta familiar_direction_change

  ;reset animation object
  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_reset_animation

  ;load sprite group offset for the familiar
  lda #sprite_chr_group_index_familiar
  tay
  lda sprite_chr_group_offsets,y
  sta familiar_sprite_group_offset

  ;initialize fine x and y coordinates
  lda #0
  sta familiar_x_fine
  sta familiar_y_fine

  rts

.endproc

;****************************************************************
;This state initializes the rush owl tech. This tech just moves
;the owl in a straight line in the direction the hero was facing,
;attacking any enemy in its way and then returning to the hero.
;****************************************************************
.proc familiar_state_rush_init

  dec familiar_state_counter
  bne not_ready_yet

  jsr familiar_play_flap_sound

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

  ;set the initial state counter
  lda #FAMILIAR_STATE_RUSH_LENGTH
  sta familiar_state_counter

  ;done initializing, set main state
  lda #FAMILIAR_STATE_RUSH
  sta familiar_state
not_ready_yet:

  rts

.endproc

;****************************************************************
;This state performs the rush owl tech and then transitions to
;the home-in-to-hero state.
;****************************************************************
.proc familiar_state_rush

  jsr familiar_move

  jsr familiar_add_shadow_spot

  ;make action rect active
  lda #ACTION_ATTACK
  sta entity_action_rect2_action

  lda familiar_x
  sta entity_action_rect2_x
  lda familiar_x+1
  sta entity_action_rect2_x+1
  lda familiar_y
  sta entity_action_rect2_y
  lda familiar_y+1
  sta entity_action_rect2_y+1
  lda familiar_width
  sta entity_action_rect2_width
  lda familiar_height
  sta entity_action_rect2_height

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation

  dec familiar_state_counter
  bne state_counter_not_zero

  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

state_counter_not_zero:

  rts

.endproc

;****************************************************************
;This state just calls through to some common logic for making
;the owl fly back to the hero in a convincing looking way.
;****************************************************************
.proc familiar_state_home_in_to_hero

  jsr familiar_prepare_distance_to_hero_velocity
  jsr familiar_kill_if_close_to_hero
  jsr familiar_home_in_to_goal
  jsr familiar_add_shadow_spot

  rts

.endproc

;****************************************************************
;This state initializes the fetch owl tech. This tech sends the
;owl out to collect any fetchable entity that it might contact.
;Fetchable entities are responsible for informing the familiar
;that they have been contacted and then setting the fetched enti-
;ty index so the familiar knows what to carry back to the hero.
;****************************************************************
.proc familiar_state_fetch_init

  dec familiar_state_counter
  bne not_ready_yet

  jsr familiar_play_flap_sound

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

  ;set the initial state counter
  lda #FAMILIAR_STATE_FETCH_LENGTH
  sta familiar_state_counter

  ;done initializing, set main state
  lda #FAMILIAR_STATE_FETCH
  sta familiar_state

  ;clear fetched entity index
  lda #$ff
  sta familiar_param_fetched_entity_index
not_ready_yet:

  rts

.endproc

;****************************************************************
;This state just flies the familiar until a counter reaches zero,
;after which it transitions to the fetch-home-in-to-hero state,
;which homes in WHILE carrying any fetched item that may have
;been picked up.
;****************************************************************
.proc familiar_state_fetch

  jsr familiar_move

  jsr familiar_add_shadow_spot

  lda #ACTION_FETCH
  sta entity_action_rect2_action

  lda familiar_x
  sta entity_action_rect2_x
  lda familiar_x+1
  sta entity_action_rect2_x+1
  lda familiar_y
  sta entity_action_rect2_y
  lda familiar_y+1
  sta entity_action_rect2_y+1
  lda familiar_width
  sta entity_action_rect2_width
  lda familiar_height
  sta entity_action_rect2_height

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation

  dec familiar_state_counter
  bne state_counter_not_zero

  lda #FAMILIAR_STATE_FETCH_HOME_IN_TO_HERO
  sta familiar_state

state_counter_not_zero:

  rts

.endproc

;****************************************************************
;This state moves a fetched entity along with the familiar as it
;homes back into the hero, but only if a fetched entity was
;found. A value of $ff indicates that there was no fetched enti-
;ty.
;****************************************************************
.proc familiar_state_fetch_home_in_to_hero

  jsr familiar_prepare_distance_to_hero_velocity
  jsr familiar_kill_if_close_to_hero
  jsr familiar_home_in_to_goal
  jsr familiar_add_shadow_spot

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_TEST
  bne familiar_still_alive

  ;clear the fetched entity index if familiar died getting close to hero
  lda #$ff
  sta familiar_param_fetched_entity_index

familiar_still_alive:

  ;now make the fetched entity match the familiar's coordinates if there is an entity
  ;being fetched and that entity is alive
  ldx familiar_param_fetched_entity_index
  bmi no_fetched_entity
  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_TEST
  beq no_fetched_entity

  clc
  lda familiar_x
  adc familiar_param_fetched_entity_x_offset
  sta entity_x_lo,x
  lda familiar_x+1
  adc #$00
  sta entity_x_hi,x

  clc
  lda familiar_y
  adc familiar_param_fetched_entity_y_offset
  sta entity_y_lo,x
  lda familiar_y+1
  adc #$00
  sta entity_y_hi,x

no_fetched_entity:

  rts

.endproc

;****************************************************************
;This state initializes the carry bomb technique. It is very
;similar to the fetch technique instead this time the item is
;carried from the beginning of the technique and it uses up bomb
;inventory.
;****************************************************************
.proc familiar_state_carry_bomb_init

  dec familiar_state_counter
  bne not_ready_yet

  jsr familiar_play_flap_sound

  ;initialize x and y velocity
  ldy familiar_direction
  lda familiar_carry_bomb_direction_speed_x_lo,y
  sta familiar_x_velocity
  lda familiar_carry_bomb_direction_speed_x_hi,y
  sta familiar_x_velocity+1

  lda familiar_carry_bomb_direction_speed_y_lo,y
  sta familiar_y_velocity
  lda familiar_carry_bomb_direction_speed_y_hi,y
  sta familiar_y_velocity+1

  ;set the default return state for carry bomb. If the bomb can't
  ;be dropped this value will be swapped out for a state that brings
  ;the bomb back to the player and drops it
  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_param_carry_bomb_return_state

  ;set the initial state counter
  lda #FAMILIAR_STATE_CARRY_BOMB_LENGTH
  sta familiar_state_counter

  ;done initializing, set main state
  lda #FAMILIAR_STATE_CARRY_BOMB
  sta familiar_state
not_ready_yet:

  rts

.endproc

;****************************************************************
;This state moves the familiar til a counter reaches zero, and
;also tells the bomb to enter its falling state when the counter
;reaches a certain value.
;****************************************************************
.proc familiar_state_carry_bomb

  jsr familiar_move

  jsr familiar_add_shadow_spot

  ;make the bomb's coordinates match that of the familiar
  .scope
  ldx familiar_param_carry_bomb_entity_index
  bmi no_bomb
  lda entity_state,x
  cmp #BOMB_STATE_CARRIED
  bne bomb_has_been_dropped
  clc
  lda familiar_x
  adc familiar_param_carry_bomb_x_offset
  sta entity_x_lo,x
  lda familiar_x+1
  adc #$00
  sta entity_x_hi,x

  clc
  lda familiar_y
  adc familiar_param_carry_bomb_y_offset
  sta entity_y_lo,x
  lda familiar_y+1
  adc #$00
  sta entity_y_hi,x
no_bomb:
bomb_has_been_dropped:
  .endscope

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation

  dec familiar_state_counter

  ;check to see if the state counter is at the frame at which we want to
  ;tell the bomb to fall.
  lda familiar_state_counter
  cmp #FAMILIAR_STATE_CARRY_BOMB_DROP_FRAME
  bne state_counter_not_at_drop_bomb_frame

  ;test to see if the bomb can be dropped here
  clc
  lda familiar_x
  adc #BOMB_CARRIED_X_OFFSET
  sta w0
  lda familiar_x+1
  adc #0
  sta w0+1

  clc
  lda familiar_y
  adc #BOMB_CARRIED_Y_OFFSET
  sta w1
  lda familiar_y+1
  adc #0
  sta w1+1

  jsr map_test_collision

  lda b0
  and #FLAG_SOLID
  bne cannot_drop_here

  ;tell the bomb to initialize its falling state
  .scope
  ldx familiar_param_carry_bomb_entity_index
  bmi no_bomb
  lda #BOMB_STATE_INIT_FALL
  sta entity_state,x

  ;make sure to give the bomb the familiar's initial velocity so it appears
  ;to have momentum from the familiar's flight
  lda familiar_x_velocity
  sta bomb_target_x_velocity_lo,x
  lda familiar_x_velocity+1
  sta bomb_target_x_velocity_hi,x

  lda familiar_y_velocity
  sta bomb_target_y_velocity_lo,x
  lda familiar_y_velocity+1
  sta bomb_target_y_velocity_hi,x
no_bomb:
  .endscope
state_counter_not_at_drop_bomb_frame:

  ;check to see if the familiar should home back into the hero.
  lda familiar_state_counter
  bne state_counter_not_zero

  lda familiar_param_carry_bomb_return_state
  sta familiar_state

state_counter_not_zero:

  rts

cannot_drop_here:

  lda #FAMILIAR_STATE_CARRY_BOMB_HOME_IN_TO_HERO
  sta familiar_param_carry_bomb_return_state

  rts

.endproc

;****************************************************************
;This state carries the bomb back to the hero if it could not be
;dropped.
;****************************************************************
.proc familiar_state_carry_bomb_home_in_to_hero

  jsr familiar_prepare_distance_to_hero_velocity
  jsr familiar_kill_if_close_to_hero
  jsr familiar_home_in_to_goal
  jsr familiar_add_shadow_spot

  ;make the bomb's coordinates match that of the familiar
  .scope
  ldx familiar_param_carry_bomb_entity_index
  bmi no_bomb
  lda entity_state,x
  cmp #BOMB_STATE_CARRIED
  bne bomb_has_been_dropped
  clc
  lda familiar_x
  adc familiar_param_carry_bomb_x_offset
  sta entity_x_lo,x
  lda familiar_x+1
  adc #$00
  sta entity_x_hi,x

  clc
  lda familiar_y
  adc familiar_param_carry_bomb_y_offset
  sta entity_y_lo,x
  lda familiar_y+1
  adc #$00
  sta entity_y_hi,x
no_bomb:
bomb_has_been_dropped:
  .endscope

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_TEST
  bne do_not_drop_bomb_yet

  ;tell the bomb to initialize its falling state
  .scope
  ldx familiar_param_carry_bomb_entity_index
  bmi no_bomb
  lda #BOMB_STATE_INIT_FALL
  sta entity_state,x

  ;make sure to give the bomb the familiar's initial velocity so it appears
  ;to have momentum from the familiar's flight
  lda familiar_x_velocity
  sta bomb_target_x_velocity_lo,x
  lda familiar_x_velocity+1
  sta bomb_target_x_velocity_hi,x

  lda familiar_y_velocity
  sta bomb_target_y_velocity_lo,x
  lda familiar_y_velocity+1
  sta bomb_target_y_velocity_hi,x
no_bomb:
  .endscope

do_not_drop_bomb_yet:

  rts

.endproc

;****************************************************************
;This state initializes the carry lantern technique.
;****************************************************************
.proc familiar_state_carry_lantern_init

  jsr familiar_common_init

  jsr familiar_play_flap_sound

  lda #FAMILIAR_STATE_CARRY_LANTERN_LENGTH
  sta familiar_state_counter

  lda #FAMILIAR_STATE_CARRY_LANTERN
  sta familiar_state

  rts

.endproc

;****************************************************************
;This state runs the carry lantern tech. The familiar continously
;follows the hero when X or Y distance exceeds a certain amount,
;all the while carrying a lantern entity spawned by the
;corresponding init state above.
;****************************************************************
.proc familiar_state_carry_lantern

  dec familiar_state_counter
  bne do_not_transition_to_return_to_hero_state

  .scope
  ldx familiar_param_carry_lantern_entity_index
  bmi no_lantern
  lda #LANTERN_STATE_REVERT_BRIGHTNESS
  sta entity_state,x
no_lantern:
  .endscope

  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

  rts

do_not_transition_to_return_to_hero_state:

  jsr familiar_prepare_distance_to_hero_velocity

  ;use b0 to count to learn whether both x and y velocities are
  ;close enough to kill the familiar.
  lda #0
  sta b0

  .scope
  lda familiar_x_velocity+1
  bmi hero_to_left
hero_to_right:
  ;velocity is positive
  .scope
  sec
  lda #FAMILIAR_FOLLOW_DISTANCE
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
  lda #FAMILIAR_FOLLOW_DISTANCE
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

  .scope
  lda familiar_y_velocity+1
  bmi hero_above
hero_below:
  ;velocity is positive
  .scope
  sec
  lda #FAMILIAR_FOLLOW_DISTANCE
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
  lda #FAMILIAR_FOLLOW_DISTANCE
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

  lda b0
  cmp #2
  bne follow_hero

  ;make the lantern's coordinates match that of the familiar
  .scope
  ldx familiar_param_carry_lantern_entity_index
  bmi no_lantern
  clc
  lda familiar_x
  adc familiar_param_carry_lantern_x_offset
  sta entity_x_lo,x
  lda familiar_x+1
  adc #$00
  sta entity_x_hi,x

  clc
  lda familiar_y
  adc familiar_param_carry_lantern_y_offset
  sta entity_y_lo,x
  lda familiar_y+1
  adc #$00
  sta entity_y_hi,x
no_lantern:
  .endscope

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation

  rts

follow_hero:

  jsr familiar_home_in_to_goal

  ;make the lantern's coordinates match that of the familiar
  .scope
  ldx familiar_param_carry_lantern_entity_index
  bmi no_lantern
  clc
  lda familiar_x
  adc familiar_param_carry_lantern_x_offset
  sta entity_x_lo,x
  lda familiar_x+1
  adc #$00
  sta entity_x_hi,x

  clc
  lda familiar_y
  adc familiar_param_carry_lantern_y_offset
  sta entity_y_lo,x
  lda familiar_y+1
  adc #$00
  sta entity_y_hi,x
no_lantern:
  .endscope

  rts

.endproc

;****************************************************************
;The following handler routines are sub-state handlers for moving
;the familiar and the hero in a nice looking arc while the
;familiar carries the hero to a destination location. It combines
;the normal homing logic with sliding the destination around.
;By homing into a moving target, which itself is sliding into
;the actual destination, a nice looking "jump" like arc is
;produced as the familiar carries the hero to the destination.
;Slightly different techniques are used to make this look
;convincing for horizontal versus vertical arcs. In fact, only
;one handler was needed for horizontal arcs. Up and down needed
;special handling.
;****************************************************************
.define familiar_arc_init_handlers \
    familiar_arc_init_handler_horizontal, \
    familiar_arc_init_handler_horizontal, \
    familiar_arc_init_handler_vertical_down, \
    familiar_arc_init_handler_vertical_up

familiar_arc_init_handlers_lo:
  .lobytes familiar_arc_init_handlers

familiar_arc_init_handlers_hi:
  .hibytes familiar_arc_init_handlers

.proc familiar_arc_init_handler_horizontal

  .scope
  ARC_SIZE = 32
  lda #ARC_SIZE
  sta familiar_state_counter

  sec
  lda familiar_param_destination_y
  sbc #ARC_SIZE
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  sbc #0
  sta familiar_param_destination_y+1
  .endscope

  rts

.endproc

.proc familiar_arc_init_handler_vertical_down

  .scope
  ;calculate y distance between familiar and goal
  sec
  lda familiar_param_destination_y
  sbc familiar_y
  sta w0
  lda familiar_param_destination_y+1
  sbc familiar_y+1
  sta w0+1

  ;calculate how far we will slide the goal by adding 16 to this
  clc
  lda w0
  adc #16
  sta w0
  sta familiar_state_counter

  ;slide the x goal over by 4 to help the arc look cool
  sec
  lda familiar_param_destination_x
  sbc #4
  sta familiar_param_destination_x
  lda familiar_param_destination_x+1
  sbc #0
  sta familiar_param_destination_x+1

  ;slide the goal by how much we calculated earlier
  sec
  lda familiar_param_destination_y
  sbc w0
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  sbc #0
  sta familiar_param_destination_y+1

  .endscope

  rts

.endproc

.proc familiar_arc_init_handler_vertical_up

  .scope
  ;calculate y distance between familiar and goal
  sec
  lda familiar_y
  sbc familiar_param_destination_y
  sta w0
  lda familiar_y+1
  sbc familiar_param_destination_y+1
  sta w0+1

  ;calculate how far we will slide the goal by adding 16 to this
  clc
  lda w0
  adc #16
  sta w0
  sta familiar_state_counter

  ;slide the x goal over by 4 to help the arc look cool
  clc
  lda familiar_param_destination_x
  adc #4
  sta familiar_param_destination_x
  lda familiar_param_destination_x+1
  adc #0
  sta familiar_param_destination_x+1

  ;slide the goal by how much we calculated earlier
  clc
  lda familiar_param_destination_y
  adc w0
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  adc #0
  sta familiar_param_destination_y+1

  .endscope

  rts

.endproc

.define familiar_arc_handlers \
    familiar_arc_handler_horizontal, \
    familiar_arc_handler_horizontal, \
    familiar_arc_handler_vertical_down, \
    familiar_arc_handler_vertical_up

familiar_arc_handlers_lo:
  .lobytes familiar_arc_handlers

familiar_arc_handlers_hi:
  .hibytes familiar_arc_handlers

.proc familiar_arc_handler_horizontal

  ;for each frames, slide the
  ;goal back into its true position. This
  ;helps create a nice arc when carrying
  ;the hero horizontally.
  .scope
  lda familiar_state_counter
  beq do_not_modify_goal
  dec familiar_state_counter

  clc
  lda familiar_param_destination_y
  adc #$01
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  adc #$00
  sta familiar_param_destination_y+1

do_not_modify_goal:
  .endscope

  rts

.endproc

.proc familiar_arc_handler_vertical_down

  ;for each frames, slide the
  ;goal back into its true position. This
  ;helps create a nice arc when carrying
  ;the hero horizontally.
  .scope
  lda familiar_state_counter
  beq do_not_modify_goal
  dec familiar_state_counter

  lda familiar_state_counter
  bne do_not_reset_x_destination
  clc
  lda familiar_param_destination_x
  adc #$04
  sta familiar_param_destination_x
  lda familiar_param_destination_x+1
  adc #$00
  sta familiar_param_destination_x+1
do_not_reset_x_destination:

  clc
  lda familiar_param_destination_y
  adc #$01
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  adc #$00
  sta familiar_param_destination_y+1

do_not_modify_goal:
  .endscope

  rts

.endproc

.proc familiar_arc_handler_vertical_up

  ;for each frames, slide the
  ;goal back into its true position. This
  ;helps create a nice arc when carrying
  ;the hero horizontally.
  .scope
  lda familiar_state_counter
  beq do_not_modify_goal
  dec familiar_state_counter

  lda familiar_state_counter
  bne do_not_reset_x_destination
  sec
  lda familiar_param_destination_x
  sbc #$04
  sta familiar_param_destination_x
  lda familiar_param_destination_x+1
  sbc #$00
  sta familiar_param_destination_x+1
do_not_reset_x_destination:

  sec
  lda familiar_param_destination_y
  sbc #$01
  sta familiar_param_destination_y
  lda familiar_param_destination_y+1
  sbc #$00
  sta familiar_param_destination_y+1

do_not_modify_goal:
  .endscope

  rts

.endproc

;****************************************************************
;This state initializes the owl carry tech. It is assumed when
;transitioning into this state that the hero has already
;transitioned into the passive "carried" state in preparation for
;the familiar transitioning into the carry state. The familiar is
;now responsible for carrying the hero to a destination, after
;which the hero is "set down" and returned to its normal walking
;state that takes input from the player.
;****************************************************************
.proc familiar_state_carry_hero_init

  jsr familiar_common_init

  jsr familiar_play_flap_sound

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

  ldy familiar_direction
  lda familiar_arc_init_handlers_lo,y
  sta w0
  lda familiar_arc_init_handlers_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  lda #FAMILIAR_STATE_CARRY_HERO
  sta familiar_state

  rts

.endproc

.proc indirect_jsr_w0
  jmp (w0)
.endproc

;****************************************************************
;This state homes the familiar into the calculated destination.
;The destination is offset from its original location by the
;arc init handlers. While the carry state is operating, the
;destination is slid back into its original location. By homing
;into this "sliding" destination, a nice arc is produced as the
;familiar carries the hero to her destination.
;****************************************************************
.proc familiar_state_carry_hero

  ldy familiar_direction
  lda familiar_arc_handlers_lo,y
  sta w0
  lda familiar_arc_handlers_hi,y
  sta w0+1
  jsr indirect_jsr_w0

  .scope
  ;calculate distance between "goal" and X coordinate
  sec
  lda familiar_param_destination_x
  sbc familiar_x
  sta familiar_x_velocity
  lda familiar_param_destination_x+1
  sbc familiar_x+1
  sta familiar_x_velocity+1

  ;do an 16 bit arithmetic left shift on this value
  asl familiar_x_velocity
  rol familiar_x_velocity+1
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
  lda familiar_param_destination_y
  sbc familiar_y
  sta familiar_y_velocity
  lda familiar_param_destination_y+1
  sbc familiar_y+1
  sta familiar_y_velocity+1

  ;do an 16 bit arithmetic left shift on this value
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  .endscope

  lda familiar_x_velocity
  ora familiar_x_velocity+1
  ora familiar_y_velocity
  ora familiar_y_velocity+1
  bne familiar_not_at_goal

  jsr hero_set_down

  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

familiar_not_at_goal:

  jsr familiar_move

  ;add a shadow spot
  clc
  lda familiar_x
  adc #$04
  sta w0
  lda familiar_x+1
  adc #$00
  sta w0+1
  clc
  lda familiar_y
  adc #$2e
  sta w1
  lda familiar_y+1
  adc #$00
  sta w1+1

  jsr sprite_add_shadow_spot

  ;make the hero (assumed to be in HERO_STATE_CARRIED)
  ;move underneath the familiar
  lda familiar_x
  sta hero_x
  lda familiar_x+1
  sta hero_x+1

  clc
  lda familiar_y
  adc #FAMILIAR_HEIGHT
  sta hero_y
  lda familiar_y+1
  adc #0
  sta hero_y+1

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation

  rts

.endproc

circle_x_lo:
.byte $14
.byte $13
.byte $10
.byte $0b
.byte $06
.byte $00
.byte $fa
.byte $f5
.byte $f0
.byte $ed
.byte $ec
.byte $ed
.byte $f0
.byte $f5
.byte $fa
.byte $00
.byte $06
.byte $0b
.byte $10
.byte $13
circle_x_hi:
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
circle_y_lo:
.byte $00
.byte $06
.byte $0b
.byte $10
.byte $13
.byte $14
.byte $13
.byte $10
.byte $0b
.byte $06
.byte $00
.byte $fa
.byte $f5
.byte $f0
.byte $ed
.byte $ec
.byte $ed
.byte $f0
.byte $f5
.byte $fa
circle_y_hi:
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff
.byte $ff

;****************************************************************
;This state initializes the shield technique. The shield tech
;produces circular movement by reading values out of a pre-
;generated lut containing points on a circle.
;****************************************************************
.proc familiar_state_shield_init

  jsr familiar_common_init

  lda #FAMILIAR_STATE_SHIELD_LENGTH
  sta familiar_state_counter

  lda #0
  sta familiar_param_shield_circle_lut_index

  ;now add shield coords onto hero to get familiar's position
  ldy familiar_param_shield_circle_lut_index
  clc
  lda hero_x
  adc circle_x_lo,y
  sta familiar_x
  lda hero_x+1
  adc circle_x_hi,y
  sta familiar_x+1

  clc
  lda hero_y
  adc circle_y_lo,y
  sta familiar_y
  lda hero_y+1
  adc circle_y_hi,y
  sta familiar_y+1

  jsr familiar_play_flap_sound

  lda #FAMILIAR_STATE_SHIELD
  sta familiar_state

  rts

.endproc

;****************************************************************
;This state looks up the next point on a circle and uses it as
;an offset from the hero.
;****************************************************************
.proc familiar_state_shield

  ;now add shield coords onto hero to get familiar's position
  ldy familiar_param_shield_circle_lut_index
  clc
  lda hero_x
  adc circle_x_lo,y
  sta familiar_x
  lda hero_x+1
  adc circle_x_hi,y
  sta familiar_x+1

  clc
  lda hero_y
  adc circle_y_lo,y
  sta familiar_y
  lda hero_y+1
  adc circle_y_hi,y
  sta familiar_y+1

  inc familiar_param_shield_circle_lut_index
  lda familiar_param_shield_circle_lut_index
  cmp #FAMILIAR_STATE_SHIELD_CIRCLE_NUMPOINTS
  bne do_not_reset_familiar_param_shield_circle_lut_index

  lda #0
  sta familiar_param_shield_circle_lut_index

do_not_reset_familiar_param_shield_circle_lut_index:

  ;make action rect active
  lda #ACTION_ATTACK
  sta entity_action_rect2_action

  lda familiar_x
  sta entity_action_rect2_x
  lda familiar_x+1
  sta entity_action_rect2_x+1
  lda familiar_y
  sta entity_action_rect2_y
  lda familiar_y+1
  sta entity_action_rect2_y+1
  lda familiar_width
  sta entity_action_rect2_width
  lda familiar_height
  sta entity_action_rect2_height

  ;make sure familiar faces same direction as hero
  lda hero_direction
  sta familiar_direction
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

  dec familiar_state_counter
  bne do_not_switch_to_home_in_to_hero

  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

do_not_switch_to_home_in_to_hero:

  jsr familiar_add_shadow_spot

  ;animate the familiar
  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation

  rts

.endproc

;****************************************************************
;This state initializes the homing tech. All it does is search
;for a live enemy to home in on and remembers its index, then
;transitions to the homing state.
;****************************************************************
.proc familiar_state_homing_init

  dec familiar_state_counter
  bne not_ready_yet

  jsr familiar_play_flap_sound

  ;make sure to clear out the entity index in case it has an old
  ;value and we can't find an enemy in the subsequent search
  lda #$ff
  sta familiar_param_homing_entity_index

  ;find an enemy to home in on
  jsr entity_find_enemy
  bmi no_enemy_found

  ;x should have index of entity to home in on here
  ;first check to see if this entity is a reasonable distance from
  ;the hero
  .scope
  sec
  lda hero_x
  sbc entity_x_lo,x
  sta w0
  lda hero_x+1
  sbc entity_x_hi,x
  sta w0+1
  bpl do_not_get_abs_value

  ;negate the negative value in w0 to get abs value
  clc
  lda w0
  eor #$ff
  adc #$01
  sta w0
  lda w0+1
  eor #$ff
  adc #$00
  sta w0+1

do_not_get_abs_value:
  .endscope

  .scope
  sec
  lda hero_y
  sbc entity_y_lo,x
  sta w1
  lda hero_y+1
  sbc entity_y_hi,x
  sta w1+1
  bpl do_not_get_abs_value

  ;negate the negative value in w1 to get abs value
  clc
  lda w1
  eor #$ff
  adc #$01
  sta w1
  lda w1+1
  eor #$ff
  adc #$00
  sta w1+1

do_not_get_abs_value:
  .endscope

  ;find out if either X or Y distance from enemy is too far
  sec
  lda w0
  sbc #FAMILIAR_HOMING_DISTANCE
  lda w0+1
  sbc #0
  bpl no_enemy_found

  sec
  lda w1
  sbc #FAMILIAR_HOMING_DISTANCE
  lda w1+1
  sbc #0
  bpl no_enemy_found

  stx familiar_param_homing_entity_index

no_enemy_found:

  lda #FAMILIAR_STATE_HOMING
  sta familiar_state
not_ready_yet:

  rts

.endproc

;****************************************************************
;This is the homing tech state. It just checks to see if the
;entity it is trying to home in on is alive and then makes the
;familiar move towards it, whilst deadly with the attack rect. If
;the entity dies on the way to attacking it, it just transitions
;to the home in to hero state.
;****************************************************************
.proc familiar_state_homing

  ldx familiar_param_homing_entity_index
  bmi homing_entity_dead
  ;calculate distance between "goal" and X coordinate
  sec
  lda entity_x_lo,x
  sbc familiar_x
  sta familiar_x_velocity
  lda entity_x_hi,x
  sbc familiar_x+1
  sta familiar_x_velocity+1

  ;calculate distance between "goal" and Y coordinate
  sec
  lda entity_y_lo,x
  sbc familiar_y
  sta familiar_y_velocity
  lda entity_y_hi,x
  sbc familiar_y+1
  sta familiar_y_velocity+1

  jsr familiar_home_in_to_goal

  jsr familiar_add_shadow_spot

  ;make action rect active
  lda #ACTION_ATTACK
  sta entity_action_rect2_action

  lda familiar_x
  sta entity_action_rect2_x
  lda familiar_x+1
  sta entity_action_rect2_x+1
  lda familiar_y
  sta entity_action_rect2_y
  lda familiar_y+1
  sta entity_action_rect2_y+1
  lda familiar_width
  sta entity_action_rect2_width
  lda familiar_height
  sta entity_action_rect2_height

  rts

homing_entity_dead:

  lda #FAMILIAR_STATE_HOME_IN_TO_HERO
  sta familiar_state

  rts

.endproc

;****************************************************************
;This routine is used by the home-in-to-hero state to determine
;when the familiar is close enough to kill (deactivate).
;uses b0
;****************************************************************
.proc familiar_kill_if_close_to_hero

  ;use b0 to count to learn whether both x and y velocities are
  ;close enough to kill the familiar.
  lda #0
  sta b0

  .scope
  lda familiar_x_velocity+1
  bmi hero_to_left
hero_to_right:
  ;velocity is positive
  .scope
  sec
  lda #FAMILIAR_KILL_DISTANCE
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
  lda #FAMILIAR_KILL_DISTANCE
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

  .scope
  lda familiar_y_velocity+1
  bmi hero_above
hero_below:
  ;velocity is positive
  .scope
  sec
  lda #FAMILIAR_KILL_DISTANCE
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
  lda #FAMILIAR_KILL_DISTANCE
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

  lda b0
  cmp #2
  bne do_not_kill_familiar

  lda familiar_flags
  and #FAMILIAR_FLAGS_ALIVE_CLEAR
  sta familiar_flags
  lda #ACTION_NOP
  sta entity_action_rect2_action

do_not_kill_familiar:

  rts

.endproc

.proc familiar_prepare_distance_to_hero_velocity

  ;calculate distance between "goal" and X coordinate
  sec
  lda hero_x
  sbc familiar_x
  sta familiar_x_velocity
  lda hero_x+1
  sbc familiar_x+1
  sta familiar_x_velocity+1

  ;calculate distance between "goal" and Y coordinate
  sec
  lda hero_y
  sbc familiar_y
  sta familiar_y_velocity
  lda hero_y+1
  sbc familiar_y+1
  sta familiar_y_velocity+1

  rts

.endproc

;****************************************************************
;This routine performs homing logic on a goal. The X and Y
;distance to the goal is expected to be placed into the x and y
;velocity for the familiar before calling this routine. Then the
;velocity is shifted to create a velocity to move towards the
;goal. It became quite sophisticated because we want the owl to
;look like it is gracefully facing the hero as it tries to fly to
;her. We infer the direction the owl should face from the
;velocity that is computed from its horizontal and vertical
;distance from the hero. However, there are some cases where the
;hero is at nearly equal vertical and horizontal distance from
;the familiar that it causes the familiar to flip between left
;and right facing animations very rapidly. To prevent this, I
;keep a rotating buffer of "direction change attempts," and
;require that a string of "trying to turn in a single direction"
;is unbroken before validating it and changing the animation of
;the familiar.
;****************************************************************
.proc familiar_home_in_to_goal

  .scope
  ;it is assumed familiar_x_velocity has been previously computed as
  ;the X distance between the familiar and the hero.
  asl familiar_x_velocity
  rol familiar_x_velocity+1
  asl familiar_x_velocity
  rol familiar_x_velocity+1
  asl familiar_x_velocity
  rol familiar_x_velocity+1
  asl familiar_x_velocity
  rol familiar_x_velocity+1
  asl familiar_x_velocity
  rol familiar_x_velocity+1
  .endscope

  .scope
  ;it is assumed familiar_y_velocity has been previously computed as
  ;the Y distance between the familiar and the hero.
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  asl familiar_y_velocity
  rol familiar_y_velocity+1
  .endscope

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

  ;update action rect, but don't change the action itself
  lda familiar_x
  sta entity_action_rect2_x
  lda familiar_x+1
  sta entity_action_rect2_x+1
  lda familiar_y
  sta entity_action_rect2_y
  lda familiar_y+1
  sta entity_action_rect2_y+1
  lda familiar_width
  sta entity_action_rect2_width
  lda familiar_height
  sta entity_action_rect2_height

  lda familiar_animation_address
  sta w2
  lda familiar_animation_address+1
  sta w2+1

  lda #<familiar_animation_object
  sta w1
  lda #>familiar_animation_object
  sta w1+1
  ldy #FAMILIAR_SPRITES_AND_ANIMATIONS_BANK
  jsr sprite_update_animation

  rts

.endproc

;****************************************************************
;This routine simply moves the familiar using its current
;velocity.
;****************************************************************
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

;a common routine for adding a shadow spot for the familiar
.proc familiar_add_shadow_spot

  ;add a shadow spot
  clc
  lda familiar_x
  adc #$04
  sta w0
  lda familiar_x+1
  adc #$00
  sta w0+1
  clc
  lda familiar_y
  adc #$1a
  sta w1
  lda familiar_y+1
  adc #$00
  sta w1+1

  jsr sprite_add_shadow_spot

  rts

.endproc

.proc familiar_play_flap_sound

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

  rts

.endproc
