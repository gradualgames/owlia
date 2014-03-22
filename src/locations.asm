.linecont +
.include "actions.inc"
.include "areas.inc"
.include "locations.inc"
.include "sfx_data.inc"
.include "soundengine.inc"
.include "sprites_and_animations_data.inc"
.include "hero_constants.inc"
.include "item_constants.inc"
.include "npc_constants.inc"
.include "anglerfish_constants.inc"
.include "monolith_constants.inc"
.include "traproom_constants.inc"
.include "rescueowl_constants.inc"
.include "sprite_chr_data.inc"
.include "conversation_data.inc"
.include "entities.inc"
.include "ram.inc"
.include "inventory.inc"

.segment "ROM00"

;****************************************************************
;Location LUTs
;****************************************************************
.define locations \
    village_house1_entrance, \
    village_inn_entrance, \
    village_potionstore_entrance, \
    village_housebl_entrance, \
    village_housebr_entrance, \
    village_housetr_entrance, \
    village_bottom_entrance, \
    house1_intro, \
    house1_exit, \
    inn_exit, \
    potionstore_exit, \
    housebl_exit, \
    housebr_exit, \
    housetr_exit, \
    meadow1_top_entrance, \
    meadow1_west_entrance, \
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
    dungeon1_boss_area_entrance, \
    dungeon1_boss_area_east_exit, \
    dungeon1_boss_area_owl_dungeon

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

;****************************************************************
;Entity sets.
;****************************************************************
village_entity_set:
  .byte 8  ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_npcman
  .byte sprite_chr_group_index_octopus

house_entity_set:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_tyto
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_npcwoman

meadow1_entity_set:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_octopus
  .byte sprite_chr_group_index_silmaran

meadow2_entity_set:
meadow3_entity_set:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_pufferfish
  .byte sprite_chr_group_index_octopus

dungeon_entity_set:
  .byte 9   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_pufferfish
  .byte sprite_chr_group_index_crab
  .byte sprite_chr_group_index_anglerfish
  .byte sprite_chr_group_index_spotlight

dungeon_anglerfish_puzzle_entity_set:
  .byte 9   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_anglerfish
  .byte sprite_chr_group_index_spotlight

dungeon1_boss_entity_set:
  .byte 9   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_octoboss
  .byte sprite_chr_group_index_splash

dungeon1_boss_owl_dungeon_entity_set:
  .byte 9   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_greathornedowl
  .byte sprite_chr_group_index_cage

;****************************************************************
;Entity instance sets
;****************************************************************
village_entity_instances:
  .byte 3  ;count
  ;.byte entity_index_octopus, 25, 10, sprite_chr_group_index_octopus, 0
  ; .byte entity_index_octopus, 39, 10, sprite_chr_group_index_octopus, 0
  ; .byte entity_index_octopus, 31, 32, sprite_chr_group_index_octopus, 0
  ; .byte entity_index_octopus, 39, 53, sprite_chr_group_index_octopus, 0
  ; .byte entity_index_octopus, 20, 53, sprite_chr_group_index_octopus, 0
  .byte entity_index_npc, 8, 20, sprite_chr_group_index_npcman, 6, conversation_index_hi_adlanniel, 0, 16 * 6, 16 * 6, NPC_MODE_WALK, NPC_DIRECTION_DOWN
  .byte entity_index_npc, 31, 37, sprite_chr_group_index_npcman, 6, conversation_index_owlia_school_of_falconry, 0, 16 * 6, 16 * 6, NPC_MODE_WALK, NPC_DIRECTION_DOWN
  .byte entity_index_item, 31, 32, sprite_chr_group_index_hero, ITEM_PARAMS, ITEM_STATE_PICKUP_INIT, ITEM_TYPE_HEALTH, 0, 1

house1_intro_entity_instances:
  .byte 1
  .byte entity_index_intro, 16, 10, 0, 0

house1_entity_instances:
  .byte 0

housebl_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_npc_housebl, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, NPC_DIRECTION_DOWN

housebr_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_npc_housebr, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, NPC_DIRECTION_DOWN

housetr_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_npc_housetr, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, NPC_DIRECTION_DOWN

inn_entity_instances:
  .byte 2  ;count
  .byte entity_index_npc, 30, 19, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_inn, 4, 16 * 8, 16 * 2, NPC_MODE_MOTIONLESS, NPC_DIRECTION_LEFT
  .byte entity_index_innkeep, 28, 19, 0, 10, conversation_index_prompt_for_stay_at_inn, <(22*16), >(22*16), <(14*16), >(14*16), 15, 45, -2, 2, 10

store_entity_instances:
  .byte 5  ;count
  .byte entity_index_npc, 15, 12, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_store, 4, 16 * 5, 16 * 3, NPC_MODE_WALK, NPC_DIRECTION_DOWN
  .byte entity_index_npc, 12, 20, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_store, 4, 16 * 8, 16 * 2, NPC_MODE_MOTIONLESS, NPC_DIRECTION_RIGHT
  .byte entity_index_item, 14, 18, sprite_chr_group_index_bomb, ITEM_PARAMS, ITEM_STATE_PROMPT_FOR_PURCHASE_INIT, ITEM_TYPE_BOMB, 10, 5
  .byte entity_index_item, 16, 18, sprite_chr_group_index_lantern, ITEM_PARAMS, ITEM_STATE_PROMPT_FOR_PURCHASE_INIT, ITEM_TYPE_LANTERN, 10, 5
  .byte entity_index_item, 18, 18, sprite_chr_group_index_hero, ITEM_PARAMS, ITEM_STATE_PROMPT_FOR_PURCHASE_INIT, ITEM_TYPE_HEALTH, 10, 1

meadow1_entity_instances:
  .byte 8  ;count
  .byte entity_index_silmaran, 45, 47, 0, 0
  .byte entity_index_item, 29, 44, sprite_chr_group_index_hero, ITEM_PARAMS, ITEM_STATE_PICKUP_INIT, ITEM_TYPE_HEALTH, 0, 1
  .byte entity_index_octopus, 4, 24, 0, 0
  .byte entity_index_octopus, 34, 25, 0, 0
  .byte entity_index_octopus, 12, 38, 0, 0
  .byte entity_index_octopus, 52, 29, 0, 0
  .byte entity_index_octopus, 37, 44, 0, 0
  .byte entity_index_octopus, 30, 15, 0, 0

meadow2_entity_instances:
  .byte 11
  .byte entity_index_pufferfish, 39, 9, 0, 0
  .byte entity_index_pufferfish, 47, 23, 0, 0
  .byte entity_index_pufferfish, 58, 37, 0, 0
  .byte entity_index_pufferfish, 28, 42, 0, 0
  .byte entity_index_octopus, 8, 42, 0, 0
  .byte entity_index_pufferfish, 29, 30, 0, 0
  .byte entity_index_octopus, 18, 9, 0, 0
  .byte entity_index_pufferfish, 31, 19, 0, 0
  .byte entity_index_pufferfish, 41, 51, 0, 0
  .byte entity_index_octopus, 18, 49, 0, 0
  .byte entity_index_pufferfish, 17, 28, 0, 0

meadow3_entity_instances:
  .byte 11
  .byte entity_index_pufferfish, 18, 14, 0, 0
  .byte entity_index_octopus, 51, 14, 0, 0
  .byte entity_index_pufferfish, 41, 28, 0, 0
  .byte entity_index_pufferfish, 55, 41, 0, 0
  .byte entity_index_pufferfish, 23, 56, 0, 0
  .byte entity_index_octopus, 7, 40, 0, 0
  .byte entity_index_pufferfish, 19, 27, 0, 0
  .byte entity_index_pufferfish, 35, 9, 0, 0
  .byte entity_index_pufferfish, 58, 24, 0, 0
  .byte entity_index_pufferfish, 40, 57, 0, 0
  .byte entity_index_octopus, 7, 56, 0, 0

dungeon_0_0_entity_instances:
  .byte 2
  .byte entity_index_monolith, 11, 14, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_1_n, \
                                          0, 2

  .byte entity_index_monolith, 14, 8, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_0_w, \
                                          0, 5


dungeon_1_0_entity_instances:
  .byte 2
  .byte entity_index_monolith, 17, 8, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_0_e, \
                                          0, 4

  .byte entity_index_monolith, 30, 8, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_0_w, \
                                          0, 5


dungeon_2_0_entity_instances:
  .byte 4
  .byte entity_index_pufferfish, 39, 6, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 39, 10, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 46, 10, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_0_w, \
                                          0, 5

  .byte entity_index_monolith, 33, 8, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_0_e, \
                                          0, 4


dungeon_3_0_entity_instances:
  .byte 2
  .byte entity_index_monolith, 49, 10, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_0_e, \
                                          0, 4
  .byte entity_index_monolith, 55, 4, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_KEYED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon1_boss_entrance, \
                                          1, 2

dungeon_0_1_entity_instances:
  .byte 5
  .byte entity_index_pufferfish, 4, 22, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 11, 22, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 4, 29, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_2_n, \
                                          0, 2

  .byte entity_index_monolith, 14, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_1_w, \
                                          0, 5

  .byte entity_index_monolith, 11, 19, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_0_s, \
                                          0, 2


dungeon_1_1_entity_instances:
  .byte 2
  .byte entity_index_monolith, 17, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_1_e, \
                                          0, 4

  .byte entity_index_monolith, 30, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_1_w, \
                                          0, 5


dungeon_2_1_entity_instances:
  .byte 4
  .byte entity_index_pufferfish, 39, 23, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 33, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_1_e, \
                                          0, 4

  .byte entity_index_monolith, 46, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_1_w, \
                                          0, 5
  .byte entity_index_traproom, (2 * 16), (1 * 15), 0, TRAPROOM_PARAMS, TRAPROOM_STATE_RAISE_MONOLITHS_ALIGNED

dungeon_3_1_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 56, 23, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 49, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_1_e, \
                                          0, 4

  .byte entity_index_monolith, 56, 29, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_2_n, \
                                          0, 2


dungeon_0_2_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 7, 38, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 7, 44, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_3_n, \
                                          0, 2

  .byte entity_index_monolith, 4, 34, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_1_s, \
                                          0, 2


dungeon_1_2_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 23, 37, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 30, 38, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_2_w, \
                                          0, 5

  .byte entity_index_monolith, 26, 44, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_3_n, \
                                          0, 2


dungeon_2_2_entity_instances:
  .byte 4
  .byte entity_index_pufferfish, 38, 36, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 38, 40, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 33, 38, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_2_e, \
                                          0, 4

  .byte entity_index_monolith, 46, 38, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_2_w, \
                                          0, 5


dungeon_3_2_entity_instances:
  .byte 2
  .byte entity_index_monolith, 49, 38, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_2_e, \
                                          0, 4

  .byte entity_index_monolith, 56, 34, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_1_s, \
                                          0, 2


dungeon_0_3_entity_instances:
  .byte 6
  .byte entity_index_pufferfish, 4, 52, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 11, 52, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_crab, 12, 52, sprite_chr_group_index_crab, 0
  .byte entity_index_monolith, 7, 49, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_2_s, \
                                          0, 2
  .byte entity_index_monolith, 7, 59, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_meadow3_dungeon_entrance, \
                                          0, 2
  .byte entity_index_traproom, 0, (3*15), 0, TRAPROOM_PARAMS, TRAPROOM_STATE_RAISE_MONOLITHS_ALIGNED

dungeon_1_3_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 22, 53, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 26, 49, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_2_s, \
                                          0, 2

  .byte entity_index_monolith, 30, 53, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_3_w, \
                                          0, 5


dungeon_2_3_entity_instances:
  .byte 4
  .byte entity_index_pufferfish, 39, 53, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 33, 53, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_3_e, \
                                          0, 4

  .byte entity_index_monolith, 46, 56, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_3_3_w, \
                                          0, 5
  .byte entity_index_traproom, (2 * 16), (3 * 15), 0, TRAPROOM_PARAMS, TRAPROOM_STATE_RAISE_MONOLITH_PAIR

dungeon_3_3_entity_instances:
  .byte 4
  .byte entity_index_anglerfish, 52, 47, 0, 3, ANGLERFISH_TURN_MODE_LEFT, ANGLERFISH_DIRECTION_DOWN, ANGLERFISH_SPOTLIGHT_OFF
  .byte entity_index_anglerfish, 59, 47, 0, 3, ANGLERFISH_TURN_MODE_RIGHT, ANGLERFISH_DIRECTION_DOWN, ANGLERFISH_SPOTLIGHT_ON
  .byte entity_index_spotlight_puzzle, 0, 0, 0, 0
  .byte entity_index_monolith, 49, 56, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_2_3_e, \
                                          0, 5

dungeon1_boss_entity_instances:
  .byte 3
  .byte entity_index_octoboss_head, 4, 4, 0, 0
  .byte entity_index_monolith, 14, 11, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon1_boss_area_owl_dungeon, \
                                          0, 5
  .byte entity_index_monolith, 8, 14, 0,  MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_3_0_n, \
                                          0, 2

dungeon1_boss_owl_dungeon_entity_instances:
  .byte 7
  .byte entity_index_instance_placeholder, 0, 0, 0, 0
  .byte entity_index_instance_placeholder, 0, 0, 0, 0
  .byte entity_index_instance_placeholder, 0, 0, 0, 0
  .byte entity_index_instance_placeholder, 0, 0, 0, 0
  .byte entity_index_cage, 23, 3, 0, 0
  .byte entity_index_rescueowl, 23, 4, 0, RESCUEOWL_PARAMS, RESCUEOWL_TYPE_GREATHORNEDOWL
  .byte entity_index_monolith, 17, 11, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET | MONOLITH_FLAGS_SHAKE_SCREEN_SET, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon1_boss_area_east_exit, \
                                          0, 4

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
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$28,$20,$0e,$00,$00,$00

meadow2_palette:
meadow3_palette:
  .byte $0e,$0a,$08,$19,$0e,$08,$19,$18,$0e,$08,$19,$28,$00,$00,$00,$00
  .byte $0d,$0d,$06,$36,$0d,$0d,$18,$20,$0e,$0e,$13,$23,$0d,$0d,$18,$36

dungeon_palette:
  .byte $0e,$0b,$19,$2a,$0e,$1b,$0b,$08,$0e,$0b,$08,$18,$0e,$08,$07,$28
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31

dungeon1_boss_palette:
  .byte $0e,$0b,$19,$2a,$0e,$1b,$0b,$08,$0e,$0b,$08,$18,$0e,$08,$01,$12
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31

dungeon1_boss_owl_dungeon_palette:
  .byte $0e,$0b,$19,$2a,$0e,$1b,$0b,$08,$0e,$0b,$08,$18,$0e,$08,$01,$12
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$08,$20,$0e,$00,$28,$10

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
house1_intro:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_house, house_entity_set, house1_intro_entity_instances, house_palette,\
                         11, 13, 0, 0, 0, HERO_DIRECTION_UP

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
potionstore_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_store, house_entity_set, store_entity_instances, house_palette,\
                         16, 25, sfx_door, 3, soundeffect_one, HERO_DIRECTION_UP

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

;meadow2 locations
meadow2_north_entrance:
define_north_location LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_meadow2, meadow2_entity_set, meadow2_entity_instances, meadow2_palette,\
                        8, 1, 0, 0, 0, HERO_DIRECTION_DOWN

meadow2_east_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow2, meadow2_entity_set, meadow2_entity_instances, meadow2_palette,\
                48, 15, 62, 22,\
                0, 0, 0, HERO_DIRECTION_LEFT

;meadow3 locations
meadow3_southwest_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow3, meadow3_entity_set, meadow3_entity_instances, meadow3_palette,\
                0, 50, 8, 61,\
                0, 0, 0, HERO_DIRECTION_UP

meadow3_dungeon_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_meadow3, meadow3_entity_set, meadow3_entity_instances, meadow3_palette,\
                        1, 0, 9, 2,\
                        0, 0, 0, HERO_DIRECTION_DOWN

;dungeon locations
dungeon_2_3_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 42, 54, 0, 0, 0, HERO_DIRECTION_UP
dungeon_0_3_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_3_entity_instances, dungeon_palette, 0, 45, 7, 55, 0, 0, 0, HERO_DIRECTION_UP
dungeon_0_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_3_entity_instances, dungeon_palette, 0, 45, 7, 49, 0, 0, 0, HERO_DIRECTION_DOWN
dungeon_0_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_2_entity_instances, dungeon_palette, 0, 30, 7, 40, 0, 0, 0, HERO_DIRECTION_UP
dungeon_0_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_2_entity_instances, dungeon_palette, 0, 30, 4, 34, 0, 0, 0, HERO_DIRECTION_DOWN
dungeon_0_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 4, 25, 0, 0, 0, HERO_DIRECTION_UP
dungeon_0_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 13, 22, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_0_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 11, 19, 0, 0, 0, HERO_DIRECTION_DOWN
dungeon_0_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_0_entity_instances, dungeon_palette, 0, 0, 11, 10, 0, 0, 0, HERO_DIRECTION_UP
dungeon_0_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_0_0_entity_instances, dungeon_palette, 0, 0, 13, 7, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_1_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_0_entity_instances, dungeon_palette, 16, 0, 18, 7, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_1_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_0_entity_instances, dungeon_palette, 16, 0, 29, 7, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_1_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_1_entity_instances, dungeon_palette, 16, 15, 18, 22, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_1_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_1_entity_instances, dungeon_palette, 16, 15, 29, 22, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_2_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_1_entity_instances, dungeon_palette, 32, 15, 34, 22, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_1_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_2_entity_instances, dungeon_palette, 16, 30, 29, 37, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_1_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_2_entity_instances, dungeon_palette, 16, 30, 26, 40, 0, 0, 0, HERO_DIRECTION_UP
dungeon_1_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_3_entity_instances, dungeon_palette, 16, 45, 26, 49, 0, 0, 0, HERO_DIRECTION_DOWN
dungeon_1_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_1_3_entity_instances, dungeon_palette, 16, 45, 29, 52, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_2_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 34, 52, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_2_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 45, 55, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_3_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_anglerfish_puzzle_entity_set, dungeon_3_3_entity_instances, dungeon_palette, 48, 45, 50, 55, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_2_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_2_entity_instances, dungeon_palette, 32, 30, 34, 37, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_2_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_2_entity_instances, dungeon_palette, 32, 30, 45, 37, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_3_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_2_entity_instances, dungeon_palette, 48, 30, 50, 37, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_2_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_1_entity_instances, dungeon_palette, 32, 15, 45, 22, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_3_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_1_entity_instances, dungeon_palette, 48, 15, 50, 22, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_2_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_0_entity_instances, dungeon_palette, 32, 0, 45, 9, 0, 0, 0, HERO_DIRECTION_LEFT
dungeon_3_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_0_entity_instances, dungeon_palette, 48, 0, 50, 9, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_2_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_2_0_entity_instances, dungeon_palette, 32, 0, 34, 7, 0, 0, 0, HERO_DIRECTION_RIGHT
dungeon_3_0_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_0_entity_instances, dungeon_palette, 48, 0, 55, 4, 0, 0, 0, HERO_DIRECTION_DOWN
dungeon_3_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_1_entity_instances, dungeon_palette, 48, 15, 56, 25, 0, 0, 0, HERO_DIRECTION_UP
dungeon_3_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_entity_set, dungeon_3_2_entity_instances, dungeon_palette, 48, 30, 56, 34, 0, 0, 0, HERO_DIRECTION_DOWN

dungeon1_boss_area_entrance:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon1_boss, dungeon1_boss_entity_set, dungeon1_boss_entity_instances, dungeon1_boss_palette,\
                        0, 0, 8, 10,\
                        0, 0, 0, HERO_DIRECTION_UP

dungeon1_boss_area_east_exit:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon1_boss, dungeon1_boss_entity_set, dungeon1_boss_entity_instances, dungeon1_boss_palette,\
                        0, 0, 13, 10,\
                        0, 0, 0, HERO_DIRECTION_LEFT

dungeon1_boss_area_owl_dungeon:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon1_boss, dungeon1_boss_owl_dungeon_entity_set, dungeon1_boss_owl_dungeon_entity_instances, dungeon1_boss_owl_dungeon_palette,\
                        16, 0, 18, 10,\
                        0, 0, 0, HERO_DIRECTION_RIGHT
