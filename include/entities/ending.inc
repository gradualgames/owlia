.linecont +
.ifndef ENDING_INC
ENDING_INC = 1

ENDING_WIDTH = $0f
ENDING_HEIGHT = $0f

ENDING_STATE_TRANSITION_TO_ENDING_CUT_SCENE_LENGTH = 300

.enum
ENDING_STATE_INIT
ENDING_STATE_MAIN
ENDING_STATE_DESTROY_FORTRESS
ENDING_STATE_TRANSITION_TO_ENDING_CUT_SCENE
.endenum

define_entity_properties ending_big_explosion_index,\
                         ending_state_counter_lo,\
                         ending_state_counter_hi,\
                         ending_state_splash1_index,\
                         ending_state_splash2_index

define_lohi_tables ending, \
 {ending_state_init, \
  ending_state_main, \
  ending_state_destroy_fortress, \
  ending_state_transition_to_ending_cut_scene}

ending_update:

  entity_state_switchboard ending_lo, ending_hi

ending_state_init:

  jsr entity_set_drawable

  lda #<fortress
  sta entity_animation_address_lo,x
  lda #>fortress
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_fortress
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #entity_index_big_explosion
  sta b0

  clc
  lda entity_x_lo,x
  adc #<8
  sta w0
  lda entity_x_hi,x
  adc #>8
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  lda spawned_entity
  sta ending_big_explosion_index,x
  tay
  lda #31
  sta entity_width,y
  sta entity_height,y
  lda #32
  sta big_explosion_time_between_explosions,y
  lda #255
  sta big_explosion_length,y

  lda #255
  sta ending_state_counter_lo,x

  jsr controller_clear
  set_controller_routine controller_nop

  lda hero_flags
  and #HERO_FLAGS_DRAWABLE_CLEAR
  ora #HERO_FLAGS_HIDE_STATUS_SET
  sta hero_flags

  lda #ENDING_STATE_MAIN
  sta entity_state,x

  rts

ending_state_main:

  .scope
  dec ending_state_counter_lo,x
  bne do_not_advance_state_yet

  ldy ending_big_explosion_index,x
  lda big_explosion_time_between_explosions,y
  lsr
  sta big_explosion_time_between_explosions,y

  lda big_explosion_time_between_explosions,y
  cmp #16
  bne do_not_spawn_silmaran_carry_adlanniel_yet

  lda #entity_index_silmaran_carry_adlanniel
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

do_not_spawn_silmaran_carry_adlanniel_yet:

  lda big_explosion_time_between_explosions,y
  cmp #1
  bne do_not_advance_state_yet

  ;kill off at least two explosion entities to guarantee that two
  ;splash entities can show up
  .scope
  lda #2
  sta b0
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_explosion
  bne skip_entity
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y
  dec b0
  beq done
skip_entity:
  dey
  bpl next_entity
done:
  .endscope

  jsr ending_spawn_splashes

  lda #<tortoise_fortress_sinking
  sta entity_animation_address_lo,x
  lda #>tortoise_fortress_sinking
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ldy ending_big_explosion_index,x
  lda #25
  sta big_explosion_length,y

  lda #25
  sta ending_state_counter_lo,x

  lda #ENDING_STATE_DESTROY_FORTRESS
  sta entity_state,x
  rts

do_not_advance_state_yet:
  .endscope

  ldy ending_big_explosion_index,x
  lda #255
  sta big_explosion_length,y

  jsr entity_update_animation

  rts

ending_state_destroy_fortress:

  .scope
  dec ending_state_counter_lo,x
  bne do_not_transition_yet

  far_call #SOUND_BANK, sound_stop

  jsr ending_play_whoosh_sound

  jsr entity_clear_drawable

  lda #<ENDING_STATE_TRANSITION_TO_ENDING_CUT_SCENE_LENGTH
  sta ending_state_counter_lo,x
  lda #>ENDING_STATE_TRANSITION_TO_ENDING_CUT_SCENE_LENGTH
  sta ending_state_counter_hi,x

  lda #ENDING_STATE_TRANSITION_TO_ENDING_CUT_SCENE
  sta entity_state,x

  rts

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

ending_state_transition_to_ending_cut_scene:

  .scope
  sec
  lda ending_state_counter_lo,x
  sbc #<1
  sta ending_state_counter_lo,x
  lda ending_state_counter_hi,x
  sbc #>1
  sta ending_state_counter_hi,x

  lda ending_state_counter_lo,x
  ora ending_state_counter_hi,x

  bne do_not_transition_yet

  lda #ACTION_PLAY_CUT_SCENE
  sta state_control_params+play_state_control::action
  lda #<end_cut_scene_thanks_for_playing
  sta state_control_params+play_state_control::param
  lda #>end_cut_scene_thanks_for_playing
  sta state_control_params+play_state_control::param+1

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_transition_yet:
  .endscope

  .scope
  lda ending_state_counter_lo,x
  cmp #200
  bne do_not_erase_splashes

  ldy ending_state_splash1_index,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y
  ldy ending_state_splash2_index,x
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,y

do_not_erase_splashes:
  .endscope

  rts

.proc ending_play_whoosh_sound

  lda #<sfx_whoosh
  sta sound_param_word_0
  lda #>sfx_whoosh
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  rts

.endproc

.proc ending_spawn_splashes

  ;spawn the splash
  lda #entity_index_splash
  sta b0

  clc
  lda entity_x_lo,x
  adc #<8
  sta w0
  lda entity_x_hi,x
  adc #>8
  sta w0+1
  clc
  lda entity_y_lo,x
  adc #<32
  sta w1
  lda entity_y_hi,x
  adc #>32
  sta w1+1

  jsr entity_spawn
  lda spawned_entity
  sta ending_state_splash1_index,x

  ;spawn the splash
  lda #entity_index_splash
  sta b0

  clc
  lda entity_x_lo,x
  adc #<32
  sta w0
  lda entity_x_hi,x
  adc #>32
  sta w0+1
  clc
  lda entity_y_lo,x
  adc #<32
  sta w1
  lda entity_y_hi,x
  adc #>32
  sta w1+1

  jsr entity_spawn
  lda spawned_entity
  sta ending_state_splash2_index,x

  rts

.endproc

.endif
