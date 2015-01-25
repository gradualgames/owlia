.linecont +
.include "areas.inc"
.include "map_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "music_data.inc"
.include "sprites_and_animations_data.inc"
.include "entities.inc"
.include "conversation_data.inc"
.include "soundengine.inc"

.segment "ROM00"

;****************************************************************
;Area LUTs
;****************************************************************
.define areas \
    village_area, \
    house1_area, \
    housel_area, \
    houser_area, \
    housebl_area, \
    housebr_area, \
    housetr_area, \
    meadow1_area, \
    meadow2_area, \
    meadow3_area, \
    dungeon_area, \
    dungeon1_boss_area, \
    tundra1_area, \
    tundra2_area, \
    tundra3_area, \
    dungeon2_area, \
    dungeon2_boss_area, \
    mountain1_area, \
    cave_area

areas_lo:
  .lobytes areas

areas_hi:
  .hibytes areas

;****************************************************************
;Area definitions.
;****************************************************************
village_area:
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

housel_area:
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word housel_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
  .word housel_map
  .word housel_metatile_table_properties
  .word housel_metatile_table_params
  .word housel_metatile_table_attributes
  .word housel_metatile_table_top_left_tiles
  .word housel_metatile_table_top_right_tiles
  .word housel_metatile_table_bottom_left_tiles
  .word housel_metatile_table_bottom_right_tiles
  .word housel_big_metatile_table_top_left
  .word housel_big_metatile_table_top_right
  .word housel_big_metatile_table_bottom_left
  .word housel_big_metatile_table_bottom_right
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

housel_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word house1_chr

houser_area:
  .byte MAP_DATA_BANK1
  .byte CONVERSATIONS_BANK
  .word houser_area_bg_chr_groups
  .word town_theme
  .byte $00 ;textbox_attribute
  .word houser_map
  .word houser_metatile_table_properties
  .word houser_metatile_table_params
  .word houser_metatile_table_attributes
  .word houser_metatile_table_top_left_tiles
  .word houser_metatile_table_top_right_tiles
  .word houser_metatile_table_bottom_left_tiles
  .word houser_metatile_table_bottom_right_tiles
  .word houser_big_metatile_table_top_left
  .word houser_big_metatile_table_top_right
  .word houser_big_metatile_table_bottom_left
  .word houser_big_metatile_table_bottom_right
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

houser_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK1
  .word house1_chr

meadow1_area:
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
  .byte MAP_DATA_BANK1
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

tundra3_area:
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word tundra3_area_bg_chr_groups
  .word hero_theme
  .byte $22 ;textbox_attribute
  .word tundra3_map
  .word tundra3_metatile_table_properties
  .word tundra3_metatile_table_params
  .word tundra3_metatile_table_attributes
  .word tundra3_metatile_table_top_left_tiles
  .word tundra3_metatile_table_top_right_tiles
  .word tundra3_metatile_table_bottom_left_tiles
  .word tundra3_metatile_table_bottom_right_tiles
  .word tundra3_big_metatile_table_top_left
  .word tundra3_big_metatile_table_top_right
  .word tundra3_big_metatile_table_bottom_left
  .word tundra3_big_metatile_table_bottom_right
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

tundra3_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK3
  .word tundra_chr

dungeon2_area:
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word dungeon2_area_bg_chr_groups
  .word dungeon_theme
  .byte $22 ;textbox_attribute
  .word dungeon2_map
  .word dungeon2_metatile_table_properties
  .word dungeon2_metatile_table_params
  .word dungeon2_metatile_table_attributes
  .word dungeon2_metatile_table_top_left_tiles
  .word dungeon2_metatile_table_top_right_tiles
  .word dungeon2_metatile_table_bottom_left_tiles
  .word dungeon2_metatile_table_bottom_right_tiles
  .word dungeon2_big_metatile_table_top_left
  .word dungeon2_big_metatile_table_top_right
  .word dungeon2_big_metatile_table_bottom_left
  .word dungeon2_big_metatile_table_bottom_right
  .word dungeon2_area_nametable_patches
  .word 0 ;attribute_patches_address

dungeon2_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK3
  .word dungeon2_main_chr

dungeon2_area_nametable_patches:
  .word dungeon2_area_nametable_monolith_patch
  .word dungeon2_area_nametable_keyed_monolith_patch
  .word dungeon2_area_nametable_monolith_north_bg_patch
  .word dungeon2_area_nametable_monolith_south_bg_patch
  .word dungeon2_area_nametable_monolith_west_bg_patch
  .word dungeon2_area_nametable_monolith_east_bg_patch
  .word dungeon2_area_nametable_bombable_wall_corridor_patch

dungeon2_area_nametable_monolith_patch:
  .byte $02,$06,$03,$04,$0b,$0c,$16,$17,$23,$24,$2d,$2e,$35,$36
dungeon2_area_nametable_keyed_monolith_patch:
  .byte $02,$06,$53,$54,$60,$61,$16,$17,$23,$24,$2d,$2e,$35,$36
dungeon2_area_nametable_monolith_north_bg_patch:
dungeon2_area_nametable_monolith_south_bg_patch:
  .byte $02,$06,$66,$65,$5a,$59,$66,$65,$5a,$59,$66,$65,$5a,$59
dungeon2_area_nametable_monolith_west_bg_patch:
  .byte $02,$06,$6c,$6d,$69,$6a,$6c,$6d,$75,$76,$66,$65,$5a,$59
dungeon2_area_nametable_monolith_east_bg_patch:
  .byte $02,$06,$3e,$3d,$37,$38,$3e,$3d,$45,$44,$66,$65,$5a,$59

dungeon2_area_nametable_bombable_wall_corridor_patch:
  .byte $06,$0c,$01,$02,$66,$65,$05,$06,$09,$0a,$5a,$59,$0d,$0e,$14,$48
  .byte $66,$65,$57,$19,$21,$22,$5a,$59,$25,$26,$62,$63,$66,$65,$2f,$30
  .byte $69,$6a,$5a,$59,$37,$38,$6c,$6d,$66,$65,$3e,$3d,$69,$6a,$5a,$59
  .byte $37,$38,$6c,$6d,$66,$65,$3e,$3d,$75,$76,$5a,$59,$45,$44,$66,$65
  .byte $66,$65,$66,$65,$5a,$59,$5a,$59,$5a,$59

dungeon2_boss_area:
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word dungeon2_boss_area_bg_chr_groups
  .word dungeon_theme
  .byte $22 ;textbox_attribute
  .word dungeon2_boss_map
  .word dungeon2_boss_metatile_table_properties
  .word dungeon2_boss_metatile_table_params
  .word dungeon2_boss_metatile_table_attributes
  .word dungeon2_boss_metatile_table_top_left_tiles
  .word dungeon2_boss_metatile_table_top_right_tiles
  .word dungeon2_boss_metatile_table_bottom_left_tiles
  .word dungeon2_boss_metatile_table_bottom_right_tiles
  .word dungeon2_boss_big_metatile_table_top_left
  .word dungeon2_boss_big_metatile_table_top_right
  .word dungeon2_boss_big_metatile_table_bottom_left
  .word dungeon2_boss_big_metatile_table_bottom_right
  .word dungeon2_boss_area_nametable_patches
  .word 0 ;attribute_patches_address

dungeon2_boss_area_bg_chr_groups:
  .byte 2  ;count
  .byte BG_CHR_DATA_BANK3
  .word dungeon2_main_chr
  .byte BG_CHR_DATA_BANK3
  .word dungeon2_platform_chr

dungeon2_boss_area_nametable_patches:
  .word dungeon2_boss_area_nametable_monolith_patch
  .word dungeon2_boss_area_nametable_monolith_south_bg_patch
  .word dungeon2_boss_area_nametable_monolith_east_bg_patch
  .word dungeon2_boss_area_nametable_monolith_west_bg_patch

dungeon2_boss_area_nametable_monolith_patch:
  .byte $02,$06,$03,$04,$0b,$0c,$16,$17,$23,$24,$2d,$2e,$35,$36
dungeon2_boss_area_nametable_monolith_south_bg_patch:
  .byte $02,$06,$66,$65,$5a,$59,$66,$65,$5a,$59,$66,$65,$5a,$59
dungeon2_boss_area_nametable_monolith_east_bg_patch:
  .byte $02,$06,$bd,$be,$b6,$b7,$bd,$be,$b6,$b7,$bd,$c7,$b6,$cd
dungeon2_boss_area_nametable_monolith_west_bg_patch:
  .byte $02,$06,$bb,$bc,$b4,$b5,$bb,$bc,$b4,$b5,$c6,$bc,$cc,$b5

mountain1_area:
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word mountain1_area_bg_chr_groups
  .word hero_theme
  .byte $00 ;textbox_attribute
  .word mountain1_map
  .word mountain1_metatile_table_properties
  .word mountain1_metatile_table_params
  .word mountain1_metatile_table_attributes
  .word mountain1_metatile_table_top_left_tiles
  .word mountain1_metatile_table_top_right_tiles
  .word mountain1_metatile_table_bottom_left_tiles
  .word mountain1_metatile_table_bottom_right_tiles
  .word mountain1_big_metatile_table_top_left
  .word mountain1_big_metatile_table_top_right
  .word mountain1_big_metatile_table_bottom_left
  .word mountain1_big_metatile_table_bottom_right
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

mountain1_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK3
  .word mountain_chr

cave_area:
  .byte MAP_DATA_BANK2
  .byte CONVERSATIONS_BANK
  .word cave_area_bg_chr_groups
  .word hero_theme
  .byte $00 ;textbox_attribute
  .word cave_map
  .word cave_metatile_table_properties
  .word cave_metatile_table_params
  .word cave_metatile_table_attributes
  .word cave_metatile_table_top_left_tiles
  .word cave_metatile_table_top_right_tiles
  .word cave_metatile_table_bottom_left_tiles
  .word cave_metatile_table_bottom_right_tiles
  .word cave_big_metatile_table_top_left
  .word cave_big_metatile_table_top_right
  .word cave_big_metatile_table_bottom_left
  .word cave_big_metatile_table_bottom_right
  .word 0 ;nametable_patches_address .word
  .word 0 ;attribute_patches_address

cave_area_bg_chr_groups:
  .byte 1  ;count
  .byte BG_CHR_DATA_BANK3
  .word cave_chr
