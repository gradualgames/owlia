.linecont +
.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "soundengine.inc"
.include "sprites_and_animations_data.inc"
.include "hero_constants.inc"
.include "sprite_chr_data.inc"
.include "conversation_data.inc"
.include "entities.inc"
.include "ram.inc"

.segment "CODE"

;****************************************************************
;Location LUTs
;****************************************************************
.define locations \
    village_house1_entrance, \
    village_inn_entrance, \
    village_weaponstore_entrance, \
    village_potionstore_entrance, \
    village_housebl_entrance, \
    village_housebr_entrance, \
    village_housetr_entrance, \
    village_bottom_entrance, \
    house1_exit, \
    inn_exit, \
    weaponstore_exit, \
    potionstore_exit, \
    housebl_exit, \
    housebr_exit, \
    housetr_exit, \
    overworld_top_entrance, \
    overworld_dungeon_entrance, \
    dungeon_entrance, \
    dungeon_room_a, \
    dungeon_room_b

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

.segment "ROM02"

;****************************************************************
;Entity sets.
;****************************************************************
village_entity_set:
  .byte 3  ;entities_bank
  .byte 0  ;sprites_and_animations_bank .byte
  .byte 1  ;sprite_chr_bank .byte
  .byte 7  ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_npcman
  .byte sprite_chr_group_index_jellyfish

house_entity_set:
  .byte 3   ;entities_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 6   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_npcwoman

overworld_entity_set:
  .byte 3   ;entities_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 5   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern

dungeon_entity_set:
  .byte 3   ;entities_bank .byte
  .byte 0   ;sprites_and_animations_bank .byte
  .byte 1   ;sprite_chr_bank .byte
  .byte 7   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_keyeddoor

;****************************************************************
;Entity instance sets
;****************************************************************
village_entity_instances:
  .byte 2  ;count
  .byte entity_index_jellyfish, 25, 10, sprite_chr_group_index_jellyfish, 0
  ; .byte entity_index_jellyfish, 39, 10, sprite_chr_group_index_jellyfish, 0
  ; .byte entity_index_jellyfish, 31, 32, sprite_chr_group_index_jellyfish, 0
  ; .byte entity_index_jellyfish, 39, 53, sprite_chr_group_index_jellyfish, 0
  ; .byte entity_index_jellyfish, 20, 53, sprite_chr_group_index_jellyfish, 0
  .byte entity_index_npc, 8, 20, sprite_chr_group_index_npcman, 4, conversation_index_welcome_to_demo, 0, 16 * 6, 16 * 6

house1_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2

housebl_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2

housebr_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2

housetr_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2

inn_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_inn, 4, 16 * 8, 16 * 2

store_entity_instances:
  .byte 2  ;count
  .byte entity_index_npc, 15, 18, sprite_chr_group_index_npcwoman, 4, conversation_index_welcome_to_my_store, 4, 16 * 8, 16 * 2
  .byte entity_index_purchaseitem, 10, 17, sprite_chr_group_index_bomb, 6, <Bomb, >Bomb, <inventory_bombs, >inventory_bombs, conversation_index_purchase_bomb, 10

overworld_entity_instances:
  .byte 0  ;count

dungeon_entity_instances:
  .byte 6  ;count
  .byte entity_index_key, 13, 4, 0, 0
  .byte entity_index_key, 25, 5, 0, 0
  .byte entity_index_keyeddoor, 7, 1, sprite_chr_group_index_keyeddoor, 1, 16
  .byte entity_index_keyeddoor, 0, 6, sprite_chr_group_index_keyeddoor, 1, 16
  .byte entity_index_keyeddoor, 7, 11, sprite_chr_group_index_keyeddoor, 1, 16
  .byte entity_index_keyeddoor, 15, 6, sprite_chr_group_index_keyeddoor, 1, 16

;****************************************************************
;Palettes.
;****************************************************************
village_palette:
  .byte $0d,$00,$10,$38,$0d,$0d,$0a,$19,$0d,$07,$06,$36,$0d,$19,$12,$22
  .byte $0d,$0d,$06,$36,$0d,$0d,$18,$20,$0d,$0d,$17,$20,$0d,$0d,$18,$36

house_palette:
  .byte $0d,$08,$18,$37,$0d,$07,$17,$27,$0d,$02,$12,$22,$0d,$04,$14,$37
  .byte $0d,$0d,$06,$36,$0d,$0d,$18,$20,$0d,$0d,$1a,$36,$0d,$0d,$15,$36

overworld_palette:
  .byte $0d,$19,$18,$2a,$0d,$0d,$27,$20,$0d,$18,$2a,$37,$00,$00,$00,$00
  .byte $0d,$0d,$06,$36,$0d,$0d,$18,$20,$0d,$0d,$17,$20,$0d,$0d,$18,$36

dungeon_palette:
  .byte $0d,$08,$18,$27,$0d,$09,$08,$1a,$0d,$0d,$12,$22,$00,$00,$00,$00
  .byte $0d,$0d,$06,$36,$0d,$0d,$18,$20,$0d,$0d,$17,$20,$0d,$0d,$18,$36

;****************************************************************
;Location definitions.
;****************************************************************

;village locations
village_house1_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_entity_set, village_entity_instances, village_palette,\
                         11, 14, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_inn_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_entity_set, village_entity_instances, village_palette,\
                         11, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_weaponstore_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_entity_set, village_entity_instances, village_palette,\
                         54, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_potionstore_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_entity_set, village_entity_instances, village_palette,\
                         51, 35, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_housebl_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_entity_set, village_entity_instances, village_palette,\
                         11, 55, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_housebr_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_entity_set, village_entity_instances, village_palette,\
                         51, 55, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_housetr_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_entity_set, village_entity_instances, village_palette,\
                         51, 14, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

village_bottom_entrance:
define_south_location LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_village, village_entity_set, village_entity_instances, village_palette,\
                      31, 62, 0, 0, 0, HERO_DIRECTION_UP

;house1 locations
house1_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_house, house_entity_set, house1_entity_instances, house_palette,\
                         14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;inn locations
inn_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_inn, house_entity_set, inn_entity_instances, house_palette,\
                         25, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;store locations
weaponstore_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_store, house_entity_set, store_entity_instances, house_palette,\
                         25, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

potionstore_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_store, house_entity_set, store_entity_instances, house_palette,\
                         13, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;housebl locations
housebl_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_housebl, house_entity_set, housebl_entity_instances, house_palette,\
                         14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;housebr locations
housebr_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_housebr, house_entity_set, housebr_entity_instances, house_palette,\
                         14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;housetr locations
housetr_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_housetr, house_entity_set, housetr_entity_instances, house_palette,\
                         14, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

;overworld locations
overworld_top_entrance:
define_north_location LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_overworld, overworld_entity_set, overworld_entity_instances, overworld_palette,\
                      27, 1, 0, 0, 0, HERO_DIRECTION_DOWN

overworld_dungeon_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_overworld, overworld_entity_set, overworld_entity_instances, overworld_palette,\
                         30, 13, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

;dungeon locations
dungeon_entrance:
define_location LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                LOCATION_BRIGHTNESS_LEVEL_4, \
                area_index_dungeon, dungeon_entity_set, dungeon_entity_instances, dungeon_palette,\
                0, 0, 7, 9, \
                sfx_door, 3, soundeffect_one,\
                HERO_DIRECTION_UP

dungeon_room_a:
define_location LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                LOCATION_BRIGHTNESS_LEVEL_4, \
                area_index_dungeon, dungeon_entity_set, dungeon_entity_instances, dungeon_palette,\
                0, 0, 7, 2, \
                0, 0, 0,\
                HERO_DIRECTION_DOWN

dungeon_room_b:
define_location LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                LOCATION_BRIGHTNESS_LEVEL_4, \
                area_index_dungeon, dungeon_entity_set, dungeon_entity_instances, dungeon_palette,\
                16, 0, 23, 10, \
                0, 0, 0,\
                HERO_DIRECTION_UP
