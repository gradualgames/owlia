.ifndef AREAS_INC
AREAS_INC = 1

.struct area
  music_bank .byte
  entities_bank .byte
  map_bank .byte
  sprites_and_animations_bank .byte
  bg_chr_bank .byte
  sprite_chr_bank .byte
  bg_chr_address .word
  entity_types_address .word
  song_address .word
  palette_address .word
  map_address .word
  metatile_table_properties_address .word
  metatile_table_params_address .word
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

.struct location
  area_index .byte
  camera_start_x .word
  camera_start_y .word
  camera_start_scroll_x .byte
  camera_start_scroll_y .byte
.endstruct

;****************************************************************
;Area and location LUTs
;****************************************************************
.global areas_lo
.global areas_hi

.global locations_lo
.global locations_hi

;****************************************************************
;Area and location definitions. All location definitions are kept
;right next to the area to which they refer, for ease of editing.
;****************************************************************
.global village_area
.global village_area_house1_entrance_location

.global house1_area
.global house1_exit_location

;****************************************************************
;Constants for names of areas, to make it easy to tie things
;together in the source code
;****************************************************************
area_index_village = 0
area_index_house = 1

;****************************************************************
;Constants for names of locations, to make it easy to tie things
;together in the source code
;****************************************************************
location_index_village_house1_entrance = 0
location_index_house1_exit = 1

.endif
