.include "areas.inc"
.include "map_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "music_data.inc"
.include "sprites_and_animations_data.inc"
.include "entities.inc"

.segment "CODE"

areas_lo:
  .byte <village_area
  
areas_hi:
  .byte >village_area

village_entities:
  .byte 1  ;count
  .byte 0

village_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .word 0   ;camera_start_x .word
  .word 0   ;camera_start_y .word
  .byte 0   ;camera_scroll_start_x .byte
  .byte 232 ;camera_scroll_start_y .byte
  .word map0_chr
  .word village_entities
  .word song1
  .word palette
  .word map
  .word metatile_table_properties
  .word metatile_table_attributes
  .word metatile_table_top_left_tiles
  .word metatile_table_top_right_tiles
  .word metatile_table_bottom_left_tiles
  .word metatile_table_bottom_right_tiles
  .word big_metatile_table_top_left
  .word big_metatile_table_top_right
  .word big_metatile_table_bottom_left
  .word big_metatile_table_bottom_right
