.ifndef ENTITY_INC
ENTITY_INC = 1

.global entity_init_all
.global entity_spawn
.global entity_update_all
.global entity_draw_all
.global entity_reset_animation
.global entity_update_animation
.global entity_test_hero_attack_rect
.global entity_test_hero_rect

ENTITY_FLAGS_ALIVE_SET     = %00000001
ENTITY_FLAGS_ALIVE_TEST    = %00000001
ENTITY_FLAGS_ALIVE_CLEAR   = %11111110

ENTITY_FLAGS_SOLID_SET     = %00000010
ENTITY_FLAGS_SOLID_TEST    = %00000010

ENTITY_FLAGS_DRAWABLE_SET  = %00000100
ENTITY_FLAGS_DRAWABLE_TEST = %00000100

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
