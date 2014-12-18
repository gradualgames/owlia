.ifndef AREAS_INC
AREAS_INC = 1

AREAS_BANK = 0

.struct area
  map_bank .byte
  conversations_bank .byte
  bg_chr_groups .word
  song_address .word
  textbox_attribute .byte
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
  nametable_patches_address .word
  attribute_patches_address .word
.endstruct

;****************************************************************
;Area LUTs
;****************************************************************
.global areas_lo
.global areas_hi

;****************************************************************
;Constants for names of areas, to make it easy to tie things
;together in the source code
;****************************************************************
.enum
area_index_village
area_index_house
area_index_inn
area_index_store
area_index_housebl
area_index_housebr
area_index_housetr
area_index_meadow1
area_index_meadow2
area_index_meadow3
area_index_dungeon
area_index_dungeon1_boss
area_index_tundra1
area_index_tundra2
area_index_tundra3
area_index_dungeon2
area_index_dungeon2_boss
.endenum

.endif
