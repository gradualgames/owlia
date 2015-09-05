.linecont +
.ifndef SHOOTING_GALLERY_INC
SHOOTING_GALLERY_INC = 1

.include "npc_constants.inc"

SHOOTING_GALLERY_MAX_TARGETS = 4

SHOOTING_GALLERY_GAME_TIME = 60 * 30

define_entity_properties shooting_gallery_state_counter,\
                         shooting_gallery_npc_index,\
                         shooting_gallery_timer_lo,\
                         shooting_gallery_timer_hi

.enum
SHOOTING_GALLERY_STATE_INIT
SHOOTING_GALLERY_STATE_WAIT_FOR_TEXTBOX_CONFIRM
SHOOTING_GALLERY_STATE_MAIN
.endenum

define_lohi_tables shooting_gallery, \
 {shooting_gallery_state_init, \
  shooting_gallery_state_wait_for_textbox_confirm, \
  shooting_gallery_state_main}

shooting_gallery_update:

  entity_state_switchboard shooting_gallery_lo, shooting_gallery_hi

shooting_gallery_state_init:

  jsr entity_set_not_pausable

  lda rand
  sta shooting_gallery_state_counter,x

  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_type,y
  cmp #entity_index_npc
  beq found_npc

  dey
  bne next_entity
  tya
  sta shooting_gallery_npc_index,x
found_npc:
  .endscope

  ;make sure this is in the right state before we monitor it for confirm
  lda #TEXTBOX_NO_RESULT
  sta textbox_result

  lda #SHOOTING_GALLERY_STATE_WAIT_FOR_TEXTBOX_CONFIRM
  sta entity_state,x

  rts

shooting_gallery_state_wait_for_textbox_confirm:

  .scope
  lda textbox_result
  cmp #TEXTBOX_CONFIRM
  bne do_not_transition_to_main_state

  lda #<SHOOTING_GALLERY_GAME_TIME
  sta shooting_gallery_timer_lo,x
  lda #>SHOOTING_GALLERY_GAME_TIME
  sta shooting_gallery_timer_hi,x

  ;change NPC conversation so that he doesn't start the game
  ;again until the game is done.
  ldy shooting_gallery_npc_index,x
  lda #conversation_index_target_game_during
  sta npc_conversation,y

  lda #SHOOTING_GALLERY_STATE_MAIN
  sta entity_state,x

do_not_transition_to_main_state:
  .endscope

  rts

shooting_gallery_state_main:

  .scope
  sec
  lda shooting_gallery_timer_lo,x
  sbc #<1
  sta shooting_gallery_timer_lo,x
  lda shooting_gallery_timer_hi,x
  sbc #>1
  sta shooting_gallery_timer_hi,x

  lda shooting_gallery_timer_lo,x
  ora shooting_gallery_timer_hi,x
  bne game_not_over_yet

  ;change NPC conversation back to intro for game
  ldy shooting_gallery_npc_index,x
  lda #conversation_index_target_game_intro
  sta npc_conversation,y

  ;TODO: Add logic for determining win criteria

  ;run congratulations conversation and bequeathe reward
  ; lda #ACTION_START_CONVERSATION
  ; sta state_control_params+play_state_control::action
  ; lda #conversation_index_target_game_win
  ; sta state_control_params+play_state_control::param

  ;run lose conversation
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda #conversation_index_target_game_lose
  sta state_control_params+play_state_control::param

  lda #SHOOTING_GALLERY_STATE_WAIT_FOR_TEXTBOX_CONFIRM
  sta entity_state,x

  rts

game_not_over_yet:
  .endscope

  .scope
  dec shooting_gallery_state_counter,x
  bne do_not_spawn_target

  .scope
  lda #0
  sta b0
  ldy #(MAX_ENTITIES-1)
next_entity:
  lda entity_flags,y
  and #ENTITY_FLAGS_ALIVE_TEST
  beq skip_entity
  inc b0
skip_entity:

  dey
  bpl next_entity
  .endscope

  sec
  lda #SHOOTING_GALLERY_MAX_TARGETS
  sbc b0
  bmi do_not_spawn_target

  ;choose left or right side of screen
  .scope
  lda rand
  and #%00000001
  bne odd
even:

  jsr spawn_target_left

  jmp done
odd:

  jsr spawn_target_right

done:
  .endscope

  jsr next_rand
  lda rand
  ora #1
  sta shooting_gallery_state_counter,x

do_not_spawn_target:
  .endscope

  rts

.proc spawn_target_left

  lda #entity_index_target
  sta b0

  lda #<(-16)
  sta w0
  lda #>(-16)
  sta w0+1

  lda #<48
  sta w1
  lda #>48
  sta w1+1

  jsr entity_spawn

  ldy spawned_entity
  lda #ENTITY_DIRECTION_RIGHT
  sta target_direction,y

  jsr parameterize_new_target

  rts

.endproc

.proc spawn_target_right

  lda #entity_index_target
  sta b0

  lda #<256
  sta w0
  lda #>256
  sta w0+1

  lda #<48
  sta w1
  lda #>48
  sta w1+1

  jsr entity_spawn

  ldy spawned_entity
  lda #ENTITY_DIRECTION_LEFT
  sta target_direction,y

  jsr parameterize_new_target

  rts

.endproc

.proc parameterize_new_target

  ldy spawned_entity

  jsr next_rand
  lda rand
  and #%00000001
  sta target_mode,y

  jsr next_rand
  lda rand
  and #%00000011
  sta target_type,y

  jsr next_rand
  lda rand
  and #%00000011
  ora #1
  sta target_speed,y

  jsr next_rand
  lda rand
  and #%00000111
  sta target_random_speed_mask,y

  lda #1
  sta target_health,y

  .scope
  lda target_mode,y
  cmp #TARGET_MODE_NORMAL
  beq normal
  cmp #TARGET_MODE_RANDOM_SPEED
  beq random_speed
normal:

  .scope
  lda target_speed,y
  cmp #1
  beq one
  cmp #2
  beq two
  cmp #3
  beq three
one:

  lda #<1000
  sta target_gp_lo,y
  lda #>1000
  sta target_gp_hi,y

  jmp done
two:

  lda #<3000
  sta target_gp_lo,y
  lda #>3000
  sta target_gp_hi,y

  jmp done
three:

  lda #<5000
  sta target_gp_lo,y
  lda #>5000
  sta target_gp_hi,y

done:
  .endscope

  jmp done
random_speed:

  .scope
  lda target_random_speed_mask,y
  and #%00000001
  bne one
  lda target_random_speed_mask,y
  and #%00000010
  bne two
  lda target_random_speed_mask,y
  and #%00000100
  bne three
one:

  lda #<2000
  sta target_gp_lo,y
  lda #>2000
  sta target_gp_hi,y

  jmp done
two:

  lda #<4000
  sta target_gp_lo,y
  lda #>4000
  sta target_gp_hi,y

  jmp done
three:

  lda #<8000
  sta target_gp_lo,y
  lda #>8000
  sta target_gp_hi,y

done:
  .endscope

done:
  .endscope

  rts

.endproc

.endif
