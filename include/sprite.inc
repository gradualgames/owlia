.ifndef SPRITE_INC
SPRITE_INC = 1

.global sprite_module_init
.global sprite_draw_metasprite
.global sprite_update_all
.global sprite_clear_all

.struct sprite_struct
  ycoord .byte
  tile .byte
  attribute .byte
  xcoord .byte
.endstruct

.endif
