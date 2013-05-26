.ifndef ENTITY_INC
ENTITY_INC = 1

.global entity_init_all
.global entity_find_enemy
.global entity_spawn
.global entity_update_all
.global entity_update_npe
.global align_entities_if_occluded_by_textbox
.global entity_calculate_screen_coordinates_all
.global entity_draw_all
.global entity_draw_npe
.global entity_reset_animation
.global entity_update_animation
.global entity_set_is_enemy
.global entity_set_drawable_unsorted
.global entity_set_drawable_sorted
.global entity_test_entity_action_rect1
.global entity_test_entity_action_rect2
.global entity_test_hero_rect
.global entity_test_familiar_rect
.global entity_change_area_brightness_trampoline

ENTITY_FLAGS_ALIVE_SET     = %00000001
ENTITY_FLAGS_ALIVE_TEST    = %00000001
ENTITY_FLAGS_ALIVE_CLEAR   = %11111110

ENTITY_FLAGS_DRAWABLE_UNSORTED_SET   = %00000010
ENTITY_FLAGS_DRAWABLE_UNSORTED_TEST  = %00000010
ENTITY_FLAGS_DRAWABLE_UNSORTED_CLEAR = %11111101

ENTITY_FLAGS_DRAWABLE_SORTED_SET   = %00000100
ENTITY_FLAGS_DRAWABLE_SORTED_TEST  = %00000100
ENTITY_FLAGS_DRAWABLE_SORTED_CLEAR = %11111011

ENTITY_FLAGS_IS_ENEMY_SET   = %00001000
ENTITY_FLAGS_IS_ENEMY_TEST  = %00001000
ENTITY_FLAGS_IS_ENEMY_CLEAR = %11110111

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
