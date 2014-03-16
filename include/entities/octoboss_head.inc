.linecont +
.ifndef OCTOBOSS_HEAD_INC
OCTOBOSS_HEAD_INC = 1

.include "octoboss_legs_constants.inc"
.include "splash_constants.inc"

OCTOBOSS_HEAD_WIDTH = $17
OCTOBOSS_HEAD_HEIGHT = $17

OCTOBOSS_HEAD_SHADOW_SPOT_X_OFFSET = 8
OCTOBOSS_HEAD_SHADOW_SPOT_Y_OFFSET = 50

OCTOBOSS_HEAD_STATE_FLOAT_LENGTH = 100

OCTOBOSS_HEAD_RISE_SPEED = 1
OCTOBOSS_HEAD_STATE_RISE_LENGTH = 48

OCTOBOSS_HEAD_STATE_PAUSE_LENGTH = 70

OCTOBOSS_HEAD_ATTACKED_LENGTH = 20

OCTOBOSS_HEAD_INITIAL_HEALTH = 10

OCTOBOSS_HEAD_X_CENTER = 115
OCTOBOSS_HEAD_X_ACCELERATION = 20

OCTOBOSS_HEAD_Y_CENTER = 30
OCTOBOSS_HEAD_Y_ACCELERATION = 50

octoboss_head_x_lo = entity_x_lo
octoboss_head_x_hi = entity_x_hi
octoboss_head_y_lo = entity_y_lo
octoboss_head_y_hi = entity_y_hi
octoboss_head_state_counter = entity_local0
octoboss_head_legs_entity_index = entity_local1
octoboss_head_splash_entity_index = entity_local2
octoboss_head_x_fine = entity_local3
octoboss_head_y_fine = entity_local4
octoboss_head_x_velocity_lo = entity_local5
octoboss_head_x_velocity_hi = entity_local6
octoboss_head_y_velocity_lo = entity_local7
octoboss_head_y_velocity_hi = entity_local8
octoboss_head_attacked_counter = entity_local9
octoboss_head_health = entity_local10

.enum
OCTOBOSS_HEAD_STATE_INIT
OCTOBOSS_HEAD_STATE_RISE
OCTOBOSS_HEAD_STATE_FLOAT
OCTOBOSS_HEAD_STATE_PAUSE
OCTOBOSS_HEAD_STATE_THANKS_FOR_PLAYING_DEMO
.endenum

.define octoboss_head_states \
  octoboss_head_state_init, \
  octoboss_head_state_rise, \
  octoboss_head_state_float, \
  octoboss_head_state_pause, \
  octoboss_head_thanks_for_playing_demo

octoboss_head_lo:
  .lobytes octoboss_head_states

octoboss_head_hi:
  .hibytes octoboss_head_states

octoboss_head_update:

  entity_state_switchboard octoboss_head_lo, octoboss_head_hi

octoboss_head_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #<OctobossRise
  sta entity_animation_address_lo,x
  lda #>OctobossRise
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #OCTOBOSS_HEAD_WIDTH
  sta entity_width,x
  lda #OCTOBOSS_HEAD_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_octoboss
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  ;spawn the legs
  txa
  pha

  lda #entity_index_octoboss_legs
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

  ;remember index of the legs entity
  stx b0

  pla
  tax

  lda b0
  sta octoboss_head_legs_entity_index,x

  ;spawn the splash
  txa
  pha

  lda #entity_index_splash
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

  ;remember index of the splash entity
  stx b0

  pla
  tax

  lda b0
  sta octoboss_head_splash_entity_index,x

  ;move the splash according to its offset
  ldy octoboss_head_splash_entity_index,x
  clc
  lda entity_y_lo,y
  adc #<SPLASH_Y_OFFSET
  sta entity_y_lo,y
  lda entity_y_hi,y
  adc #>SPLASH_Y_OFFSET
  sta entity_y_hi,y

  lda #0
  sta octoboss_head_x_fine,x
  sta octoboss_head_y_fine,x
  sta octoboss_head_x_velocity_lo,x
  sta octoboss_head_x_velocity_hi,x
  sta octoboss_head_y_velocity_lo,x
  sta octoboss_head_y_velocity_hi,x

  lda #OCTOBOSS_HEAD_INITIAL_HEALTH
  sta octoboss_head_health,x

  lda #0
  sta octoboss_head_attacked_counter,x

  lda #OCTOBOSS_HEAD_STATE_RISE_LENGTH
  sta octoboss_head_state_counter,x

  lda #OCTOBOSS_HEAD_STATE_RISE
  sta entity_state,x

  rts

octoboss_head_state_rise:

  sec
  lda entity_y_lo,x
  sbc #<OCTOBOSS_HEAD_RISE_SPEED
  sta entity_y_lo,x
  lda entity_y_hi,x
  sbc #>OCTOBOSS_HEAD_RISE_SPEED
  sta entity_y_hi,x

  jsr entity_update_animation

  dec octoboss_head_state_counter,x
  bne do_not_switch_to_float_state

  ;tell the splash entity to hide itself
  ldy octoboss_head_splash_entity_index,x
  lda #SPLASH_STATE_HIDE
  sta entity_state,y

  ;tell the legs to start drawing themselves and dangle
  ldy octoboss_head_legs_entity_index,x
  lda #OCTOBOSS_LEGS_STATE_DANGLE_INIT
  sta entity_state,y

  ;move the legs to beneath the head
  jsr octoboss_head_position_legs

  jsr octoboss_head_position_shadow_spot

  lda #<OctobossHeadLook
  sta entity_animation_address_lo,x
  lda #>OctobossHeadLook
  sta entity_animation_address_hi,x

  lda #OCTOBOSS_HEAD_STATE_FLOAT_LENGTH
  sta octoboss_head_state_counter,x

  lda #OCTOBOSS_HEAD_STATE_FLOAT
  sta entity_state,x

do_not_switch_to_float_state:

  rts

octoboss_head_state_float:

  .scope
  sec
  lda octoboss_head_x_lo,x
  sbc #<OCTOBOSS_HEAD_X_CENTER
  lda octoboss_head_x_hi,x
  sbc #>OCTOBOSS_HEAD_X_CENTER
  bpl decelerate
accelerate:
  clc
  lda octoboss_head_x_velocity_lo,x
  adc #<OCTOBOSS_HEAD_X_ACCELERATION
  sta octoboss_head_x_velocity_lo,x
  lda octoboss_head_x_velocity_hi,x
  adc #>OCTOBOSS_HEAD_X_ACCELERATION
  sta octoboss_head_x_velocity_hi,x
  jmp done
decelerate:
  sec
  lda octoboss_head_x_velocity_lo,x
  sbc #<OCTOBOSS_HEAD_X_ACCELERATION
  sta octoboss_head_x_velocity_lo,x
  lda octoboss_head_x_velocity_hi,x
  sbc #>OCTOBOSS_HEAD_X_ACCELERATION
  sta octoboss_head_x_velocity_hi,x
done:
  .endscope

  .scope
  sec
  lda octoboss_head_y_lo,x
  sbc #<OCTOBOSS_HEAD_Y_CENTER
  lda octoboss_head_y_hi,x
  sbc #>OCTOBOSS_HEAD_Y_CENTER
  bpl decelerate
accelerate:
  clc
  lda octoboss_head_y_velocity_lo,x
  adc #<OCTOBOSS_HEAD_Y_ACCELERATION
  sta octoboss_head_y_velocity_lo,x
  lda octoboss_head_y_velocity_hi,x
  adc #>OCTOBOSS_HEAD_Y_ACCELERATION
  sta octoboss_head_y_velocity_hi,x
  jmp done
decelerate:
  sec
  lda octoboss_head_y_velocity_lo,x
  sbc #<OCTOBOSS_HEAD_Y_ACCELERATION
  sta octoboss_head_y_velocity_lo,x
  lda octoboss_head_y_velocity_hi,x
  sbc #>OCTOBOSS_HEAD_Y_ACCELERATION
  sta octoboss_head_y_velocity_hi,x
done:
  .endscope

  .scope
  lda octoboss_head_x_velocity_hi,x
  bmi velocity_negative
velocity_positive:
  clc
  lda octoboss_head_x_fine,x
  adc octoboss_head_x_velocity_lo,x
  sta octoboss_head_x_fine,x
  lda octoboss_head_x_lo,x
  adc octoboss_head_x_velocity_hi,x
  sta octoboss_head_x_lo,x
  lda octoboss_head_x_hi,x
  adc #0
  sta octoboss_head_x_hi,x
  jmp done
velocity_negative:
  clc
  lda octoboss_head_x_fine,x
  adc octoboss_head_x_velocity_lo,x
  sta octoboss_head_x_fine,x
  lda octoboss_head_x_lo,x
  adc octoboss_head_x_velocity_hi,x
  sta octoboss_head_x_lo,x
  lda octoboss_head_x_hi,x
  adc #$ff
  sta octoboss_head_x_hi,x
done:
  .endscope

  .scope
  lda octoboss_head_y_velocity_hi,x
  bmi velocity_negative
velocity_positive:
  clc
  lda octoboss_head_y_fine,x
  adc octoboss_head_y_velocity_lo,x
  sta octoboss_head_y_fine,x
  lda octoboss_head_y_lo,x
  adc octoboss_head_y_velocity_hi,x
  sta octoboss_head_y_lo,x
  lda octoboss_head_y_hi,x
  adc #0
  sta octoboss_head_y_hi,x
  jmp done
velocity_negative:
  clc
  lda octoboss_head_y_fine,x
  adc octoboss_head_y_velocity_lo,x
  sta octoboss_head_y_fine,x
  lda octoboss_head_y_lo,x
  adc octoboss_head_y_velocity_hi,x
  sta octoboss_head_y_lo,x
  lda octoboss_head_y_hi,x
  adc #$ff
  sta octoboss_head_y_hi,x
done:
  .endscope

  .scope
  lda octoboss_head_x_velocity_hi,x
  bmi look_left
look_right:
  lda #%00000000
  sta entity_sprite_flags,x
  jmp done
look_left:
  lda #%01000000
  sta entity_sprite_flags,x
done:
  .endscope

  jsr octoboss_head_position_legs

  jsr octoboss_head_position_shadow_spot

  jsr entity_update_animation

  dec octoboss_head_state_counter,x
  bne do_not_pause_yet

  lda #<OctobossHead
  sta entity_animation_address_lo,x
  lda #>OctobossHead
  sta entity_animation_address_hi,x

  ldy octoboss_head_legs_entity_index,x
  lda #OCTOBOSS_LEGS_STATE_PUNCH_INIT
  sta entity_state,y

  lda #OCTOBOSS_HEAD_STATE_PAUSE_LENGTH
  sta octoboss_head_state_counter,x

  lda #OCTOBOSS_HEAD_STATE_PAUSE
  sta entity_state,x

do_not_pause_yet:

  jsr octoboss_head_combat

  jsr octoboss_head_advance_attacked_state

  rts

octoboss_head_state_pause:

  jsr octoboss_head_position_legs

  jsr octoboss_head_position_shadow_spot

  jsr entity_update_animation

  dec octoboss_head_state_counter,x
  bne do_not_unpause_yet

  lda #<OctobossHeadLook
  sta entity_animation_address_lo,x
  lda #>OctobossHeadLook
  sta entity_animation_address_hi,x

  lda #OCTOBOSS_HEAD_STATE_FLOAT_LENGTH
  sta octoboss_head_state_counter,x

  lda #OCTOBOSS_HEAD_STATE_FLOAT
  sta entity_state,x

do_not_unpause_yet:

  jsr octoboss_head_combat

  jsr octoboss_head_advance_attacked_state

  rts

octoboss_head_thanks_for_playing_demo:

  dec octoboss_head_state_counter,x
  bne do_not_die_yet

  ;stop all sound
  jsr sound_stop

  .scope
  ;search for monolith entity in boss's arena and make it fall
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_monolith
  bne not_monolith

  lda #MONOLITH_STATE_FALL_USING_COLUMNS_INIT
  sta entity_state,y
  jmp done

not_monolith:

  dey
  bpl next_entity
done:
  .endscope

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

do_not_die_yet:

  rts

.proc octoboss_head_combat

  lda entity_action_rect1_action
  cmp #ACTION_ATTACK
  bne action_rect1_not_deadly

  jsr entity_test_entity_action_rect1
  bne action_rect1_not_deadly

  jsr octoboss_head_attacked

action_rect1_not_deadly:

  lda entity_action_rect2_action
  cmp #ACTION_ATTACK
  bne action_rect2_not_deadly

  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  jsr octoboss_head_attacked

  far_call #FAMILIAR_BANK, familiar_hit_enemy

action_rect2_not_deadly:

  rts

.endproc

.proc octoboss_head_attacked

  lda octoboss_head_attacked_counter,x
  bne attacked_state_machine_already_running

  ;play a sound
  txa
  pha

  lda #<sfx_hit
  sta sound_param_word_0
  lda #>sfx_hit
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  ldx #soundeffect_one
  far_call #SFX_BANK, stream_initialize

  pla
  tax

  lda #OCTOBOSS_HEAD_ATTACKED_LENGTH
  sta octoboss_head_attacked_counter,x

  dec octoboss_head_health,x
  bne entity_not_dead_yet

  jsr entity_clear_drawable

  lda #100
  sta octoboss_head_state_counter,x

  lda #OCTOBOSS_HEAD_STATE_THANKS_FOR_PLAYING_DEMO
  sta entity_state,x

  ldy octoboss_head_legs_entity_index,x
  lda #OCTOBOSS_LEGS_STATE_DIE
  sta entity_state,y

  txa
  pha

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

  pla
  tax
entity_not_dead_yet:

attacked_state_machine_already_running:

  rts

.endproc

.proc octoboss_head_advance_attacked_state

  lda octoboss_head_attacked_counter,x
  beq attacked_state_machine_not_running

  dec octoboss_head_attacked_counter,x

  lda octoboss_head_attacked_counter,x
  and #%00000011
  sta b0

  lda entity_sprite_flags,x
  and #%11111100
  ora b0
  sta entity_sprite_flags,x

  ;make the legs flash along with the head
  ldy octoboss_head_legs_entity_index,x
  lda entity_sprite_flags,y
  and #%11111100
  ora b0
  sta entity_sprite_flags,y

attacked_state_machine_not_running:

  rts

.endproc

.proc octoboss_head_position_legs

  ldy octoboss_head_legs_entity_index,x
  lda entity_x_lo,x
  sta entity_x_lo,y
  lda entity_x_hi,x
  sta entity_x_hi,y

  clc
  lda entity_y_lo,x
  adc #<OCTOBOSS_LEGS_Y_OFFSET
  sta entity_y_lo,y
  lda entity_y_hi,x
  adc #>OCTOBOSS_LEGS_Y_OFFSET
  sta entity_y_hi,y

  rts

.endproc

.proc octoboss_head_position_shadow_spot

  clc
  lda octoboss_head_x_lo,x
  adc #<OCTOBOSS_HEAD_SHADOW_SPOT_X_OFFSET
  sta w0
  lda octoboss_head_x_hi,x
  adc #>OCTOBOSS_HEAD_SHADOW_SPOT_X_OFFSET
  sta w0+1

  clc
  lda octoboss_head_y_lo,x
  adc #<OCTOBOSS_HEAD_SHADOW_SPOT_Y_OFFSET
  sta w1
  lda octoboss_head_y_hi,x
  adc #>OCTOBOSS_HEAD_SHADOW_SPOT_Y_OFFSET
  sta w1+1

  jsr sprite_add_shadow_spot

  rts

.endproc

.endif
