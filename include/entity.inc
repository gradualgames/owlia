.ifndef ENTITY_INC
ENTITY_INC = 1

.global entity_init_all
.global entity_spawn
.global entity_update_all
.global entity_draw_all
.global entity_reset_animation
.global entity_update_animation

ENTITY_FLAGS_ALIVE_SET     = %00000001
ENTITY_FLAGS_ALIVE_TEST    = ENTITY_FLAGS_ALIVE_SET
                             
ENTITY_FLAGS_SOLID_SET     = %00000010
ENTITY_FLAGS_SOLID_TEST    = ENTITY_FLAGS_SOLID_SET

ENTITY_FLAGS_DRAWABLE_SET  = %00000100
ENTITY_FLAGS_DRAWABLE_TEST = ENTITY_FLAGS_DRAWABLE_SET

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
