.linecont +
.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "soundengine.inc"
.include "sprites_and_animations_data.inc"
.include "hero_constants.inc"
.include "item_constants.inc"
.include "npc_constants.inc"
.include "sprite_chr_data.inc"
.include "conversation_data.inc"
.include "entities.inc"
.include "ram.inc"
.include "inventory.inc"

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
    meadow1_top_entrance, \
    meadow1_west_entrance, \
    meadow1_dungeon_entrance, \
    meadow2_east_entrance,\
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
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_rope
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_npcwoman

meadow1_entity_set:
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
  .byte entity_index_npc, 8, 20, sprite_chr_group_index_npcman, 6, conversation_index_welcome_to_demo, 0, 16 * 6, 16 * 6, NPC_MODE_WALK, NPC_DIRECTION_DOWN

house1_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, NPC_DIRECTION_DOWN

housebl_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, NPC_DIRECTION_DOWN

housebr_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, NPC_DIRECTION_DOWN

housetr_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, NPC_DIRECTION_DOWN

inn_entity_instances:
  .byte 2  ;count
  .byte entity_index_npc, 30, 19, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_inn, 4, 16 * 8, 16 * 2, NPC_MODE_MOTIONLESS, NPC_DIRECTION_LEFT
  .byte entity_index_innkeep, 28, 19, 0, 10, conversation_index_prompt_for_stay_at_inn, <(22*16), >(22*16), <(14*16), >(14*16), 15, 45, -2, 2, 10

store_entity_instances:
  .byte 7  ;count
  .byte entity_index_npc, 9, 13, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_store, 4, 16 * 6, 16 * 1, NPC_MODE_WALK, NPC_DIRECTION_DOWN
  .byte entity_index_npc, 15, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_store, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, NPC_DIRECTION_DOWN
  .byte entity_index_item, 10, 17, sprite_chr_group_index_bomb, 10, <Bomb, >Bomb, <inventory_bombs, >inventory_bombs, conversation_index_purchase_bomb, 10, 5, <INVENTORY_MAX_BOMBS, >INVENTORY_MAX_BOMBS, ITEM_PURCHASE | ITEM_8_BIT_VAR
  .byte entity_index_item, 11, 17, sprite_chr_group_index_lantern, 10, <Lantern, >Lantern, <inventory_lanterns, >inventory_lanterns, conversation_index_purchase_lantern, 10, 5, <INVENTORY_MAX_LANTERNS, >INVENTORY_MAX_LANTERNS, ITEM_PURCHASE | ITEM_8_BIT_VAR
  .byte entity_index_item, 12, 17, sprite_chr_group_index_hero, 10, <Heart, >Heart, <inventory_healths, >inventory_healths, conversation_index_purchase_health, 10, 1, <INVENTORY_MAX_HEALTHS, >INVENTORY_MAX_HEALTHS, ITEM_PURCHASE | ITEM_8_BIT_VAR
  .byte entity_index_item, 13, 17, sprite_chr_group_index_rope, 10, <Rope, >Rope, <inventory_ropes, >inventory_ropes, conversation_index_purchase_rope, 10, 1, <INVENTORY_MAX_ROPES, >INVENTORY_MAX_ROPES, ITEM_PURCHASE | ITEM_8_BIT_VAR
  .byte entity_index_item, 13, 18, sprite_chr_group_index_coins, 10, <Coins, >Coins, <inventory_gp, >inventory_gp, 0, 0, 100, <INVENTORY_MAX_GP, >INVENTORY_MAX_GP, ITEM_PICKUP | ITEM_16_BIT_VAR

meadow1_entity_instances:
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

meadow1_palette:
  .byte $0e,$0a,$19,$15,$0e,$0a,$08,$19,$0e,$0a,$19,$28,$0e,$08,$19,$18
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

;meadow1 locations
meadow1_top_entrance:
define_north_location LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_meadow1, meadow1_entity_set, meadow1_entity_instances, meadow1_palette,\
                      29, 1, 0, 0, 0, HERO_DIRECTION_DOWN

meadow1_west_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow1, meadow1_entity_set, meadow1_entity_instances, meadow1_palette,\
                0, 16, 1, 24,\
                0, 0, 0, HERO_DIRECTION_RIGHT

meadow1_dungeon_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_meadow1, meadow1_entity_set, meadow1_entity_instances, meadow1_palette,\
                         30, 13, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN

;meadow2 locations
meadow2_east_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow2, meadow1_entity_set, meadow1_entity_instances, meadow1_palette,\
                48, 15, 62, 22,\
                0, 0, 0, HERO_DIRECTION_LEFT

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
