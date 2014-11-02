.ifndef ENTITY_INC
ENTITY_INC = 1

.global entity_module_init
.global entity_init_all
.global entity_lookup_sprite_chr_offset
.global entity_hurt_hero
.global entity_spawn_explosion_and_drop_item
.global entity_find_enemy
.global entity_mark_all_for_kill
.global entity_kill_all_marked_for_kill
.global entity_spawn
.global entity_update_all
.global entity_update_npe
.global align_entities_if_occluded_by_textbox
.global entity_calculate_screen_coordinates_all
.global entity_draw_all
.global entity_draw_npe
.global draw_entity
.global entity_reset_animation
.global entity_update_animation
.global entity_set_is_enemy
.global entity_set_sorted
.global entity_set_drawable
.global entity_clear_drawable
.global entity_set_not_pausable
.global entity_test_entity_action_rect1
.global entity_test_entity_action_rect2
.global entity_test_hero_rect
.global entity_test_familiar_rect
.global entity_change_palette_brightness_bg_trampoline
.global entity_change_palette_brightness_spr_trampoline

ENTITY_FLAGS_ALIVE_SET       = %00000001
ENTITY_FLAGS_ALIVE_TEST      = %00000001
ENTITY_FLAGS_ALIVE_CLEAR     = %11111110

ENTITY_FLAGS_DRAWABLE_SET    = %00000010
ENTITY_FLAGS_DRAWABLE_TEST   = %00000010
ENTITY_FLAGS_DRAWABLE_CLEAR  = %11111101

ENTITY_FLAGS_IS_ENEMY_SET    = %00000100
ENTITY_FLAGS_IS_ENEMY_TEST   = %00000100
ENTITY_FLAGS_IS_ENEMY_CLEAR  = %11111011

ENTITY_FLAGS_PAUSED_SET   = %00001000
ENTITY_FLAGS_PAUSED_TEST  = %00001000
ENTITY_FLAGS_PAUSED_CLEAR = %11110111

ENTITY_FLAGS_NOT_PAUSABLE_SET    = %00010000
ENTITY_FLAGS_NOT_PAUSABLE_TEST   = %00010000
ENTITY_FLAGS_NOT_PAUSABLE_CLEAR  = %11101111

ENTITY_FLAGS_MARKED_FOR_KILL_SET   = %00100000
ENTITY_FLAGS_MARKED_FOR_KILL_TEST  = %00100000
ENTITY_FLAGS_MARKED_FOR_KILL_CLEAR = %11011111

;This enum mirrors all cardinal direction enums in every entity
;including the hero and familiar. We add a fifth value for "NONE"
;for cases such as the bomb which are motionless when they set
;the attack rect.
.enum
ENTITY_DIRECTION_RIGHT
ENTITY_DIRECTION_LEFT
ENTITY_DIRECTION_DOWN
ENTITY_DIRECTION_UP
ENTITY_DIRECTION_NONE
.endenum

.macro entity_state_switchboard jump_table_lo, jump_table_hi

  lda entity_state,x
  tay
  lda jump_table_lo,y
  sta w0
  lda jump_table_hi,y
  sta w0+1
  jmp (w0)

.endmacro

;common state machine logic for attacking the hero, getting attacked, flashing,
;counting down the knockback_counter, decrementing health, dying...there's a lot
;of stuff here =) This is expressed as a macro to give entities the flexibility
;to use different entity_local arrays for the various state variables.
.macro entity_combat attacked_counter_reset, knockback_counter_reset, attacked_counter, knockback_counter, health, direction

  .scope
  entity_advance_attacked_state knockback_counter, attacked_counter

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  jsr entity_hurt_hero

entity_not_hitting_hero:

  lda attacked_counter,x
  bne action_rect1_not_deadly
  lda entity_action_rect1_action
  cmp #ACTION_ATTACK
  bne action_rect1_not_deadly

  jsr entity_test_entity_action_rect1
  bne action_rect1_not_deadly

  .scope
  lda entity_action_rect1_direction
  cmp #ENTITY_DIRECTION_NONE
  beq do_not_set_knockback_direction
  sta direction,x
do_not_set_knockback_direction:
  .endscope

  entity_attacked attacked_counter_reset, knockback_counter_reset, attacked_counter, knockback_counter, health, direction

  rts

action_rect1_not_deadly:

  lda attacked_counter,x
  bne action_rect2_not_deadly
  lda entity_action_rect2_action
  cmp #ACTION_ATTACK
  bne action_rect2_not_deadly

  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  .scope
  lda entity_action_rect2_direction
  cmp #ENTITY_DIRECTION_NONE
  beq do_not_set_knockback_direction
  sta direction,x
do_not_set_knockback_direction:
  .endscope

  entity_attacked attacked_counter_reset, knockback_counter_reset, attacked_counter, knockback_counter, health, direction

  far_call #FAMILIAR_BANK, familiar_hit_enemy

action_rect2_not_deadly:
  .endscope

.endmacro

.macro entity_attacked attacked_counter_reset, knockback_counter_reset, attacked_counter, knockback_counter, health, direction

  .scope
  ;play a sound
  lda #<sfx_hit
  sta sound_param_word_0
  lda #>sfx_hit
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0
  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  lda attacked_counter_reset
  sta attacked_counter,x

  lda knockback_counter_reset
  sta knockback_counter,x

  .ifndef INVINCIBLE_ENEMIES
  dec health,x
  bne entity_not_dead_yet

  jsr entity_spawn_explosion_and_drop_item

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

entity_not_dead_yet:
  .endif
  .endscope

.endmacro

.macro entity_advance_attacked_state knockback_counter, attacked_counter

  .scope
  lda knockback_counter,x
  beq knockback_state_machine_not_running

  dec knockback_counter,x

knockback_state_machine_not_running:

  lda attacked_counter,x
  beq attacked_state_machine_not_running

  dec attacked_counter,x

  lda attacked_counter,x
  and #%00000011
  sta b10

  lda entity_sprite_flags,x
  and #%11111100
  ora b10
  sta entity_sprite_flags,x

attacked_state_machine_not_running:
  .endscope

.endmacro

.endif
