.include "areas.inc"
.include "map_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "music_data.inc"
.include "sprites_and_animations_data.inc"
.include "entities.inc"

.segment "CODE"

;****************************************************************
;Area and location LUTs
;****************************************************************
areas_lo:
  .byte <village_area,<house1_area
  
areas_hi:
  .byte >village_area,>house1_area

locations_lo:
  .byte <village_area_house1_entrance_location, <house1_area_exit_location
locations_hi:
  .byte >village_area_house1_entrance_location, >house1_area_exit_location
  
;****************************************************************
;Area and location definitions. All location definitions are kept
;right next to the area to which they refer, for ease of editing.
;****************************************************************
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
  .word map0_chr
  .word village_entities
  .word song1
  .word village_palette
  .word village_map
  .word village_metatile_table_properties
  .word village_metatile_table_params
  .word village_metatile_table_attributes
  .word village_metatile_table_top_left_tiles
  .word village_metatile_table_top_right_tiles
  .word village_metatile_table_bottom_left_tiles
  .word village_metatile_table_bottom_right_tiles
  .word village_big_metatile_table_top_left
  .word village_big_metatile_table_top_right
  .word village_big_metatile_table_bottom_left
  .word village_big_metatile_table_bottom_right

village_area_house1_entrance_location:
  .byte area_index_village
  .word 0   ;camera_start_x .word
  .word 0   ;camera_start_y .word
  .byte 0   ;camera_scroll_start_x .byte
  .byte 232 ;camera_scroll_start_y .byte
  
house1_entities:
  .byte 1  ;count
  .byte 0

house1_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .word house1_chr
  .word house1_entities
  .word song1
  .word house1_palette
  .word house1_map
  .word house1_metatile_table_properties
  .word house1_metatile_table_params
  .word house1_metatile_table_attributes
  .word house1_metatile_table_top_left_tiles
  .word house1_metatile_table_top_right_tiles
  .word house1_metatile_table_bottom_left_tiles
  .word house1_metatile_table_bottom_right_tiles
  .word house1_big_metatile_table_top_left
  .word house1_big_metatile_table_top_right
  .word house1_big_metatile_table_bottom_left
  .word house1_big_metatile_table_bottom_right

house1_area_exit_location:
  .byte area_index_house
  .word 0   ;camera_start_x .word
  .word 0   ;camera_start_y .word
  .byte 0   ;camera_scroll_start_x .byte
  .byte 232 ;camera_scroll_start_y .byte
  
