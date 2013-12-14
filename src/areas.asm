.linecont +
.include "areas.inc"
.include "map_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "music_data.inc"
.include "sprites_and_animations_data.inc"
.include "entities.inc"
.include "conversation_data.inc"

.segment "ROM00"

;****************************************************************
;Area LUTs
;****************************************************************
.define areas \
    village_area, \
    house1_area, \
    inn_area, \
    store_area, \
    housebl_area, \
    housebr_area, \
    housetr_area, \
    meadow1_area, \
    meadow2_area, \
    meadow3_area, \
    dungeon_area, \
    dungeon1_boss_area

areas_lo:
  .lobytes areas

areas_hi:
  .hibytes areas

;****************************************************************
;Area definitions.
;****************************************************************
village_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word village_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
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

village_area_bg_chr_groups:
  .byte 1         ;count
  .byte BG_CHR_DATA_BANK1
  .word map0_chr

house1_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word house1_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
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

house1_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word house1_chr

housebl_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word housebl_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
  .word housebl_map
  .word housebl_metatile_table_properties
  .word housebl_metatile_table_params
  .word housebl_metatile_table_attributes
  .word housebl_metatile_table_top_left_tiles
  .word housebl_metatile_table_top_right_tiles
  .word housebl_metatile_table_bottom_left_tiles
  .word housebl_metatile_table_bottom_right_tiles
  .word housebl_big_metatile_table_top_left
  .word housebl_big_metatile_table_top_right
  .word housebl_big_metatile_table_bottom_left
  .word housebl_big_metatile_table_bottom_right

housebl_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word house1_chr

housebr_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word housebr_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
  .word housebr_map
  .word housebr_metatile_table_properties
  .word housebr_metatile_table_params
  .word housebr_metatile_table_attributes
  .word housebr_metatile_table_top_left_tiles
  .word housebr_metatile_table_top_right_tiles
  .word housebr_metatile_table_bottom_left_tiles
  .word housebr_metatile_table_bottom_right_tiles
  .word housebr_big_metatile_table_top_left
  .word housebr_big_metatile_table_top_right
  .word housebr_big_metatile_table_bottom_left
  .word housebr_big_metatile_table_bottom_right

housebr_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word house1_chr

housetr_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word housetr_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
  .word housetr_map
  .word housetr_metatile_table_properties
  .word housetr_metatile_table_params
  .word housetr_metatile_table_attributes
  .word housetr_metatile_table_top_left_tiles
  .word housetr_metatile_table_top_right_tiles
  .word housetr_metatile_table_bottom_left_tiles
  .word housetr_metatile_table_bottom_right_tiles
  .word housetr_big_metatile_table_top_left
  .word housetr_big_metatile_table_top_right
  .word housetr_big_metatile_table_bottom_left
  .word housetr_big_metatile_table_bottom_right

housetr_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word house1_chr

inn_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word inn_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
  .word inn_map
  .word inn_metatile_table_properties
  .word inn_metatile_table_params
  .word inn_metatile_table_attributes
  .word inn_metatile_table_top_left_tiles
  .word inn_metatile_table_top_right_tiles
  .word inn_metatile_table_bottom_left_tiles
  .word inn_metatile_table_bottom_right_tiles
  .word inn_big_metatile_table_top_left
  .word inn_big_metatile_table_top_right
  .word inn_big_metatile_table_bottom_left
  .word inn_big_metatile_table_bottom_right

inn_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word house1_chr

store_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word store_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
  .word store_map
  .word store_metatile_table_properties
  .word store_metatile_table_params
  .word store_metatile_table_attributes
  .word store_metatile_table_top_left_tiles
  .word store_metatile_table_top_right_tiles
  .word store_metatile_table_bottom_left_tiles
  .word store_metatile_table_bottom_right_tiles
  .word store_big_metatile_table_top_left
  .word store_big_metatile_table_top_right
  .word store_big_metatile_table_bottom_left
  .word store_big_metatile_table_bottom_right

store_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word house1_chr

meadow1_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word meadow1_area_bg_chr_groups
  .word hero_theme
  .byte $00 ;textbox_attribute
  .word meadow1_map
  .word meadow1_metatile_table_properties
  .word meadow1_metatile_table_params
  .word meadow1_metatile_table_attributes
  .word meadow1_metatile_table_top_left_tiles
  .word meadow1_metatile_table_top_right_tiles
  .word meadow1_metatile_table_bottom_left_tiles
  .word meadow1_metatile_table_bottom_right_tiles
  .word meadow1_big_metatile_table_top_left
  .word meadow1_big_metatile_table_top_right
  .word meadow1_big_metatile_table_bottom_left
  .word meadow1_big_metatile_table_bottom_right

meadow1_area_bg_chr_groups:
  .byte 5  ;count
  .byte BG_CHR_DATA_BANK1
  .word meadow_trees
  .byte BG_CHR_DATA_BANK1
  .word meadow_trees_corners
  .byte BG_CHR_DATA_BANK1
  .word meadow_grass_flowers
  .byte BG_CHR_DATA_BANK1
  .word meadow_dirt1
  .byte BG_CHR_DATA_BANK1
  .word meadow_dirt2

meadow2_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word meadow2_area_bg_chr_groups
  .word hero_theme
  .byte $00 ;textbox_attribute
  .word meadow2_map
  .word meadow2_metatile_table_properties
  .word meadow2_metatile_table_params
  .word meadow2_metatile_table_attributes
  .word meadow2_metatile_table_top_left_tiles
  .word meadow2_metatile_table_top_right_tiles
  .word meadow2_metatile_table_bottom_left_tiles
  .word meadow2_metatile_table_bottom_right_tiles
  .word meadow2_big_metatile_table_top_left
  .word meadow2_big_metatile_table_top_right
  .word meadow2_big_metatile_table_bottom_left
  .word meadow2_big_metatile_table_bottom_right

meadow2_area_bg_chr_groups:
  .byte 5  ;count
  .byte 8  ;bank
  .word meadow_trees
  .byte BG_CHR_DATA_BANK1
  .word meadow_trees_corners
  .byte BG_CHR_DATA_BANK1
  .word meadow_grass_flowers
  .byte BG_CHR_DATA_BANK1
  .word meadow_dirt1
  .byte BG_CHR_DATA_BANK1
  .word meadow_dirt2

meadow3_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word meadow3_area_bg_chr_groups
  .word hero_theme
  .byte $00 ;textbox_attribute
  .word meadow3_map
  .word meadow3_metatile_table_properties
  .word meadow3_metatile_table_params
  .word meadow3_metatile_table_attributes
  .word meadow3_metatile_table_top_left_tiles
  .word meadow3_metatile_table_top_right_tiles
  .word meadow3_metatile_table_bottom_left_tiles
  .word meadow3_metatile_table_bottom_right_tiles
  .word meadow3_big_metatile_table_top_left
  .word meadow3_big_metatile_table_top_right
  .word meadow3_big_metatile_table_bottom_left
  .word meadow3_big_metatile_table_bottom_right

meadow3_area_bg_chr_groups:
  .byte 3  ;count
  .byte BG_CHR_DATA_BANK1
  .word meadow_trees
  .byte BG_CHR_DATA_BANK1
  .word meadow_trees_corners
  .byte BG_CHR_DATA_BANK1
  .word meadow_dungeon1_entrance

dungeon_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word dungeon_area_bg_chr_groups
  .word dungeon_theme
  .byte $22 ;textbox_attribute
  .word dungeon_map
  .word dungeon_metatile_table_properties
  .word dungeon_metatile_table_params
  .word dungeon_metatile_table_attributes
  .word dungeon_metatile_table_top_left_tiles
  .word dungeon_metatile_table_top_right_tiles
  .word dungeon_metatile_table_bottom_left_tiles
  .word dungeon_metatile_table_bottom_right_tiles
  .word dungeon_big_metatile_table_top_left
  .word dungeon_big_metatile_table_top_right
  .word dungeon_big_metatile_table_bottom_left
  .word dungeon_big_metatile_table_bottom_right

dungeon_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word dungeon1_main_chr

dungeon1_boss_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word dungeon1_boss_area_bg_chr_groups
  .word dungeon_theme
  .byte $22 ;textbox_attribute
  .word dungeon1_boss_map
  .word dungeon1_boss_metatile_table_properties
  .word dungeon1_boss_metatile_table_params
  .word dungeon1_boss_metatile_table_attributes
  .word dungeon1_boss_metatile_table_top_left_tiles
  .word dungeon1_boss_metatile_table_top_right_tiles
  .word dungeon1_boss_metatile_table_bottom_left_tiles
  .word dungeon1_boss_metatile_table_bottom_right_tiles
  .word dungeon1_boss_big_metatile_table_top_left
  .word dungeon1_boss_big_metatile_table_top_right
  .word dungeon1_boss_big_metatile_table_bottom_left
  .word dungeon1_boss_big_metatile_table_bottom_right

dungeon1_boss_area_bg_chr_groups:
  .byte 2  ;count
  .byte BG_CHR_DATA_BANK1
  .word dungeon1_main_chr
  .byte BG_CHR_DATA_BANK2
  .word dungeon1_pool_chr
