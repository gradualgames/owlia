.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "soundengine.inc"

.segment "CODE"

;****************************************************************
;Location LUTs
;****************************************************************
locations_lo:
  .byte <village_area_house1_entrance_location, <house1_area_exit_location, <overworld_area_entrance_location
locations_hi:
  .byte >village_area_house1_entrance_location, >house1_area_exit_location, >overworld_area_entrance_location

;****************************************************************
;Location definitions.
;****************************************************************
.macro define_location area_index, camera_start_x, camera_start_y, hero_offset_x, hero_offset_y, sfx_address, sfx_channel, sfx_stream
.scope
  .byte area_index                              ;area_index .byte
  .byte $20 | ((>(16*camera_start_x) & 1) << 2) ;nametable_start_hibyte .byte
  .word (16*camera_start_x)                     ;camera_start_x .word
  .word (16*camera_start_y)                     ;camera_start_y .word
  .byte <(16*camera_start_x)                    ;camera_start_scroll_x .byte
  .byte (232 + (16*camera_start_y)) .MOD 240    ;camera_start_scroll_y .byte
  .word (16*camera_start_x+hero_offset_x)       ;hero_start_x .word
  .word (16*camera_start_y+hero_offset_y)       ;hero_start_y .word
  .word sfx_address                             ;on_enter_sfx_address .word
  .byte sfx_channel                             ;on_enter_sfx_channel .byte
  .byte sfx_stream                              ;on_enter_sfx_stream  .byte
.endscope
.endmacro

village_area_house1_entrance_location:
define_location area_index_village, 8, 6, 128, 136, sfx_door, 3, soundeffect_one

house1_area_exit_location:
define_location area_index_house, 0, 4, 128, 136, sfx_door, 3, soundeffect_one

overworld_area_entrance_location:
define_location area_index_overworld, 48, 0, 240, 24, sfx_door, 3, soundeffect_one
