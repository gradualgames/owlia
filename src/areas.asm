.linecont +
.include "areas.inc"
.include "map_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "music_data.inc"
.include "sprites_and_animations_data.inc"
.include "entities.inc"
.include "conversation_data.inc"

.segment "CODE"

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
    dungeon_area

areas_lo:
  .lobytes areas

areas_hi:
  .hibytes areas

.segment "ROM02"

;****************************************************************
;Area definitions.
;****************************************************************
village_area:
  .byte 0   ;music_bank .byte
  .byte 0   ;map_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word map0_chr
  .word song3
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

house1_area:
  .byte 0   ;music_bank .byte
  .byte 0   ;map_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word song3
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

housebl_area:
  .byte 0   ;music_bank .byte
  .byte 0   ;map_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word song3
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

housebr_area:
  .byte 0   ;music_bank .byte
  .byte 0   ;map_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word song3
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

housetr_area:
  .byte 0   ;music_bank .byte
  .byte 0   ;map_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word song3
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

inn_area:
  .byte 0   ;music_bank .byte
  .byte 0   ;map_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word song3
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

store_area:
  .byte 0   ;music_bank .byte
  .byte 0   ;map_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word song3
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

meadow1_area:
  .byte 0   ;music_bank .byte
  .byte 0   ;map_bank .byte
  .byte 3   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word map1_chr
  .word song1
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

meadow2_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;map_bank .byte
  .byte 3   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word map1_chr
  .word song1
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

dungeon_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;map_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word dungeon_chr
  .word song2
  .byte $00 ;textbox_attribute
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
