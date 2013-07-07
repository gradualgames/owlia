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
.global entity_set_sorted
.global entity_set_drawable
.global entity_clear_drawable
.global entity_test_entity_action_rect1
.global entity_test_entity_action_rect2
.global entity_test_hero_rect
.global entity_test_familiar_rect
.global entity_change_palette_brightness_bg_trampoline
.global entity_change_palette_brightness_spr_trampoline
.global entity_clear_shadow_spots
.global entity_add_shadow_spot
.global entity_draw_shadow_spots
.global entity_only_draw_shadow_spots
.global entity_slide_shadow_spots

ENTITY_FLAGS_ALIVE_SET      = %00000001
ENTITY_FLAGS_ALIVE_TEST     = %00000001
ENTITY_FLAGS_ALIVE_CLEAR    = %11111110

ENTITY_FLAGS_DRAWABLE_SET   = %00000010
ENTITY_FLAGS_DRAWABLE_TEST  = %00000010
ENTITY_FLAGS_DRAWABLE_CLEAR = %11111101

ENTITY_FLAGS_IS_ENEMY_SET   = %00000100
ENTITY_FLAGS_IS_ENEMY_TEST  = %00000100
ENTITY_FLAGS_IS_ENEMY_CLEAR = %11111011

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
