.ifndef AREAS_INC
AREAS_INC = 1

.struct area
  music_bank .byte
  entities_bank .byte
  map_bank .byte
  sprites_and_animations_bank .byte
  bg_chr_bank .byte
  sprite_chr_bank .byte
  camera_start_x .word
  camera_start_y .word
  camera_start_scroll_x .byte
  camera_start_scroll_y .byte
  bg_chr_address .word
  entity_types_address .word
  song_address .word
  palette_address .word
  map_address .word
  metatile_table_attributes_address .word
  metatile_table_top_left_tiles_address .word
  metatile_table_top_right_tiles_address .word
  metatile_table_bottom_left_tiles_address .word
  metatile_table_bottom_right_tiles_address .word
  big_metatile_table_top_left_address .word
  big_metatile_table_top_right_address .word
  big_metatile_table_bottom_left_address .word
  big_metatile_table_bottom_right_address .word
.endstruct

.global village_area

.endif
