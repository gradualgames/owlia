.ifndef SPRITE_INC
SPRITE_INC = 1

.global sprite_module_init
.global sprite_draw_metasprite
.global sprite_draw_animation
.global sprite_reset_animation
.global sprite_update_animation
.global sprite_update_all
.global sprite_clear_all

.struct sprite_struct
  ycoord .byte
  tile .byte
  attribute .byte
  xcoord .byte
.endstruct

.struct animation_ram
  counter .byte
  frame .byte
.endstruct

.struct animation_rom
  frame_delay .byte
  frame_count .byte
  frames .word 128
.endstruct

.endif
