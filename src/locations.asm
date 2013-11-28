.linecont +
.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "soundengine.inc"
.include "sprites_and_animations_data.inc"
.include "hero_constants.inc"
.include "item_constants.inc"
.include "npc_constants.inc"
.include "door_constants.inc"
.include "anglerfish_constants.inc"
.include "sprite_chr_data.inc"
.include "conversation_data.inc"
.include "entities.inc"
.include "ram.inc"
.include "inventory.inc"

.segment "ROM02"

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
    meadow2_north_entrance, \
    meadow2_east_entrance,\
    meadow3_southwest_entrance,\
    meadow3_dungeon_entrance,\
    dungeon_0_0_s, \
    dungeon_0_0_e, \
    dungeon_1_0_w, \
    dungeon_1_0_e, \
    dungeon_2_0_w, \
    dungeon_2_0_e, \
    dungeon_3_0_w, \
    dungeon_3_0_n, \
    dungeon_0_1_n, \
    dungeon_0_1_e, \
    dungeon_0_1_s, \
    dungeon_1_1_w, \
    dungeon_1_1_e, \
    dungeon_2_1_w, \
    dungeon_2_1_e, \
    dungeon_3_1_w, \
    dungeon_3_1_s, \
    dungeon_0_2_n, \
    dungeon_0_2_s, \
    dungeon_1_2_s, \
    dungeon_1_2_e, \
    dungeon_2_2_w, \
    dungeon_2_2_e, \
    dungeon_3_2_w, \
    dungeon_3_2_n, \
    dungeon_0_3_n, \
    dungeon_0_3_s, \
    dungeon_1_3_n, \
    dungeon_1_3_e, \
    dungeon_2_3_w, \
    dungeon_2_3_s, \
    dungeon_2_3_e, \
    dungeon_3_3_w, \
    dungeon1_boss_area_entrance

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

;****************************************************************
;Entity sets.
;****************************************************************
village_entity_set:
  .byte 7  ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_npcman
  .byte sprite_chr_group_index_octopus

house_entity_set:
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
  .byte 6   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_pufferfish

dungeon_entity_set:
  .byte 9   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_pufferfish
  .byte sprite_chr_group_index_crab
  .byte sprite_chr_group_index_door
  .byte sprite_chr_group_index_anglerfish
  .byte sprite_chr_group_index_spotlight

dungeon_anglerfish_puzzle_entity_set:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_anglerfish
  .byte sprite_chr_group_index_spotlight

dungeon1_boss_entity_set:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_octoboss
  .byte sprite_chr_group_index_splash

;****************************************************************
;Entity instance sets
;****************************************************************
village_entity_instances:
  .byte 2  ;count
  .byte entity_index_octopus, 25, 10, sprite_chr_group_index_octopus, 0
  ; .byte entity_index_octopus, 39, 10, sprite_chr_group_index_octopus, 0
  ; .byte entity_index_octopus, 31, 32, sprite_chr_group_index_octopus, 0
  ; .byte entity_index_octopus, 39, 53, sprite_chr_group_index_octopus, 0
  ; .byte entity_index_octopus, 20, 53, sprite_chr_group_index_octopus, 0
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
  .byte 1  ;count
  .byte entity_index_pufferfish, 52, 23, sprite_chr_group_index_pufferfish, 0

meadow3_entity_instances:
  .byte 0  ;count

dungeon_0_0_entity_instances:
  .byte 2
  .byte entity_index_door, 11, 13, 0, 2, location_index_dungeon_0_1_n, 0
  .byte entity_index_door, 14, 7, 0, 2, location_index_dungeon_1_0_w, DOOR_TYPE_UNLOCKED

dungeon_1_0_entity_instances:
  .byte 2
  .byte entity_index_door, 17, 7, 0, 2, location_index_dungeon_0_0_e, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 30, 7, 0, 2, location_index_dungeon_2_0_w, DOOR_TYPE_UNLOCKED

dungeon_2_0_entity_instances:
  .byte 5
  .byte entity_index_pufferfish, 39, 6, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 39, 10, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 33, 7, 0, 2, location_index_dungeon_1_0_e, DOOR_TYPE_LOCKED
  .byte entity_index_door, 46, 9, 0, 2, location_index_dungeon_3_0_w, DOOR_TYPE_LOCKED
  .byte entity_index_traproom, 0, 0, 0, 0

dungeon_3_0_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 56, 53, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 49, 9, 0, 2, location_index_dungeon_2_0_e, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 55, 3, 0, 2, location_index_dungeon1_boss_entrance, DOOR_TYPE_KEYED

dungeon_0_1_entity_instances:
  .byte 5
  .byte entity_index_pufferfish, 4, 22, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 11, 22, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 11, 18, 0, 2, location_index_dungeon_0_0_s, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 14, 22, 0, 2, location_index_dungeon_1_1_w, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 4, 28, 0, 2, location_index_dungeon_0_2_n, DOOR_TYPE_UNLOCKED

dungeon_1_1_entity_instances:
  .byte 2
  .byte entity_index_door, 17, 22, 0, 2, location_index_dungeon_0_1_e, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 30, 22, 0, 2, location_index_dungeon_2_1_w, DOOR_TYPE_UNLOCKED

dungeon_2_1_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 39, 23, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 33, 22, 0, 2, location_index_dungeon_1_1_e, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 46, 22, 0, 2, location_index_dungeon_3_1_w, DOOR_TYPE_UNLOCKED

dungeon_3_1_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 56, 23, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 49, 22, 0, 2, location_index_dungeon_2_1_e, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 56, 28, 0, 2, location_index_dungeon_3_2_n, DOOR_TYPE_UNLOCKED

dungeon_0_2_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 7, 38, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 4, 33, 0, 2, location_index_dungeon_0_1_s, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 7, 43, 0, 2, location_index_dungeon_0_3_n, DOOR_TYPE_UNLOCKED

dungeon_1_2_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 23, 37, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 26, 43, 0, 2, location_index_dungeon_1_3_n, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 30, 37, 0, 2, location_index_dungeon_2_2_w, DOOR_TYPE_UNLOCKED

dungeon_2_2_entity_instances:
  .byte 4
  .byte entity_index_pufferfish, 38, 36, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 38, 40, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 33, 37, 0, 2, location_index_dungeon_1_2_e, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 46, 37, 0, 2, location_index_dungeon_3_2_w, DOOR_TYPE_UNLOCKED

dungeon_3_2_entity_instances:
  .byte 2
  .byte entity_index_door, 49, 37, 0, 2, location_index_dungeon_2_2_e, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 56, 33, 0, 2, location_index_dungeon_3_1_s, DOOR_TYPE_UNLOCKED

dungeon_0_3_entity_instances:
  .byte 6
  .byte entity_index_pufferfish, 4, 52, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 11, 52, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_crab, 11, 53, 0, 0
  .byte entity_index_door, 7, 48, 0, 2, location_index_dungeon_0_2_s, DOOR_TYPE_LOCKED
  .byte entity_index_door, 7, 58, 0, 2, location_index_meadow3_dungeon_entrance, DOOR_TYPE_LOCKED
  .byte entity_index_traproom, 0, 0, 0, 0

dungeon_1_3_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 22, 53, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 26, 48, 0, 2, location_index_dungeon_1_2_s, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 30, 52, 0, 2, location_index_dungeon_2_3_w, DOOR_TYPE_UNLOCKED

dungeon_2_3_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 39, 53, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_door, 33, 52, 0, 2, location_index_dungeon_1_3_e, DOOR_TYPE_UNLOCKED
  .byte entity_index_door, 46, 55, 0, 2, location_index_dungeon_3_3_w, DOOR_TYPE_UNLOCKED

dungeon_3_3_entity_instances:
  .byte 4
  .byte entity_index_anglerfish, 52, 47, 0, 3, ANGLERFISH_TURN_MODE_LEFT, ANGLERFISH_DIRECTION_DOWN, ANGLERFISH_SPOTLIGHT_OFF
  .byte entity_index_anglerfish, 59, 47, 0, 3, ANGLERFISH_TURN_MODE_RIGHT, ANGLERFISH_DIRECTION_DOWN, ANGLERFISH_SPOTLIGHT_ON
  .byte entity_index_spotlight_puzzle, 0, 0, 0, 0
  .byte entity_index_door, 49, 55, 0, 2, location_index_dungeon_2_3_e, DOOR_TYPE_UNLOCKED

dungeon1_boss_entity_instances:
  .byte 1
  .byte entity_index_octoboss_head, 6, 4, 0, 0

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
  .byte $0e,$0a,$08,$19,$0e,$08,$19,$18,$0e,$0a,$19,$15,$0e,$0a,$19,$28
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31

meadow3_palette:
  .byte $0e,$0a,$08,$19,$0e,$08,$19,$18,$0e,$08,$19,$28,$00,$00,$00,$00
  .byte $0d,$0d,$06,$36,$0d,$0d,$18,$20,$0d,$0d,$17,$20,$0d,$0d,$18,$36

dungeon_palette:
  .byte $0e,$0a,$0b,$08,$0e,$0b,$08,$18,$0e,$08,$07,$28,$00,$00,$00,$00
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31

dungeon1_boss_palette:
  .byte $0e,$0a,$0b,$08,$0e,$0b,$08,$18,$0e,$08,$07,$28,$0e,$08,$01,$12
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31

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
meadow2_north_entrance:
define_north_location LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_meadow2, meadow1_entity_set, meadow1_entity_instances, meadow1_palette,\
                        8, 1, 0, 0, 0, HERO_DIRECTION_DOWN

meadow2_east_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow2, meadow1_entity_set, meadow1_entity_instances, meadow1_palette,\
                48, 15, 62, 22,\
                0, 0, 0, HERO_DIRECTION_LEFT

;meadow3 locations
meadow3_southwest_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow3, meadow1_entity_set, meadow3_entity_instances, meadow3_palette,\
                0, 50, 8, 61,\
                0, 0, 0, HERO_DIRECTION_UP

meadow3_dungeon_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_meadow3, meadow1_entity_set, meadow3_entity_instances, meadow3_palette,\
                        1, 0, 9, 2,\
                        0, 0, 0, HERO_DIRECTION_DOWN

;dungeon locations
dungeon_0_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_0_entity_instances, dungeon_palette, 0, 0, 11, 13, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP
dungeon_0_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_0_entity_instances, dungeon_palette, 0, 0, 14, 7, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_1_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_0_entity_instances, dungeon_palette, 16, 0, 17, 7, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_1_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_0_entity_instances, dungeon_palette, 16, 0, 30, 7, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_2_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_0_entity_instances, dungeon_palette, 32, 0, 33, 7, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_2_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_0_entity_instances, dungeon_palette, 32, 0, 46, 9, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_3_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_0_entity_instances, dungeon_palette, 48, 0, 49, 9, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_3_0_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_0_entity_instances, dungeon_palette, 48, 0, 55, 3, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN
dungeon_0_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 11, 18, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN
dungeon_0_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 14, 22, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_0_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 4, 28, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP
dungeon_1_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_1_entity_instances, dungeon_palette, 16, 15, 17, 22, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_1_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_1_entity_instances, dungeon_palette, 16, 15, 30, 22, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_2_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_1_entity_instances, dungeon_palette, 32, 15, 33, 22, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_2_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_1_entity_instances, dungeon_palette, 32, 15, 46, 22, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_3_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_1_entity_instances, dungeon_palette, 48, 15, 49, 22, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_3_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_1_entity_instances, dungeon_palette, 48, 15, 56, 28, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP
dungeon_0_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_2_entity_instances, dungeon_palette, 0, 30, 4, 33, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN
dungeon_0_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_2_entity_instances, dungeon_palette, 0, 30, 7, 43, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP
dungeon_1_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_2_entity_instances, dungeon_palette, 16, 30, 26, 43, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP
dungeon_1_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_2_entity_instances, dungeon_palette, 16, 30, 30, 37, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_2_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_2_entity_instances, dungeon_palette, 32, 30, 33, 37, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_2_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_2_entity_instances, dungeon_palette, 32, 30, 46, 37, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_3_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_2_entity_instances, dungeon_palette, 48, 30, 49, 37, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_3_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_2_entity_instances, dungeon_palette, 48, 30, 56, 33, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN
dungeon_0_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_3_entity_instances, dungeon_palette, 0, 45, 7, 48, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN
dungeon_0_3_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_3_entity_instances, dungeon_palette, 0, 45, 7, 57, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP
dungeon_1_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_3_entity_instances, dungeon_palette, 16, 45, 26, 48, sfx_door, 3, soundeffect_one, HERO_DIRECTION_DOWN
dungeon_1_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_3_entity_instances, dungeon_palette, 16, 45, 30, 52, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_2_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 33, 52, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT
dungeon_2_3_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 42, 58, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP
dungeon_2_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 46, 55, sfx_door, 3, soundeffect_one, HERO_DIRECTION_LEFT
dungeon_3_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_anglerfish_puzzle_entity_set, dungeon_3_3_entity_instances, dungeon_palette, 48, 45, 49, 55, sfx_door, 3, soundeffect_one, HERO_DIRECTION_RIGHT

dungeon1_boss_area_entrance:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4)},\
                        area_index_dungeon1_boss, dungeon1_boss_entity_set, dungeon1_boss_entity_instances, dungeon1_boss_palette,\
                        0, 0, 7, 12,\
                        0, 0, 0, HERO_DIRECTION_UP
