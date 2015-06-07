.linecont +
.ifndef RESCUEOWL_INC
RESCUEOWL_INC = 1

.include "rescueowl_constants.inc"

.define rescueowl_inside_cage_animations \
  greathornedowl_inside_cage, \
  siberianeagleowl_perch, \
  greatgrayowl_outside_cage, \
  sawwhetowl_outside_cage, \
  barnowl_perch

rescueowl_inside_cage_animations_lo:
  .lobytes rescueowl_inside_cage_animations

rescueowl_inside_cage_animations_hi:
  .hibytes rescueowl_inside_cage_animations

.define rescueowl_outside_cage_animations \
  greathornedowl_outside_cage, \
  siberianeagleowl_perch, \
  greatgrayowl_outside_cage, \
  sawwhetowl_outside_cage, \
  barnowl_perch

rescueowl_outside_cage_animations_lo:
  .lobytes rescueowl_outside_cage_animations

rescueowl_outside_cage_animations_hi:
  .hibytes rescueowl_outside_cage_animations

.define rescueowl_fly_away_animations \
  greathornedowl_fly, \
  siberianeagleowl_fly, \
  greatgrayowl_fly, \
  sawwhetowl_fly, \
  barnowl_fly

rescueowl_fly_away_animations_lo:
  .lobytes rescueowl_fly_away_animations

rescueowl_fly_away_animations_hi:
  .hibytes rescueowl_fly_away_animations

rescueowl_spr_chr_group_indices:
  .byte sprite_chr_group_index_greathornedowl
  .byte sprite_chr_group_index_siberianeagleowl
  .byte sprite_chr_group_index_greatgrayowl
  .byte sprite_chr_group_index_sawwhetowl
  .byte sprite_chr_group_index_barnowl

rescueowl_conversation_indices:
  .byte conversation_index_rescue_greathornedowl
  .byte conversation_index_rescue_siberianeagleowl
  .byte conversation_index_rescue_greatgrayowl
  .byte conversation_index_rescue_sawwhetowl
  .byte conversation_index_rescue_barnowl

rescueowl_earned_techs:
  .byte tech_carry_bomb
  .byte tech_carry_lantern
  .byte tech_carry_adlanniel
  .byte tech_shield
  .byte tech_homing

rescueowl_dungeon_exit_locations:
  .byte location_index_tundra1_entrance
  .byte location_index_mountain1_south_entrance
  .byte location_index_island1_entrance
  .byte location_index_piratebay_entrance
  .byte location_index_tortoise_entrance

.define rescueowl_states \
  rescueowl_state_init, \
  rescueowl_state_lower_all_monoliths_and_die, \
  rescueowl_state_inside_cage, \
  rescueowl_state_released_init, \
  rescueowl_state_start_conversation, \
  rescueowl_state_fly_to_hero_init, \
  rescueowl_state_fly_to_hero, \
  rescueowl_state_fly_away_init, \
  rescueowl_state_fly_away, \
  rescueowl_state_leave_dungeon

rescueowl_lo:
  .lobytes rescueowl_states

rescueowl_hi:
  .hibytes rescueowl_states

rescueowl_update:

  entity_state_switchboard rescueowl_lo, rescueowl_hi

rescueowl_state_init:

  ;make sure that rescue owl has only been rescued once
  lda inventory_earned_techs
  ldy rescueowl_type,x
  cmp rescueowl_earned_techs,y
  bmi do_not_skip_rescueowl

  ;kill any found cage entities immediately
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_type,y
  cmp #entity_index_cage
  beq done

  dey
  bpl next_entity
done:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y
  .endscope

  lda #RESCUEOWL_STATE_LOWER_ALL_MONOLITHS_AND_DIE_LENGTH
  sta rescueowl_state_counter,x

  lda #RESCUEOWL_STATE_LOWER_ALL_MONOLITHS_AND_DIE
  sta entity_state,x

  rts

do_not_skip_rescueowl:

  jsr entity_set_drawable

  jsr entity_set_not_pausable

  ldy rescueowl_type,x
  lda rescueowl_inside_cage_animations_lo,y
  sta entity_animation_address_lo,x
  lda rescueowl_inside_cage_animations_hi,y
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #RESCUEOWL_WIDTH
  sta entity_width,x
  lda #RESCUEOWL_HEIGHT
  sta entity_height,x

  ldy rescueowl_type,x
  lda rescueowl_spr_chr_group_indices,y
  sta b0
  jsr entity_lookup_sprite_chr_offset

  clc
  lda entity_x_lo,x
  adc #<8
  sta entity_x_lo,x
  lda entity_x_hi,x
  adc #>8
  sta entity_x_hi,x

  sec
  lda entity_y_lo,x
  sbc #<8
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>8
  sta entity_y_hi,x

  lda #$00
  sta rescueowl_x_fine,x
  sta rescueowl_y_fine,x
  sta rescueowl_velocity_x_lo,x
  sta rescueowl_velocity_y_hi,x
  sta rescueowl_velocity_x_lo,x
  sta rescueowl_velocity_y_hi,x

  lda #$00
  sta entity_sprite_flags,x

  lda #$00
  sta rescueowl_state_counter,x

  lda #RESCUEOWL_STATE_INSIDE_CAGE
  sta entity_state,x

  rts

rescueowl_state_lower_all_monoliths_and_die:

  .scope
  dec rescueowl_state_counter,x
  bne do_not_die_yet

  ;lower all monoliths
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #(ENTITY_FLAGS_ALIVE_TEST)
  beq not_monolith
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith
  lda #MONOLITH_STATE_FALL_INIT
  sta entity_state,y
not_monolith:
  dey
  bpl next_entity
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_die_yet:
  .endscope

  rts

rescueowl_state_inside_cage:

  jsr entity_update_animation

  rts

rescueowl_state_released_init:

  lda #<silmaran_theme
  sta song_address
  lda #>silmaran_theme
  sta song_address+1
  far_call #SOUND_BANK, song_initialize

  ldy rescueowl_type,x
  lda rescueowl_earned_techs,y
  sta inventory_earned_techs

  ;make sure all dungeon flags are reset for the next area/dungeon
  lda #INVENTORY_DUNGEON_FLAGS_NOT_YET_ENTERED
  sta inventory_dungeon_flags

  ;take over the controller.
  jsr controller_clear
  set_controller_routine controller_nop

  ldy rescueowl_type,x
  lda rescueowl_outside_cage_animations_lo,y
  sta entity_animation_address_lo,x
  lda rescueowl_outside_cage_animations_hi,y
  sta entity_animation_address_hi,x

  jsr entity_update_animation

  lda #RESCUEOWL_TIME_TIL_CONVERSATION
  sta rescueowl_state_counter,x

  lda #RESCUEOWL_STATE_START_CONVERSATION
  sta entity_state,x

  rts

rescueowl_state_start_conversation:

  dec rescueowl_state_counter,x
  bne :+

  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  ldy rescueowl_type,x
  lda rescueowl_conversation_indices,y
  sta state_control_params+play_state_control::param

  lda #RESCUEOWL_STATE_FLY_TO_HERO_INIT
  sta entity_state,x
:

  jsr entity_update_animation

  rts

rescueowl_state_fly_to_hero_init:

  ;play a flapping sound
  lda #<sfx_flap
  sta sound_param_word_0
  lda #>sfx_flap
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  ldy rescueowl_type,x
  lda rescueowl_fly_away_animations_lo,y
  sta entity_animation_address_lo,x
  lda rescueowl_fly_away_animations_hi,y
  sta entity_animation_address_hi,x

  jsr entity_update_animation

  sec
  lda entity_x_lo,x
  sbc #<16
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>16
  sta entity_x_hi,x

  lda #RESCUEOWL_STATE_FLY_TO_HERO_LENGTH
  sta rescueowl_state_counter,x

  lda #RESCUEOWL_STATE_FLY_TO_HERO
  sta entity_state,x

  rts

rescueowl_state_fly_to_hero:

  .scope
  dec rescueowl_state_counter,x
  bne do_not_switch_to_fly_away_state

  lda #RESCUEOWL_STATE_FLY_AWAY_INIT
  sta entity_state,x

  rts

do_not_switch_to_fly_away_state:
  .endscope

  ;compute goal coordinates for homing into hero
  sec
  lda hero_x
  sbc #<16
  sta w0
  lda hero_x+1
  sbc #>16
  sta w0+1

  sec
  lda hero_y
  sbc #<16
  sta w1
  lda hero_y+1
  sbc #>16
  sta w1+1

  .scope
  ;calculate distance between "goal" and X coordinate
  sec
  lda w0
  sbc entity_x_lo,x
  sta rescueowl_velocity_x_lo,x
  lda w0+1
  sbc entity_x_hi,x
  sta rescueowl_velocity_x_hi,x

  ;do an 16 bit arithmetic left shift on this value
  asl rescueowl_velocity_x_lo,x
  rol rescueowl_velocity_x_hi,x
  asl rescueowl_velocity_x_lo,x
  rol rescueowl_velocity_x_hi,x
  asl rescueowl_velocity_x_lo,x
  rol rescueowl_velocity_x_hi,x
  asl rescueowl_velocity_x_lo,x
  rol rescueowl_velocity_x_hi,x
  .endscope

  .scope
  ;calculate distance between "goal" and Y coordinate
  sec
  lda w1
  sbc entity_y_lo,x
  sta rescueowl_velocity_y_lo,x
  lda w1+1
  sbc entity_y_hi,x
  sta rescueowl_velocity_y_hi,x

  ;do an 16 bit arithmetic left shift on this value
  asl rescueowl_velocity_y_lo,x
  rol rescueowl_velocity_y_hi,x
  asl rescueowl_velocity_y_lo,x
  rol rescueowl_velocity_y_hi,x
  asl rescueowl_velocity_y_lo,x
  rol rescueowl_velocity_y_hi,x
  asl rescueowl_velocity_y_lo,x
  rol rescueowl_velocity_y_hi,x
  .endscope

  .scope
  lda rescueowl_velocity_x_lo,x
  sta w10
  lda rescueowl_velocity_x_hi,x
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
  lda rescueowl_velocity_y_lo,x
  sta w11
  lda rescueowl_velocity_y_hi,x
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

  jsr rescueowl_move

  jsr entity_update_animation

  rts

rescueowl_state_fly_away_init:

  ;play a flapping sound
  lda #<sfx_flap
  sta sound_param_word_0
  lda #>sfx_flap
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  jsr entity_reset_animation

  ldy rescueowl_type,x
  lda rescueowl_fly_away_animations_lo,y
  sta entity_animation_address_lo,x
  lda rescueowl_fly_away_animations_hi,y
  sta entity_animation_address_hi,x

  jsr entity_update_animation

  lda #200
  sta rescueowl_state_counter,x

  lda #RESCUEOWL_STATE_FLY_AWAY
  sta entity_state,x

  rts

rescueowl_state_fly_away:

  dec rescueowl_state_counter,x
  lda rescueowl_state_counter,x
  bne :+
  lda #RESCUEOWL_STATE_LEAVE_DUNGEON
  sta entity_state,x
:

  sec
  lda entity_y_lo,x
  sbc #<RESCUEOWL_FLY_AWAY_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>RESCUEOWL_FLY_AWAY_SPEED
  sta entity_y_hi,x

  clc
  lda entity_x_lo,x
  adc #<RESCUEOWL_HERO_OFFSET_X
  sta hero_x
  lda entity_x_hi,x
  adc #>RESCUEOWL_HERO_OFFSET_X
  sta hero_x+1

  clc
  lda entity_y_lo,x
  adc #<RESCUEOWL_HERO_OFFSET_Y
  sta hero_y
  lda entity_y_hi,x
  adc #>RESCUEOWL_HERO_OFFSET_Y
  sta hero_y+1

  lda #ENTITY_DIRECTION_DOWN
  sta hero_direction

  jsr entity_update_animation

  rts

rescueowl_state_leave_dungeon:

  ;restore control to the player
  lda #$ff
  jsr controller_fill_buffer_with_accumulator
  set_controller_routine controller_read

  lda #ACTION_GOTO_LOCATION_GROUP1
  sta state_control_params+play_state_control::action
  ldy rescueowl_type,x
  lda rescueowl_dungeon_exit_locations,y
  sta state_control_params+play_state_control::param

  rts

.proc rescueowl_move

  ;add 16 bit velocity to 24 bit coordinate with sign extension
  .scope
  clc
  lda rescueowl_velocity_x_lo,x
  adc rescueowl_x_fine,x
  sta rescueowl_x_fine,x
  lda rescueowl_velocity_x_hi,x
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
  lda rescueowl_velocity_y_lo,x
  adc rescueowl_y_fine,x
  sta rescueowl_y_fine,x
  lda rescueowl_velocity_y_hi,x
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

  rts

.endproc

.endif
