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
    overworld_area, \
    dungeon_area

areas_lo:
  .lobytes areas

areas_hi:
  .hibytes areas

.segment "ROM02"

;****************************************************************
;Area entity types.
;****************************************************************
village_sprite_chr_groups:
  .byte 7  ;count
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_npcman
  .byte sprite_chr_group_index_jellyfish

house_sprite_chr_groups:
  .byte 6  ;count
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_npcwoman

overworld_sprite_chr_groups:
  .byte 5  ;count
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern

dungeon_sprite_chr_groups:
  .byte 7  ;count
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_keyeddoor

;****************************************************************
;Area definitions.
;****************************************************************
village_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 0   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word map0_chr
  .word village_sprite_chr_groups
  .word village_entities
  .word song3
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
  .byte entity_index_jellyfish, 25, 10, sprite_chr_group_index_jellyfish, 0
  ; .byte entity_index_jellyfish, 39, 10, sprite_chr_group_index_jellyfish, 0
  ; .byte entity_index_jellyfish, 31, 32, sprite_chr_group_index_jellyfish, 0
  ; .byte entity_index_jellyfish, 39, 53, sprite_chr_group_index_jellyfish, 0
  ; .byte entity_index_jellyfish, 20, 53, sprite_chr_group_index_jellyfish, 0
  .byte entity_index_npc, 8, 20, sprite_chr_group_index_npcman, 4, conversation_index_welcome_to_demo, 0, 16 * 6, 16 * 6

house1_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 0   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word house_sprite_chr_groups
  .word house1_entities
  .word song3
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
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2

housebl_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 0   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word house_sprite_chr_groups
  .word housebl_entities
  .word song3
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
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2

housebr_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 0   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word house_sprite_chr_groups
  .word housebr_entities
  .word song3
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
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2

housetr_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 0   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word house_sprite_chr_groups
  .word housetr_entities
  .word song3
  .word housetr_palette
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

housetr_entities:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2

inn_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 0   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word house_sprite_chr_groups
  .word inn_entities
  .word song3
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
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_inn, 4, 16 * 8, 16 * 2

store_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 0   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word house1_chr
  .word house_sprite_chr_groups
  .word store_entities
  .word song3
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
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_store, 4, 16 * 8, 16 * 2

overworld_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 0   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word map1_chr
  .word overworld_sprite_chr_groups
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

dungeon_area:
  .byte 0   ;music_bank .byte
  .byte 3   ;entities_bank .byte
  .byte 1   ;map_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;bg_chr_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 0   ;conversations_bank .byte
  .word dungeon_chr
  .word dungeon_sprite_chr_groups
  .word dungeon_entities
  .word song2
  .word dungeon_palette
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

dungeon_entities:
  .byte 6  ;count
  .byte entity_index_key, 13, 4, 0, 0
  .byte entity_index_key, 25, 5, 0, 0
  .byte entity_index_keyeddoor, 7, 1, sprite_chr_group_index_keyeddoor, 1, 16
  .byte entity_index_keyeddoor, 0, 6, sprite_chr_group_index_keyeddoor, 1, 16
  .byte entity_index_keyeddoor, 7, 11, sprite_chr_group_index_keyeddoor, 1, 0
  .byte entity_index_keyeddoor, 15, 6, sprite_chr_group_index_keyeddoor, 1, 16
