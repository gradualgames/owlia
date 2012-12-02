.linecont +
.include "areas.inc"
.include "map_data.inc"
.include "bg_chr_data.inc"
.include "sprite_chr_data.inc"
.include "music_data.inc"
.include "sprites_and_animations_data.inc"
.include "entities.inc"

.segment "CODE"

;****************************************************************
;Area LUTs
;****************************************************************
.define areas \
    village_area, \
    house1_area, \
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
  .word map0_chr
  .word entity_types
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

village_entities:
  .byte 2  ;count
  .byte entity_index_tiger, 10, 10
  .byte entity_index_npcman, 10, 14

house1_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .word house1_chr
  .word entity_types
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

house1_entities:
  .byte 0  ;count

overworld_area:
  .byte 0   ;music_bank .byte
  .byte 1   ;entities_bank .byte
  .byte 2   ;map_bank .byte
  .byte 3   ;sprites_and_animations_bank .byte
  .byte 7   ;bg_chr_bank .byte
  .byte 6   ;sprite_chr_bank .byte
  .word map1_chr
  .word entity_types
  .word overworld_entities
  .word song1
  .word overworld_palette
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
