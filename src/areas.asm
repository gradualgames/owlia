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
    dungeon1_boss_area, \
    tundra1_area, \
    tundra2_area

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

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
  .byte $33 ;textbox_attribute
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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

meadow1_area_bg_chr_groups:
  .byte 4  ;count
  .byte BG_CHR_DATA_BANK1
  .word meadow1_trees
  .byte BG_CHR_DATA_BANK1
  .word meadow1_flowers
  .byte BG_CHR_DATA_BANK1
  .word meadow1_grass
  .byte BG_CHR_DATA_BANK1
  .word meadow1_trees_corners

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

meadow2_area_bg_chr_groups:
  .byte 4  ;count
  .byte BG_CHR_DATA_BANK1
  .word meadow1_trees
  .byte BG_CHR_DATA_BANK1
  .word meadow1_flowers
  .byte BG_CHR_DATA_BANK1
  .word meadow1_grass
  .byte BG_CHR_DATA_BANK1
  .word meadow1_trees_corners

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
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

meadow3_area_bg_chr_groups:
  .byte 3  ;count
  .byte BG_CHR_DATA_BANK1
  .word meadow1_trees
  .byte BG_CHR_DATA_BANK1
  .word meadow1_trees_corners
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
  .word dungeon_area_nametable_patches
  .word 0 ;attribute_patches_address

dungeon_area_bg_chr_groups:
  .byte 2  ;count
  .byte BG_CHR_DATA_BANK1
  .word dungeon1_main_chr
  .byte BG_CHR_DATA_BANK2
  .word dungeon1_stones_chr

dungeon_area_nametable_patches:
  .word dungeon_area_nametable_monolith_patch
  .word dungeon_area_nametable_keyed_monolith_patch
  .word dungeon_area_nametable_monolith_north_bg_patch
  .word dungeon_area_nametable_monolith_south_bg_patch
  .word dungeon_area_nametable_monolith_west_bg_patch
  .word dungeon_area_nametable_monolith_east_bg_patch

dungeon_area_nametable_monolith_patch:
  .byte $02,$06,$05,$06,$0d,$0e,$17,$18,$23,$24,$23,$31,$3e,$3f
dungeon_area_nametable_keyed_monolith_patch:
  .byte $02,$06,$78,$79,$7a,$7b,$17,$18,$23,$24,$23,$31,$3e,$3f
dungeon_area_nametable_monolith_north_bg_patch:
dungeon_area_nametable_monolith_south_bg_patch:
  .byte $02,$06,$75,$74,$77,$68,$75,$74,$77,$68,$75,$74,$77,$68
dungeon_area_nametable_monolith_west_bg_patch:
  .byte $02,$06,$4a,$4b,$7c,$56,$4a,$4b,$86,$87,$75,$74,$77,$68
dungeon_area_nametable_monolith_east_bg_patch:
  .byte $02,$06,$4c,$4d,$57,$80,$4c,$4d,$89,$8a,$75,$74,$77,$68

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
  .word dungeon_area_nametable_patches
  .word 0 ;attribute_patches_address

dungeon1_boss_area_bg_chr_groups:
  .byte 2  ;count
  .byte BG_CHR_DATA_BANK1
  .word dungeon1_main_chr
  .byte BG_CHR_DATA_BANK2
  .word dungeon1_pool_chr

tundra1_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word tundra1_area_bg_chr_groups
  .word hero_theme
  .byte $22 ;textbox_attribute
  .word tundra1_map
  .word tundra1_metatile_table_properties
  .word tundra1_metatile_table_params
  .word tundra1_metatile_table_attributes
  .word tundra1_metatile_table_top_left_tiles
  .word tundra1_metatile_table_top_right_tiles
  .word tundra1_metatile_table_bottom_left_tiles
  .word tundra1_metatile_table_bottom_right_tiles
  .word tundra1_big_metatile_table_top_left
  .word tundra1_big_metatile_table_top_right
  .word tundra1_big_metatile_table_bottom_left
  .word tundra1_big_metatile_table_bottom_right
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

tundra1_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK3
  .word tundra_chr

tundra2_area:
  .byte MUSIC_BANK
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word tundra2_area_bg_chr_groups
  .word hero_theme
  .byte $22 ;textbox_attribute
  .word tundra2_map
  .word tundra2_metatile_table_properties
  .word tundra2_metatile_table_params
  .word tundra2_metatile_table_attributes
  .word tundra2_metatile_table_top_left_tiles
  .word tundra2_metatile_table_top_right_tiles
  .word tundra2_metatile_table_bottom_left_tiles
  .word tundra2_metatile_table_bottom_right_tiles
  .word tundra2_big_metatile_table_top_left
  .word tundra2_big_metatile_table_top_right
  .word tundra2_big_metatile_table_bottom_left
  .word tundra2_big_metatile_table_bottom_right
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

tundra2_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK3
  .word tundra_chr
