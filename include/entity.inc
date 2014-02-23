.ifndef ENTITY_INC
ENTITY_INC = 1

.global entity_init_all
.global entity_combat
.global entity_attacked
.global entity_advance_attacked_state
.global entity_hurt_hero
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

.endif
