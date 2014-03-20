.linecont +
.ifndef RESCUEOWL_INC
RESCUEOWL_INC = 1

.include "rescueowl_constants.inc"

.define rescueowl_inside_cage_animations \
  GreatHornedOwlInsideCage

rescueowl_inside_cage_animations_lo:
  .lobytes rescueowl_inside_cage_animations

rescueowl_inside_cage_animations_hi:
  .hibytes rescueowl_inside_cage_animations

.define rescueowl_outside_cage_animations \
  GreatHornedOwlOutsideCage

rescueowl_outside_cage_animations_lo:
  .lobytes rescueowl_outside_cage_animations

rescueowl_outside_cage_animations_hi:
  .hibytes rescueowl_outside_cage_animations

.define rescueowl_fly_away_animations \
  GreatHornedOwlFly

rescueowl_fly_away_animations_lo:
  .lobytes rescueowl_fly_away_animations

rescueowl_fly_away_animations_hi:
  .hibytes rescueowl_fly_away_animations

rescueowl_spr_chr_group_indices:
  .byte sprite_chr_group_index_greathornedowl

rescueowl_conversation_indices:
  .byte conversation_index_rescue_greathornedowl

rescueowl_earned_techs:
  .byte tech_carry_bomb

rescueowl_dungeon_exit_locations:
  .byte location_index_meadow3_dungeon_entrance

.define rescueowl_states \
  rescueowl_state_init, \
  rescueowl_state_inside_cage, \
  rescueowl_state_released_init, \
  rescueowl_state_start_conversation, \
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

  ;kill any found cage entities
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

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x
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
  tay
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

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
  sta entity_sprite_flags,x

  lda #$00
  sta rescueowl_state_counter,x

  lda #RESCUEOWL_STATE_INSIDE_CAGE
  sta entity_state,x

  rts

rescueowl_state_inside_cage:

  jsr entity_update_animation

  rts

rescueowl_state_released_init:

  lda #<silmaran_theme
  sta song_address
  lda #>silmaran_theme
  sta song_address+1
  far_call music_bank, song_initialize

  ldy rescueowl_type,x
  lda rescueowl_earned_techs,y
  sta inventory_earned_techs

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

  lda #RESCUEOWL_STATE_FLY_AWAY_INIT
  sta entity_state,x
:

  jsr entity_update_animation

  rts

rescueowl_state_fly_away_init:

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
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  jsr entity_reset_animation

  sec
  lda entity_x_lo,x
  sbc #<16
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>16
  sta entity_x_hi,x

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
  sta b0
  ndxDebugOut ndxDec8(b0)
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

.endif
