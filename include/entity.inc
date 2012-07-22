.ifndef ENTITY_INC
ENTITY_INC = 1

.global entity_init_all
.global entity_spawn
.global entity_update_all
.global entity_draw_all
.global entity_update_animation

ENTITY_FLAGS_ALIVE_SET     = %00000001
ENTITY_FLAGS_ALIVE_TEST    = ENTITY_FLAGS_ALIVE_SET
                             
ENTITY_FLAGS_SOLID_SET     = %00000010
ENTITY_FLAGS_SOLID_TEST    = ENTITY_FLAGS_SOLID_SET

ENTITY_FLAGS_TEAM_ISOLATE  = %00001100
ENTITY_FLAGS_TEAM_TEST     = ENTITY_FLAGS_TEAM_ISOLATE

ENTITY_FLAGS_DRAWABLE_SET  = %00010000
ENTITY_FLAGS_DRAWABLE_TEST = ENTITY_FLAGS_DRAWABLE_SET

ENTITY_TEAM_GOOD        = %00000000
ENTITY_TEAM_EVIL        = %00000100
ENTITY_TEAM_INANIMATE   = %00001000

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
