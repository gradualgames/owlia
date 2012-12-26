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
    overworld_area

areas_lo:
  .lobytes areas

areas_hi:
  .hibytes areas

;****************************************************************
;Area entity types.
;****************************************************************
entity_types:
  .byte 5  ;count
  .byte entity_index_hero
  .byte entity_index_familiar
  .byte entity_index_explosion
  .byte entity_index_tiger
  .byte entity_index_npcman

;****************************************************************
;Area definitions.
;****************************************************************
village_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .byte 3   ;conversations_bank .byte
  .word map0_chr
  .word entity_types
  .word village_entities
  .word song1
  .word village_palette
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

village_entities:
  .byte 2  ;count
  .byte entity_index_tiger, 6, 10, 0
  .byte entity_index_npcman, 8, 14, test_conversation_index

house1_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .byte 3   ;conversations_bank .byte
  .word house1_chr
  .word entity_types
  .word house1_entities
  .word song1
  .word house1_palette
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

house1_entities:
  .byte 0  ;count

housebl_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .byte 3   ;conversations_bank .byte
  .word house1_chr
  .word entity_types
  .word housebl_entities
  .word song1
  .word housebl_palette
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

housebl_entities:
  .byte 0  ;count

housebr_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .byte 3   ;conversations_bank .byte
  .word house1_chr
  .word entity_types
  .word housebr_entities
  .word song1
  .word housebr_palette
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

housebr_entities:
  .byte 0  ;count

inn_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .byte 3   ;conversations_bank .byte
  .word house1_chr
  .word entity_types
  .word inn_entities
  .word song1
  .word inn_palette
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

inn_entities:
  .byte 0  ;count

store_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .byte 3   ;conversations_bank .byte
  .word house1_chr
  .word entity_types
  .word store_entities
  .word song1
  .word store_palette
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

store_entities:
  .byte 0  ;count

overworld_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .byte 3   ;conversations_bank .byte
  .word map1_chr
  .word entity_types
  .word overworld_entities
  .word song1
  .word overworld_palette
  .byte $00 ;textbox_attribute
  .word overworld_map
  .word overworld_metatile_table_properties
  .word overworld_metatile_table_params
  .word overworld_metatile_table_attributes
  .word overworld_metatile_table_top_left_tiles
  .word overworld_metatile_table_top_right_tiles
  .word overworld_metatile_table_bottom_left_tiles
  .word overworld_metatile_table_bottom_right_tiles
  .word overworld_big_metatile_table_top_left
  .word overworld_big_metatile_table_top_right
  .word overworld_big_metatile_table_bottom_left
  .word overworld_big_metatile_table_bottom_right

overworld_entities:
  .byte 0  ;count
