.linecont +
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
.include "rescueowl_constants.inc"
.include "spotlight_puzzle_constants.inc"
.include "treasure_chest_constants.inc"
.include "treasure_room_constants.inc"
.include "dungeon_entrance_statue_constants.inc"
.include "eel_constants.inc"
.include "urchin_constants.inc"
.include "bombable_wall_constants.inc"
.include "ordered_defeat_puzzle_constants.inc"
.include "simultaneous_defeat_puzzle_constants.inc"
.include "monolith_puzzle_constants.inc"
.include "triple_anglerfish_puzzle_constants.inc"
.include "switch_constants.inc"
.include "switch_puzzle_constants.inc"
.include "sprite_chr_data.inc"
.include "conversation_data.inc"
.include "entity.inc"
.include "entities.inc"
.include "ram.inc"
.include "inventory.inc"
.include "play_state.inc"
.include "ppu.inc"

.segment "ROM00"

;****************************************************************
;Location LUTs
;****************************************************************
.define locations \
    village_house1_entrance, \
    village_housel_entrance, \
    village_houser_entrance, \
    village_housebl_entrance, \
    village_housebr_entrance, \
    village_housetr_entrance, \
    village_bottom_entrance, \
    house1_intro, \
    house1_exit, \
    housel_exit, \
    houser_exit, \
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
    dungeon1_boss_area_owl_dungeon, \
    tundra1_entrance, \
    tundra1_north_entrance, \
    tundra1_south_entrance, \
    tundra2_south_entrance, \
    tundra3_north_entrance, \
    tundra3_dungeon2_entrance, \
    dungeon2_0_0_s, \
    dungeon2_0_0_e, \
    dungeon2_1_0_s, \
    dungeon2_1_0_w, \
    dungeon2_2_0_n, \
    dungeon2_2_0_e, \
    dungeon2_3_0_s, \
    dungeon2_3_0_w, \
    dungeon2_0_1_n, \
    dungeon2_1_1_n, \
    dungeon2_1_1_s, \
    dungeon2_1_1_e, \
    dungeon2_2_1_w, \
    dungeon2_3_1_n, \
    dungeon2_3_1_s, \
    dungeon2_0_2_s, \
    dungeon2_0_2_e, \
    dungeon2_1_2_n, \
    dungeon2_1_2_e, \
    dungeon2_1_2_w, \
    dungeon2_2_2_s, \
    dungeon2_2_2_w, \
    dungeon2_3_2_n, \
    dungeon2_3_2_s, \
    dungeon2_0_3_n, \
    dungeon2_0_3_e, \
    dungeon2_1_3_w, \
    dungeon2_2_3_n, \
    dungeon2_2_3_s, \
    dungeon2_2_3_e, \
    dungeon2_3_3_n, \
    dungeon2_3_3_w, \
    dungeon2_boss_area_entrance, \
    dungeon2_boss_area_east_exit, \
    dungeon2_boss_area_owl_dungeon, \
    mountain1_south_entrance, \
    mountain1_dungeon3_entrance, \
    mountain1_top_left_cave_entrance, \
    mountain1_bottom_left_cave_entrance, \
    mountain1_bottom_right_cave_entrance, \
    cave_top_left, \
    cave_bottom_left, \
    cave_bottom_right, \
    dungeon3_entrance, \
    dungeon3_0_0_s, \
    dungeon3_0_0_e, \
    dungeon3_1_0_s, \
    dungeon3_1_0_e, \
    dungeon3_1_0_w, \
    dungeon3_2_0_e, \
    dungeon3_2_0_w, \
    dungeon3_3_0_s, \
    dungeon3_3_0_w, \
    dungeon3_0_1_n, \
    dungeon3_0_1_s, \
    dungeon3_1_1_n, \
    dungeon3_1_1_e, \
    dungeon3_2_1_s, \
    dungeon3_2_1_w, \
    dungeon3_3_1_n, \
    dungeon3_3_1_s, \
    dungeon3_0_2_n, \
    dungeon3_0_2_e, \
    dungeon3_1_2_s, \
    dungeon3_1_2_w, \
    dungeon3_2_2_n, \
    dungeon3_3_2_n, \
    dungeon3_3_2_s, \
    dungeon3_0_3_e, \
    dungeon3_1_3_n, \
    dungeon3_1_3_e, \
    dungeon3_1_3_w, \
    dungeon3_2_3_w, \
    dungeon3_3_3_n, \
    dungeon3_3_3_e, \
    dungeon3_boss_area_entrance, \
    dungeon3_boss_area_owl_dungeon,\
    island1_entrance, \
    island1_north_exit, \
    island2_entrance, \
    island2_north_exit, \
    temple1_entrance, \
    temple1_dungeon4_entrance, \
    dungeon4_entrance, \
    dungeon4_0_0_s, \
    dungeon4_0_0_e, \
    dungeon4_0_1_e, \
    dungeon4_1_0_s, \
    dungeon4_1_0_e, \
    dungeon4_1_0_w, \
    dungeon4_2_0_e, \
    dungeon4_2_0_w, \
    dungeon4_3_0_s, \
    dungeon4_3_0_w, \
    dungeon4_1_1_n, \
    dungeon4_1_1_s, \
    dungeon4_1_1_e, \
    dungeon4_1_1_w, \
    dungeon4_2_1_w, \
    dungeon4_3_1_n, \
    dungeon4_0_2_e, \
    dungeon4_1_2_n, \
    dungeon4_1_2_e, \
    dungeon4_1_2_w, \
    dungeon4_2_2_s, \
    dungeon4_2_2_e, \
    dungeon4_2_2_w, \
    dungeon4_3_2_w, \
    dungeon4_0_3_e, \
    dungeon4_1_3_e, \
    dungeon4_1_3_w, \
    dungeon4_2_3_n, \
    dungeon4_2_3_e, \
    dungeon4_2_3_w, \
    dungeon4_3_3_w

locations_lo:
  .lobytes locations
locations_hi:
  .hibytes locations

;****************************************************************
;Entity sets.
;****************************************************************
village_sprite_chr_groups:
  .byte 8  ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_npcman
  .byte sprite_chr_group_index_octopus

house_sprite_chr_groups:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_tyto
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_npcwoman

meadow1_sprite_chr_groups:
  .byte 9   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_octopus
  .byte sprite_chr_group_index_silmaran

meadow2_sprite_chr_groups:
meadow3_sprite_chr_groups:
  .byte 10   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_dungeon_entrance_statue
  .byte sprite_chr_group_index_pufferfish
  .byte sprite_chr_group_index_octopus

dungeon_sprite_chr_groups:
  .byte 10   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_pufferfish
  .byte sprite_chr_group_index_crab

dungeon_anglerfish_puzzle_sprite_chr_groups:
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

dungeon1_boss_sprite_chr_groups:
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

dungeon1_boss_owl_dungeon_sprite_chr_groups:
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

tundra1_sprite_chr_groups:
tundra2_sprite_chr_groups:
tundra3_sprite_chr_groups:
  .byte 11   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_eel
  .byte sprite_chr_group_index_jellyfish
  .byte sprite_chr_group_index_urchin
  .byte sprite_chr_group_index_dungeon_entrance_statue

dungeon2_sprite_chr_groups:
  .byte 13   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_eel
  .byte sprite_chr_group_index_jellyfish
  .byte sprite_chr_group_index_urchin
  .byte sprite_chr_group_index_ice_shards
  .byte sprite_chr_group_index_ice_block

dungeon2_boss_sprite_chr_groups:
  .byte 10   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_swordfish_boss
  .byte sprite_chr_group_index_splash

dungeon2_boss_owl_dungeon_sprite_chr_groups:
  .byte 10   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_cage
  .byte sprite_chr_group_index_siberianeagleowl

mountain1_sprite_chr_groups:
  .byte 10   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_horseshoe_crab
  .byte sprite_chr_group_index_octopus
  .byte sprite_chr_group_index_dungeon_entrance_statue
  .byte sprite_chr_group_index_seahorse

cave_sprite_chr_groups:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_horseshoe_crab

dungeon3_sprite_chr_groups:
  .byte 12   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_horseshoe_crab
  .byte sprite_chr_group_index_crab
  .byte sprite_chr_group_index_seahorse
  .byte sprite_chr_group_index_urchin

dungeon3_0_3_sprite_chr_groups:
  .byte 10   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_anglerfish
  .byte sprite_chr_group_index_spotlight

dungeon3_boss_sprite_chr_groups:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_crab
  .byte sprite_chr_group_index_crab_boss

dungeon3_boss_owl_dungeon_sprite_chr_groups:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_greatgrayowl
  .byte sprite_chr_group_index_cage

island1_sprite_chr_groups:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_starfish
  .byte sprite_chr_group_index_clam

island2_sprite_chr_groups:
  .byte 8   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_starfish
  .byte sprite_chr_group_index_clam

temple1_sprite_chr_groups:
  .byte 10   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_starfish
  .byte sprite_chr_group_index_clam
  .byte sprite_chr_group_index_seahorse
  .byte sprite_chr_group_index_dungeon_entrance_statue

dungeon4_sprite_chr_groups:
  .byte 12   ;sprite_chr_groups .byte
  .byte sprite_chr_group_index_hero
  .byte sprite_chr_group_index_familiar
  .byte sprite_chr_group_index_explosion
  .byte sprite_chr_group_index_bomb
  .byte sprite_chr_group_index_lantern
  .byte sprite_chr_group_index_coins
  .byte sprite_chr_group_index_treasure_chest
  .byte sprite_chr_group_index_key
  .byte sprite_chr_group_index_horseshoe_crab
  .byte sprite_chr_group_index_crab
  .byte sprite_chr_group_index_seahorse
  .byte sprite_chr_group_index_urchin

;****************************************************************
;Entity instance sets
;****************************************************************
village_entity_instances:
  .byte 3  ;count
  .byte entity_index_npc, 31, 37, sprite_chr_group_index_npcman, 6, conversation_index_owlia_school_of_falconry, 0, 16 * 6, 16 * 6, NPC_MODE_WALK, ENTITY_DIRECTION_DOWN
  .byte entity_index_npc, 15, 20, sprite_chr_group_index_npcman, 6, conversation_index_hi_adlanniel, 0, 16 * 6, 16 * 6, NPC_MODE_WALK, ENTITY_DIRECTION_DOWN
  .byte entity_index_item, 31, 32, sprite_chr_group_index_hero, ITEM_PARAMS, ITEM_STATE_PICKUP_INIT, ITEM_TYPE_HEALTH, INVENTORY_DUNGEON_FLAGS_MASK_NOP, 0, 0, 1, 0

house1_intro_entity_instances:
  .byte 1
  .byte entity_index_intro, 16, 10, 0, 0

house1_entity_instances:
  .byte 0

housebl_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_npc_housebl, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, ENTITY_DIRECTION_DOWN

housebr_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_npc_housebr, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, ENTITY_DIRECTION_DOWN

housetr_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 9, 18, sprite_chr_group_index_npcwoman, 6, conversation_index_npc_housetr, 4, 16 * 8, 16 * 2, NPC_MODE_WALK, ENTITY_DIRECTION_DOWN

housel_entity_instances:
  .byte 1  ;count
  .byte entity_index_npc, 30, 19, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_house, 4, 16 * 8, 16 * 2, NPC_MODE_MOTIONLESS, ENTITY_DIRECTION_LEFT

houser_entity_instances:
  .byte 2  ;count
  .byte entity_index_npc, 15, 16, sprite_chr_group_index_npcwoman, 6, conversation_index_ssh, 4, 16 * 5, 16 * 1, NPC_MODE_WALK, ENTITY_DIRECTION_DOWN
  .byte entity_index_npc, 12, 20, sprite_chr_group_index_npcwoman, 6, conversation_index_welcome_to_my_library, 4, 16 * 8, 16 * 2, NPC_MODE_MOTIONLESS, ENTITY_DIRECTION_RIGHT

meadow1_entity_instances:
  .byte 5  ;count
  .byte entity_index_silmaran, 45, 47, 0, 0
  .byte entity_index_item, 29, 44, sprite_chr_group_index_hero, ITEM_PARAMS, ITEM_STATE_PICKUP_INIT, ITEM_TYPE_HEALTH, INVENTORY_DUNGEON_FLAGS_MASK_NOP, 0, 0, 1, 0
  .byte entity_index_treasure_chest, 11, 38, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_octopus, 12, 38, 0, 0
  .byte entity_index_octopus, 37, 44, 0, 0

meadow2_entity_instances:
  .byte 11
  .byte entity_index_pufferfish, 47, 33, 0, 0
  .byte entity_index_pufferfish, 37, 51, 0, 0
  .byte entity_index_pufferfish, 17, 28, 0, 0
  .byte entity_index_pufferfish, 57, 42, 0, 0
  .byte entity_index_pufferfish, 29, 29, 0, 0
  .byte entity_index_octopus, 18, 49, 0, 0
  .byte entity_index_octopus, 38, 9, 0, 0
  .byte entity_index_pufferfish, 19, 9, 0, 0
  .byte entity_index_treasure_chest, 41, 9, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_treasure_chest, 29, 33, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_treasure_chest, 31, 41, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

meadow3_entity_instances:
  .byte 9
  .byte entity_index_dungeon_entrance_statue, 9, 2, 0, DUNGEON_ENTRANCE_STATUE_PARAMS, 1, <6000, >6000
  .byte entity_index_treasure_chest, 21, 27, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_treasure_chest, 57, 41, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_octopus, 55, 41, 0, 0
  .byte entity_index_pufferfish, 19, 27, 0, 0
  .byte entity_index_pufferfish, 7, 37, 0, 0
  .byte entity_index_pufferfish, 25, 56, 0, 0
  .byte entity_index_octopus, 18, 14, 0, 0
  .byte entity_index_octopus, 53, 12, 0, 0

dungeon_0_0_entity_instances:
  .byte 5
  .byte entity_index_pufferfish, 3, 6, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 3, 10, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 11, 14, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_SHAKE_SCREEN_SET, 0, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_1_n, \
                                          0, 2

  .byte entity_index_monolith, 14, 8, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_0_w, \
                                          0, 5
  .byte entity_index_traproom, (0 * 16), (0 * 15), 0, 0

dungeon_1_0_entity_instances:
  .byte 2
  .byte entity_index_monolith, 17, 8, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_0_e, \
                                          0, 4

  .byte entity_index_monolith, 30, 8, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_2_0_w, \
                                          0, 5


dungeon_2_0_entity_instances:
  .byte 4
  .byte entity_index_anglerfish, 36, 5, 0, ANGLERFISH_PARAMS, ANGLERFISH_TURN_MODE_OPPOSITE, ANGLERFISH_PAUSE_MODE_NORMAL, ANGLERFISH_TURN_LENGTH_LONG, ENTITY_DIRECTION_RIGHT, ANGLERFISH_SPOTLIGHT_OFF, 0, 0
  .byte entity_index_spotlight_puzzle, 0, 0, 0, SPOTLIGHT_PUZZLE_PARAMS, SPOTLIGHT_PUZZLE_STATE_SINGLE_ANGLERFISH, DUNGEON1_DUNGEON_FLAGS_SINGLE_ANGLERFISH_COMPLETE, 40, 6
  .byte entity_index_monolith, 46, 10, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_KEYED | MONOLITH_FLAGS_UP_SET, DUNGEON1_DUNGEON_FLAGS_DOOR1_UNLOCKED, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_3_0_w, \
                                          1, 5

  .byte entity_index_monolith, 33, 8, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_1_0_e, \
                                          0, 4


dungeon_3_0_entity_instances:
  .byte 2
  .byte entity_index_monolith, 49, 10, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_2_0_e, \
                                          0, 4
  .byte entity_index_monolith, 55, 4, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_KEYED | MONOLITH_FLAGS_UP_SET, DUNGEON1_DUNGEON_FLAGS_DOOR2_UNLOCKED, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon1_boss_entrance, \
                                          1, 2

dungeon_0_1_entity_instances:
  .byte 5
  .byte entity_index_pufferfish, 4, 23, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 11, 23, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 4, 29, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_2_n, \
                                          0, 2

  .byte entity_index_monolith, 14, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_1_w, \
                                          0, 5

  .byte entity_index_monolith, 11, 19, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_0_s, \
                                          0, 2

dungeon_1_1_entity_instances:
  .byte 5
  .byte entity_index_crab, 22, 25, sprite_chr_group_index_crab, 0
  .byte entity_index_crab, 25, 20, sprite_chr_group_index_crab, 0
  .byte entity_index_monolith, 17, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_1_e, \
                                          0, 4

  .byte entity_index_monolith, 30, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_1_w, \
                                          0, 5
  .byte entity_index_treasure_room, 22, 25, 0, TREASURE_ROOM_PARAMS, DUNGEON1_DUNGEON_FLAGS_TREASURE_ROOM1_OBTAINED, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

dungeon_2_1_entity_instances:
  .byte 5
  .byte entity_index_pufferfish, 39, 23, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 39, 25, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 33, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_SHAKE_SCREEN_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_1_e, \
                                          0, 4

  .byte entity_index_monolith, 46, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_1_w, \
                                          0, 5
  .byte entity_index_traproom, (2 * 16), (1 * 15), 0, 0

dungeon_3_1_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 56, 21, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 49, 23, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_1_e, \
                                          0, 4

  .byte entity_index_monolith, 56, 29, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_2_n, \
                                          0, 2


dungeon_0_2_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 7, 38, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 7, 44, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_3_n, \
                                          0, 2

  .byte entity_index_monolith, 4, 34, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_1_s, \
                                          0, 2


dungeon_1_2_entity_instances:
  .byte 3
  .byte entity_index_pufferfish, 23, 35, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 30, 38, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_2_w, \
                                          0, 5

  .byte entity_index_monolith, 26, 44, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_3_n, \
                                          0, 2


dungeon_2_2_entity_instances:
  .byte 4
  .byte entity_index_pufferfish, 38, 36, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 38, 40, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 33, 38, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_2_e, \
                                          0, 4

  .byte entity_index_monolith, 46, 38, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_2_w, \
                                          0, 5


dungeon_3_2_entity_instances:
  .byte 4
  .byte entity_index_crab, 51, 40, sprite_chr_group_index_crab, 0
  .byte entity_index_crab, 59, 40, sprite_chr_group_index_crab, 0
  .byte entity_index_monolith, 49, 38, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_2_e, \
                                          0, 4

  .byte entity_index_monolith, 56, 34, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_3_1_s, \
                                          0, 2


dungeon_0_3_entity_instances:
  .byte 6
  .byte entity_index_treasure_chest, 3, 51, 0, TREASURE_CHEST_PARAMS, DUNGEON1_DUNGEON_FLAGS_TREASURE_CHEST1_OBTAINED, TREASURE_CHEST_MODE_DUNGEON, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_pufferfish, 11, 52, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_crab, 12, 52, sprite_chr_group_index_crab, 0
  .byte entity_index_monolith, 7, 49, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_SHAKE_SCREEN_SET, 0, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_0_2_s, \
                                          0, 2
  .byte entity_index_monolith, 7, 59, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED, 0, \
                                          MONOLITH_DIRECTION_SOUTH, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_meadow3_dungeon_entrance, \
                                          0, 2
  .byte entity_index_traproom, 0, (3*15), 0, 0

dungeon_1_3_entity_instances:
  .byte 4
  .byte entity_index_pufferfish, 22, 53, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 26, 49, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_SHAKE_SCREEN_SET, 0, \
                                          MONOLITH_DIRECTION_NORTH, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_2_s, \
                                          0, 2

  .byte entity_index_monolith, 30, 53, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_2_3_w, \
                                          0, 5
  .byte entity_index_traproom, (1 * 16), (3 * 15), 0

dungeon_2_3_entity_instances:
  .byte 5
  .byte entity_index_pufferfish, 39, 53, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_pufferfish, 36, 56, sprite_chr_group_index_pufferfish, 0
  .byte entity_index_monolith, 33, 53, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_SHAKE_SCREEN_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon_1_3_e, \
                                          0, 4

  .byte entity_index_monolith, 46, 56, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_3_3_w, \
                                          0, 5
  .byte entity_index_traproom, (2 * 16), (3 * 15), 0, 0

dungeon_3_3_entity_instances:
  .byte 4
  .byte entity_index_anglerfish, 52, 47, 0, ANGLERFISH_PARAMS, ANGLERFISH_TURN_MODE_LEFT, ANGLERFISH_PAUSE_MODE_NORMAL, ANGLERFISH_TURN_LENGTH, ENTITY_DIRECTION_DOWN, ANGLERFISH_SPOTLIGHT_OFF, 4, 4
  .byte entity_index_anglerfish, 59, 47, 0, ANGLERFISH_PARAMS, ANGLERFISH_TURN_MODE_RIGHT, ANGLERFISH_PAUSE_MODE_NORMAL, ANGLERFISH_TURN_LENGTH, ENTITY_DIRECTION_DOWN, ANGLERFISH_SPOTLIGHT_ON, 4, 4
  .byte entity_index_spotlight_puzzle, 0, 0, 0, SPOTLIGHT_PUZZLE_PARAMS, SPOTLIGHT_PUZZLE_STATE_TWIN_ANGLERFISH, DUNGEON1_DUNGEON_FLAGS_TWIN_ANGLERFISH_COMPLETE, 56, 51
  .byte entity_index_monolith, 49, 56, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon_2_3_e, \
                                          0, 4

dungeon1_boss_entity_instances:
  .byte 3
  .byte entity_index_octoboss_head, 4, 4, 0, 0
  .byte entity_index_monolith, 14, 11, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon1_boss_area_owl_dungeon, \
                                          0, 5
  .byte entity_index_monolith, 8, 14, 0,  MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET, 0, \
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
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon1_boss_area_east_exit, \
                                          0, 4

tundra1_entity_instances:
  .byte 9
  ;.byte entity_index_urchin, 40, 40, 0, URCHIN_PARAMS, 16*5, 40, <(256*2), >(256*2), 0, 0
  .byte entity_index_jellyfish, 45, 26, 0, 0
  .byte entity_index_jellyfish, 23, 30, 0, 0
  .byte entity_index_eel, 7, 18, 0, EEL_PARAMS, EEL_STATE_RIGHT_INIT
  .byte entity_index_eel, 9, 20, 0, EEL_PARAMS, EEL_STATE_LEFT_INIT
  .byte entity_index_eel, 28, 53, 0, EEL_PARAMS, EEL_STATE_RIGHT_INIT
  .byte entity_index_eel, 34, 53, 0, EEL_PARAMS, EEL_STATE_LEFT_INIT
  .byte entity_index_jellyfish, 10, 54, 0, 0
  .byte entity_index_treasure_chest, 7, 8, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_treasure_chest, 31, 53, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

tundra2_entity_instances:
  .byte 8
  .byte entity_index_jellyfish, 51, 14, 0, 0
  .byte entity_index_jellyfish, 22, 36, 0, 0
  .byte entity_index_jellyfish, 17, 55, 0, 0
  .byte entity_index_jellyfish, 9, 26, 0, 0
  .byte entity_index_jellyfish, 45, 39, 0, 0
  .byte entity_index_treasure_chest, 54, 14, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_treasure_chest, 29, 26, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000
  .byte entity_index_treasure_chest, 27, 52, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

tundra3_entity_instances:
  .byte 10
  .byte entity_index_eel, 18, 34, 0, EEL_PARAMS, EEL_STATE_RIGHT_INIT
  .byte entity_index_eel, 18, 36, 0, EEL_PARAMS, EEL_STATE_LEFT_INIT
  .byte entity_index_jellyfish, 6, 28, 0, 0
  .byte entity_index_jellyfish, 7, 9, 0, 0
  .byte entity_index_jellyfish, 26, 22, 0, 0
  .byte entity_index_jellyfish, 33, 51, 0, 0
  .byte entity_index_jellyfish, 45, 4, 0, 0
  .byte entity_index_jellyfish, 56, 24, 0, 0
  .byte entity_index_dungeon_entrance_statue, 43, 25, 0, DUNGEON_ENTRANCE_STATUE_PARAMS, 3, <15000, >15000
  .byte entity_index_treasure_chest, 17, 30, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

dungeon2_0_0_entity_instances:
  .byte 7
  .byte entity_index_monolith, 10, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_0_1_n,\
                                         0, 2

  .byte entity_index_monolith, 14, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_0_w,\
                                         0, 5
  .byte entity_index_urchin, 3, 11, 0, URCHIN_PARAMS, 8*6, 40, 0, 0, <(-256*2), >(-256*2)
  .byte entity_index_urchin, 6, 5, 0, URCHIN_PARAMS, 8*6, 40, 0, 0, <(256*2), >(256*2)
  .byte entity_index_urchin, 9, 11, 0, URCHIN_PARAMS, 8*6, 40, 0, 0, <(-256*2), >(-256*2)
  .byte entity_index_urchin, 12, 5, 0, URCHIN_PARAMS, 8*6, 40, 0, 0, <(256*2), >(256*2)
  .byte entity_index_treasure_chest, 2, 5, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_DUNGEON, TREASURE_CHEST_ITEM_TYPE_BOMB, <3, >3

dungeon2_1_0_entity_instances:
  .byte 4
  .byte entity_index_monolith, 26, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_1_n,\
                                         0, 2

  .byte entity_index_monolith, 17, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_0_0_e,\
                                         0, 4
  .byte entity_index_jellyfish, 21, 8, 0, 0
  .byte entity_index_jellyfish, 27, 8, 0, 0

dungeon2_2_0_entity_instances:
  .byte 6
  .byte entity_index_monolith, 46, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_3_0_w,\
                                         0, 5
  .byte entity_index_monolith, 36, 4, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon2_boss_entrance,\
                                         0, 2
  .byte entity_index_urchin, 35, 9, 0, URCHIN_PARAMS, 8*8, 40, <(256*2), >(256*2), 0, 0
  .byte entity_index_ice_block, 37, 5, 0, 0
  .byte entity_index_ice_block, 38, 5, 0, 0
  .byte entity_index_ice_block, 39, 5, 0, 0

dungeon2_3_0_entity_instances:
  .byte 4
  .byte entity_index_monolith, 59, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_3_1_n,\
                                         0, 2

  .byte entity_index_monolith, 49, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_KEYED | MONOLITH_FLAGS_UP_SET,\
                                         DUNGEON2_DUNGEON_FLAGS_DOOR2_UNLOCKED,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_2_0_e,\
                                         1, 4
  .byte entity_index_urchin, 52, 6, 0, URCHIN_PARAMS, 8*8, 40, <(256*2), >(256*2), 0, 0
  .byte entity_index_urchin, 52, 9, 0, URCHIN_PARAMS, 8*8, 40, <(256*2), >(256*2), 0, 0

dungeon2_0_1_entity_instances:
  .byte 5
  .byte entity_index_monolith, 10, 19, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_0_0_s,\
                                         0, 2
  .byte entity_index_urchin, 7, 20, 0, URCHIN_PARAMS, 8*6, 40, 0, 0, <(256*2), >(256*2)
  .byte entity_index_jellyfish, 2, 26, 0, 0
  .byte entity_index_eel, 13, 22, 0, EEL_PARAMS, EEL_STATE_LEFT_INIT
  .byte entity_index_ordered_defeat_puzzle, 3, 25, 0, ORDERED_DEFEAT_PUZZLE_PARAMS,\
                                                      entity_index_jellyfish,\
                                                      entity_index_urchin,\
                                                      entity_index_eel,\
                                                      DUNGEON2_DUNGEON_FLAGS_JELLYFISH_URCHIN_EEL_PUZZLE_COMPLETE,\
                                                      TREASURE_CHEST_ITEM_TYPE_KEY,\
                                                      <1, >1

dungeon2_1_1_entity_instances:
  .byte 4
  .byte entity_index_monolith, 26, 19, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_0_s,\
                                         0, 2

  .byte entity_index_monolith, 23, 29, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_2_n,\
                                         0, 2

  .byte entity_index_monolith, 30, 23, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_2_1_w,\
                                         0, 5
  .byte entity_index_jellyfish, 19, 23, 0, 0

dungeon2_2_1_entity_instances:
  .byte 4
  .byte entity_index_monolith, 33, 23, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_1_e,\
                                         0, 4
  .byte entity_index_jellyfish, 43, 20, 0, 0
  .byte entity_index_jellyfish, 43, 26, 0, 0
  .byte entity_index_treasure_room, 43, 23, 0, TREASURE_ROOM_PARAMS, DUNGEON2_DUNGEON_FLAGS_TREASURE_ROOM1_OBTAINED, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

dungeon2_3_1_entity_instances:
  .byte 3
  .byte entity_index_monolith, 59, 19, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_3_0_s,\
                                         0, 2

  .byte entity_index_monolith, 53, 29, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_3_2_n,\
                                         0, 2
  .byte entity_index_urchin, 56, 21, 0, URCHIN_PARAMS, 8*4, 40, 0, 0, <(256*2), >(256*2)

dungeon2_0_2_entity_instances:
  .byte 5
  .byte entity_index_monolith, 10, 44, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_0_3_n,\
                                         0, 2

  .byte entity_index_monolith, 14, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_2_w,\
                                         0, 5
  .byte entity_index_eel, 4, 36, 0, EEL_PARAMS, EEL_STATE_RIGHT_INIT
  .byte entity_index_eel, 12, 36, 0, EEL_PARAMS, EEL_STATE_LEFT_INIT
  .byte entity_index_eel, 7, 41, 0, EEL_PARAMS, EEL_STATE_RIGHT_INIT

dungeon2_1_2_entity_instances:
  .byte 6
  .byte entity_index_monolith, 23, 34, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_1_s,\
                                         0, 2

  .byte entity_index_monolith, 30, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_2_2_w,\
                                         0, 5

  .byte entity_index_monolith, 17, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_0_2_e,\
                                         0, 4
  .byte entity_index_urchin, 21, 37, 0, URCHIN_PARAMS, 8*2, 60, 0, 0, <(256*2), >(256*2)
  .byte entity_index_urchin, 24, 39, 0, URCHIN_PARAMS, 8*2, 60, 0, 0, <(-256*2), >(-256*2)
  .byte entity_index_urchin, 27, 37, 0, URCHIN_PARAMS, 8*2, 60, 0, 0, <(256*2), >(256*2)

dungeon2_2_2_entity_instances:
  .byte 4
  .byte entity_index_monolith, 42, 44, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_2_3_n,\
                                         0, 2

  .byte entity_index_monolith, 33, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_2_e,\
                                         0, 4
  .byte entity_index_urchin, 38, 35, 0, URCHIN_PARAMS, 8*6, 40, 0, 0, <(256*2), >(256*2)
  .byte entity_index_urchin, 41, 41, 0, URCHIN_PARAMS, 8*6, 40, 0, 0, <(-256*2), >(-256*2)

dungeon2_3_2_entity_instances:
  .byte 3
  .byte entity_index_monolith, 53, 34, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_KEYED | MONOLITH_FLAGS_UP_SET,\
                                         DUNGEON2_DUNGEON_FLAGS_DOOR1_UNLOCKED,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_3_1_s,\
                                         1, 2

  .byte entity_index_monolith, 53, 44, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_3_3_n,\
                                         0, 2
  .byte entity_index_jellyfish, 57, 37, 0, 0

dungeon2_0_3_entity_instances:
  .byte 7
  .byte entity_index_monolith, 10, 49, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_0_2_s,\
                                         0, 2

  .byte entity_index_monolith, 14, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_1_3_w,\
                                         0, 5
  .byte entity_index_eel, 4, 51, 0, EEL_PARAMS, EEL_STATE_RIGHT_INIT
  .byte entity_index_eel, 4, 55, 0, EEL_PARAMS, EEL_STATE_RIGHT_INIT
  .byte entity_index_eel, 11, 51, 0, EEL_PARAMS, EEL_STATE_LEFT_INIT
  .byte entity_index_eel, 11, 55, 0, EEL_PARAMS, EEL_STATE_LEFT_INIT
  .byte entity_index_treasure_room, 2, 53, 0, TREASURE_ROOM_PARAMS, DUNGEON2_DUNGEON_FLAGS_TREASURE_ROOM2_OBTAINED, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

dungeon2_1_3_entity_instances:
  .byte 4
  .byte entity_index_monolith, 17, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_0_3_e,\
                                         0, 4
  .byte entity_index_ice_block, 20, 53, 0, 0
  .byte entity_index_ice_block, 27, 53, 0, 0
  .byte entity_index_simultaneous_defeat_puzzle, 27, 55, 0, SIMULTANEOUS_DEFEAT_PUZZLE_PARAMS, DUNGEON2_DUNGEON_FLAGS_TWO_ICE_BLOCKS_PUZZLE_COMPLETE

dungeon2_2_3_entity_instances:
  .byte 3
  .byte entity_index_monolith, 42, 49, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_2_2_s,\
                                         0, 2

  .byte entity_index_monolith, 46, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_3_3_w,\
                                         0, 5
  .byte entity_index_monolith, 40, 59, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_GOTO_LOCATION_GROUP1, location_index_tundra3_dungeon2_entrance,\
                                         0, 2

dungeon2_3_3_entity_instances:
  .byte 3
  .byte entity_index_monolith, 53, 49, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_3_2_s,\
                                         0, 2

  .byte entity_index_monolith, 49, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon2_2_3_e,\
                                         0, 4
  .byte entity_index_jellyfish, 59, 52, 0, 0

dungeon2_boss_entity_instances:
  .byte 3
  .byte entity_index_swordfish_boss, 0, 2, 0, 0
  .byte entity_index_monolith, 13, 11, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon2_boss_owl_dungeon, \
                                          0, 2
  .byte entity_index_monolith, 7, 14, 0, MONOLITH_PARAMS, \
                                         MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                         MONOLITH_DIRECTION_SOUTH, \
                                         ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon2_2_0_n, \
                                         0, 1

dungeon2_boss_owl_dungeon_entity_instances:
  .byte 3
  .byte entity_index_cage, 23, 2, 0, 0
  .byte entity_index_rescueowl, 23, 3, 0, RESCUEOWL_PARAMS, RESCUEOWL_TYPE_SIBERIANEAGLEOWL
  .byte entity_index_monolith, 18, 11, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_WEST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon2_boss_east_exit, \
                                          0, 3

mountain1_entity_instances:
  .byte 11
  .byte entity_index_seahorse, 4, 55, 0, 0
  .byte entity_index_horseshoe_crab, 13, 23, 0, 0
  .byte entity_index_horseshoe_crab, 42, 21, 0, 0
  .byte entity_index_horseshoe_crab, 39, 6, 0, 0
  .byte entity_index_horseshoe_crab, 23, 22, 0, 0
  .byte entity_index_octopus, 30, 55, 0, 0
  .byte entity_index_octopus, 47, 55, 0, 0
  .byte entity_index_octopus, 9, 40, 0, 0
  .byte entity_index_octopus, 10, 8, 0, 0
  .byte entity_index_octopus, 57, 18, 0, 0
  .byte entity_index_dungeon_entrance_statue, 44, 31, 0, DUNGEON_ENTRANCE_STATUE_PARAMS, 3, <22000, >22000

cave_top_left_entity_instances:
  .byte 3
  .byte entity_index_horseshoe_crab, 12, 7, 0, 0
  .byte entity_index_horseshoe_crab, 26, 12, 0, 0
  .byte entity_index_treasure_chest, 26, 6, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

cave_bottom_left_entity_instances:
  .byte 4
  .byte entity_index_treasure_chest, 16, 36, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <3000, >3000
  .byte entity_index_horseshoe_crab, 12, 52, 0, 0
  .byte entity_index_horseshoe_crab, 5, 37, 0, 0
  .byte entity_index_horseshoe_crab, 4, 47, 0, 0

cave_bottom_right_entity_instances:
  .byte 5
  .byte entity_index_treasure_chest, 35, 36, 0, TREASURE_CHEST_PARAMS, INVENTORY_DUNGEON_FLAGS_MASK_NOP, TREASURE_CHEST_MODE_OVERWORLD, TREASURE_CHEST_ITEM_TYPE_GP, <10000, >10000
  .byte entity_index_horseshoe_crab, 35, 42, 0, 0
  .byte entity_index_horseshoe_crab, 43, 36, 0, 0
  .byte entity_index_horseshoe_crab, 59, 47, 0, 0
  .byte entity_index_horseshoe_crab, 49, 45, 0, 0

dungeon3_0_0_entity_instances:
  .byte 5
  .byte entity_index_horseshoe_crab, 10, 7, 0, 0
  .byte entity_index_horseshoe_crab, 10, 9, 0, 0
  .byte entity_index_monolith, 1, 7, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_GOTO_LOCATION_GROUP1, location_index_mountain1_dungeon3_entrance,\
                                         0, 4
  .byte entity_index_monolith, 8, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_0_1_n,\
                                         0, 2

  .byte entity_index_monolith, 14, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_0_w,\
                                         0, 5

dungeon3_1_0_entity_instances:
  .byte 7
  .byte entity_index_urchin, 21, 7, 0, URCHIN_PARAMS, 16*1, 40, 0, 0, <(256*2), >(256*2)
  .byte entity_index_horseshoe_crab, 23, 9, 0, 0
  .byte entity_index_horseshoe_crab, 25, 7, 0, 0
  .byte entity_index_urchin, 27, 9, 0, URCHIN_PARAMS, 16*1, 40, 0, 0, <(-256*2), >(-256*2)
  .byte entity_index_monolith, 24, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_1_n,\
                                         0, 2

  .byte entity_index_monolith, 30, 9, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_2_0_w,\
                                         0, 5

  .byte entity_index_monolith, 17, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_0_0_e,\
                                         0, 4

dungeon3_2_0_entity_instances:
  .byte 6
  .byte entity_index_urchin, 38, 5, 0, URCHIN_PARAMS, 16*1, 40, 0, 0, <(256*2), >(256*2)
  .byte entity_index_seahorse, 44, 6, 0, 0
  .byte entity_index_horseshoe_crab, 40, 9, 0, 0
  .byte entity_index_monolith, 46, 9, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_KEYED | MONOLITH_FLAGS_UP_SET,\
                                         DUNGEON3_DUNGEON_FLAGS_DOOR1_UNLOCKED,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_3_0_w,\
                                         1, 5
  .byte entity_index_monolith, 33, 9, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_0_e,\
                                         0, 4
  .byte entity_index_ordered_defeat_puzzle, 45, 5, 0, ORDERED_DEFEAT_PUZZLE_PARAMS,\
                                                      entity_index_seahorse,\
                                                      entity_index_horseshoe_crab,\
                                                      entity_index_urchin,\
                                                      DUNGEON3_DUNGEON_FLAGS_SEAHORSE_HORSESHOE_CRAB_URCHIN_PUZZLE_COMPLETE,\
                                                      TREASURE_CHEST_ITEM_TYPE_GP,\
                                                      <1000, >1000

dungeon3_3_0_entity_instances:
  .byte 4
  .byte entity_index_seahorse, 54, 8, 0, 0
  .byte entity_index_seahorse, 58, 8, 0, 0
  .byte entity_index_monolith, 56, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_3_1_n,\
                                         0, 2

  .byte entity_index_monolith, 49, 9, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_2_0_e,\
                                         0, 4

dungeon3_0_1_entity_instances:
  .byte 4
  .byte entity_index_crab, 4, 23, 0, 0
  .byte entity_index_crab, 11, 23, 0, 0
  .byte entity_index_monolith, 8, 19, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_0_0_s,\
                                         0, 2

  .byte entity_index_monolith, 8, 29, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_0_2_n,\
                                         0, 2

dungeon3_1_1_entity_instances:
  .byte 4
  .byte entity_index_crab, 22, 23, 0, 0
  .byte entity_index_crab, 26, 23, 0, 0
  .byte entity_index_monolith, 24, 19, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_0_s,\
                                         0, 2

  .byte entity_index_monolith, 30, 24, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_2_1_w,\
                                         0, 5

dungeon3_2_1_entity_instances:
  .byte 4
  .byte entity_index_horseshoe_crab, 40, 22, 0, 0
  .byte entity_index_seahorse, 45, 21, 0, 0
  .byte entity_index_monolith, 40, 29, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_2_2_n,\
                                         0, 2

  .byte entity_index_monolith, 33, 24, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_1_e,\
                                         0, 4

dungeon3_3_1_entity_instances:
  .byte 4
  .byte entity_index_crab, 53, 23, 0, 0
  .byte entity_index_crab, 57, 25, 0, 0
  .byte entity_index_monolith, 56, 19, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_3_0_s,\
                                         0, 2

  .byte entity_index_monolith, 56, 29, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_3_2_n,\
                                         0, 2

dungeon3_0_2_entity_instances:
  .byte 5
  .byte entity_index_seahorse, 4, 37, 0, 0
  .byte entity_index_seahorse, 11, 37, 0, 0
  .byte entity_index_seahorse, 7, 40, 0, 0
  .byte entity_index_monolith, 8, 34, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_0_1_s,\
                                         0, 2

  .byte entity_index_monolith, 14, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_2_w,\
                                         0, 5

dungeon3_1_2_entity_instances:
  .byte 7
  .byte entity_index_horseshoe_crab, 22, 38, 0, 0
  .byte entity_index_horseshoe_crab, 25, 38, 0, 0
  .byte entity_index_horseshoe_crab, 23, 37, 0, 0
  .byte entity_index_horseshoe_crab, 23, 39, 0, 0
  .byte entity_index_monolith, 24, 44, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_3_n,\
                                         0, 2

  .byte entity_index_monolith, 17, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_0_2_e,\
                                         0, 4
  .byte entity_index_treasure_room, 27, 37, 0, TREASURE_ROOM_PARAMS, DUNGEON3_DUNGEON_FLAGS_TREASURE_ROOM1_OBTAINED, TREASURE_CHEST_ITEM_TYPE_GP, <1000, >1000

dungeon3_2_2_entity_instances:
  .byte 6
  .byte entity_index_monolith, 40, 34, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_2_1_s,\
                                         0, 2

  .byte entity_index_monolith, 35, 39, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_NOP, 0,\
                                         0, 2

  .byte entity_index_monolith, 38, 39, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_NOP, 0,\
                                         0, 2

  .byte entity_index_monolith, 41, 39, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_NOP, 0,\
                                         0, 2

  .byte entity_index_monolith, 44, 39, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_NOP, 0,\
                                         0, 2
  .byte entity_index_monolith_puzzle, 45, 39, 0, MONOLITH_PUZZLE_PARAMS,\
                                               DUNGEON3_DUNGEON_FLAGS_MONOLITH_PUZZLE_COMPLETE,\
                                               %00110110,\
                                               TREASURE_CHEST_ITEM_TYPE_KEY,\
                                               <1,\
                                               >1

dungeon3_3_2_entity_instances:
  .byte 4
  .byte entity_index_seahorse, 53, 38, 0, 0
  .byte entity_index_seahorse, 59, 38, 0, 0
  .byte entity_index_monolith, 56, 34, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_3_1_s,\
                                         0, 2
  .byte entity_index_monolith, 56, 44, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_KEYED | MONOLITH_FLAGS_UP_SET,\
                                         DUNGEON3_DUNGEON_FLAGS_DOOR2_UNLOCKED,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_3_3_n,\
                                         1, 2

dungeon3_0_3_entity_instances:
  .byte 5
  .byte entity_index_anglerfish, 2, 48, 0, ANGLERFISH_PARAMS, ANGLERFISH_TURN_MODE_LEFT, ANGLERFISH_PAUSE_MODE_STOP_GO, ANGLERFISH_TURN_LENGTH, ENTITY_DIRECTION_RIGHT, ANGLERFISH_SPOTLIGHT_OFF, 0, 3
  .byte entity_index_anglerfish, 12, 48, 0, ANGLERFISH_PARAMS, ANGLERFISH_TURN_MODE_RIGHT, ANGLERFISH_PAUSE_MODE_STOP_GO, ANGLERFISH_TURN_LENGTH, ENTITY_DIRECTION_LEFT, ANGLERFISH_SPOTLIGHT_ON, 8, 3
  .byte entity_index_anglerfish, 4, 54, 0, ANGLERFISH_PARAMS, ANGLERFISH_TURN_MODE_OPPOSITE, ANGLERFISH_PAUSE_MODE_STOP_GO, ANGLERFISH_TURN_LENGTH_LONG, ENTITY_DIRECTION_RIGHT, ANGLERFISH_SPOTLIGHT_OFF, 8, 3
  .byte entity_index_triple_anglerfish_puzzle, 2, 51, 0, TRIPLE_ANGLERFISH_PUZZLE_PARAMS, 5, 49, 10, 49, 8, 55, DUNGEON3_DUNGEON_FLAGS_TRIPLE_ANGLERFISH_PUZZLE_COMPLETE
  .byte entity_index_monolith, 14, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon3_1_3_w,\
                                         0, 5

dungeon3_1_3_entity_instances:
  .byte 5
  .byte entity_index_urchin, 23, 50, 0, URCHIN_PARAMS, 16*3, 40, 0, 0, <(256*2), >(256*2)
  .byte entity_index_urchin, 25, 50, 0, URCHIN_PARAMS, 16*3, 40, 0, 0, <(256*2), >(256*2)
  .byte entity_index_monolith, 24, 49, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_2_s,\
                                         0, 2

  .byte entity_index_monolith, 30, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_2_3_w,\
                                         0, 5

  .byte entity_index_monolith, 17, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon3_0_3_e,\
                                         0, 4

dungeon3_2_3_entity_instances:
  .byte 3
  .byte entity_index_seahorse, 44, 51, 0, 0
  .byte entity_index_seahorse, 35, 55, 0, 0
  .byte entity_index_monolith, 33, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_1_3_e,\
                                         0, 4

dungeon3_3_3_entity_instances:
  .byte 7
  .byte entity_index_monolith, 56, 49, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon3_3_2_s,\
                                         0, 2
  .byte entity_index_monolith, 62, 54, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_KEYED | MONOLITH_FLAGS_UP_SET,\
                                          DUNGEON3_DUNGEON_FLAGS_DOOR3_UNLOCKED, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon3_boss_entrance, \
                                          1, 5

  .byte entity_index_monolith, 51, 54, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_NOP, 0,\
                                         0, 2
  .byte entity_index_monolith, 53, 54, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_NOP, 0,\
                                         0, 2
  .byte entity_index_monolith, 58, 54, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_NOP, 0,\
                                         0, 2

  .byte entity_index_monolith, 60, 54, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_NOP, 0,\
                                         0, 2
  .byte entity_index_monolith_puzzle, 55, 55, 0, MONOLITH_PUZZLE_PARAMS,\
                                               DUNGEON3_DUNGEON_FLAGS_MONOLITH_PUZZLE2_COMPLETE,\
                                               %11100001,\
                                               TREASURE_CHEST_ITEM_TYPE_KEY,\
                                               <1,\
                                               >1

dungeon3_boss_entity_instances:
  .byte 3
  .byte entity_index_crab_boss_body, 3, 6, 0, 0
  .byte entity_index_monolith, 14, 11, 0, MONOLITH_PARAMS, \
                                          MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET, 0, \
                                          MONOLITH_DIRECTION_EAST, \
                                          ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon3_boss_owl_dungeon, \
                                          0, 5
  .byte entity_index_monolith, 1, 11, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_LOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_GOTO_LOCATION_GROUP1, location_index_dungeon3_3_3_e,\
                                         0, 4

dungeon3_boss_owl_dungeon_entity_instances:
  .byte 2
  .byte entity_index_cage, 23, 3, 0, 0
  .byte entity_index_rescueowl, 23, 4, 0, RESCUEOWL_PARAMS, RESCUEOWL_TYPE_GREATGRAYOWL

island1_entity_instances:
  .byte 10
  .byte entity_index_starfish, 8, 48, 0, 0
  .byte entity_index_starfish, 2, 12, 0, 0
  .byte entity_index_starfish, 52, 10, 0, 0
  .byte entity_index_starfish, 23, 9, 0, 0
  .byte entity_index_starfish, 28, 36, 0, 0
  .byte entity_index_clam, 2, 58, 0, 0
  .byte entity_index_clam, 2, 5, 0, 0
  .byte entity_index_clam, 42, 45, 0, 0
  .byte entity_index_clam, 52, 3, 0, 0
  .byte entity_index_clam, 60, 58, 0, 0

island2_entity_instances:
  .byte 8
  .byte entity_index_clam, 4, 27, 0, 0
  .byte entity_index_clam, 5, 48, 0, 0
  .byte entity_index_clam, 40, 59, 0, 0
  .byte entity_index_clam, 60, 23, 0, 0
  .byte entity_index_starfish, 15, 6, 0, 0
  .byte entity_index_starfish, 26, 45, 0, 0
  .byte entity_index_starfish, 46, 43, 0, 0
  .byte entity_index_starfish, 48, 25, 0, 0

temple1_entity_instances:
  .byte 9
  .byte entity_index_starfish, 15, 51, 0, 0
  .byte entity_index_starfish, 49, 51, 0, 0
  .byte entity_index_clam, 31, 47, 0, 0
  .byte entity_index_clam, 14, 39, 0, 0
  .byte entity_index_clam, 48, 39, 0, 0
  .byte entity_index_seahorse, 19, 21, 0, 0
  .byte entity_index_seahorse, 47, 13, 0, 0
  .byte entity_index_seahorse, 20, 5, 0, 0
  .byte entity_index_dungeon_entrance_statue, 15, 1, 0, DUNGEON_ENTRANCE_STATUE_PARAMS, 2, <30000, >30000

dungeon4_0_0_entity_instances:
  .byte 2
  .byte entity_index_monolith, 14, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_0_w,\
                                         0, 5
  .byte entity_index_monolith, 4, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_GOTO_LOCATION_GROUP1, location_index_temple1_dungeon4_entrance,\
                                         0, 2

dungeon4_1_0_entity_instances:
  .byte 3
  .byte entity_index_monolith, 20, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_1_n,\
                                         0, 2

  .byte entity_index_monolith, 30, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_0_w,\
                                         0, 5

  .byte entity_index_monolith, 17, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_0_0_e,\
                                         0, 4

dungeon4_2_0_entity_instances:
  .byte 2
  .byte entity_index_monolith, 46, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_3_0_w,\
                                         0, 5

  .byte entity_index_monolith, 33, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_0_e,\
                                         0, 4

dungeon4_3_0_entity_instances:
  .byte 2
  .byte entity_index_monolith, 55, 14, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_3_1_n,\
                                         0, 2

  .byte entity_index_monolith, 49, 8, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_0_e,\
                                         0, 4

dungeon4_0_1_entity_instances:
  .byte 1
  .byte entity_index_monolith, 14, 26, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_1_w,\
                                         0, 5

dungeon4_1_1_entity_instances:
  .byte 4
  .byte entity_index_monolith, 20, 19, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_0_s,\
                                         0, 2

  .byte entity_index_monolith, 20, 29, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_2_n,\
                                         0, 2

  .byte entity_index_monolith, 30, 23, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_1_w,\
                                         0, 5

  .byte entity_index_monolith, 17, 26, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_0_1_e,\
                                         0, 4

dungeon4_2_1_entity_instances:
  .byte 1
  .byte entity_index_monolith, 33, 23, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_1_e,\
                                         0, 4

dungeon4_3_1_entity_instances:
  .byte 10
  .byte entity_index_monolith, 55, 19, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_3_0_s,\
                                         0, 2
  .byte entity_index_switch, 52, 20, 0, SWITCH_PARAMS, 6, 7, 0, %00000010
  .byte entity_index_switch, 55, 20, 0, SWITCH_PARAMS, 6, 7, 1, %00000100
  .byte entity_index_switch, 58, 20, 0, SWITCH_PARAMS, 6, 7, 2, %00001000
  .byte entity_index_switch, 52, 23, 0, SWITCH_PARAMS, 6, 7, 3, %00010000
  .byte entity_index_switch, 55, 23, 0, SWITCH_PARAMS, 6, 7, 4, %00100000
  .byte entity_index_switch, 58, 23, 0, SWITCH_PARAMS, 6, 7, 5, %01000000
  .byte entity_index_switch, 49, 23, 0, SWITCH_PARAMS, 6, 7, 6, %10000000
  .byte entity_index_switch, 61, 23, 0, SWITCH_PARAMS, 6, 7, 7, %00000000
  .byte entity_index_switch_puzzle, 55, 22, 0, SWITCH_PUZZLE_PARAMS, DUNGEON4_DUNGEON_FLAGS_SWITCH_PUZZLE2_COMPLETE, TREASURE_CHEST_ITEM_TYPE_KEY, <1, >1

dungeon4_0_2_entity_instances:
  .byte 8
  .byte entity_index_monolith, 14, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_2_w,\
                                         0, 5
  .byte entity_index_switch, 2, 36, 0, SWITCH_PARAMS, 6, 7, 0, %00000000
  .byte entity_index_switch, 6, 36, 0, SWITCH_PARAMS, 6, 7, 1, %00000100
  .byte entity_index_switch, 10, 36, 0, SWITCH_PARAMS, 6, 7, 2, %00000001
  .byte entity_index_switch, 2, 39, 0, SWITCH_PARAMS, 6, 7, 3, %00000111
  .byte entity_index_switch, 6, 39, 0, SWITCH_PARAMS, 6, 7, 4, %00000010
  .byte entity_index_switch, 10, 39, 0, SWITCH_PARAMS, 6, 7, 5, %0001001
  .byte entity_index_switch_puzzle, 13, 35, 0, SWITCH_PUZZLE_PARAMS, DUNGEON4_DUNGEON_FLAGS_SWITCH_PUZZLE1_COMPLETE, TREASURE_CHEST_ITEM_TYPE_KEY, <1, >1

dungeon4_1_2_entity_instances:
  .byte 3
  .byte entity_index_monolith, 20, 34, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_1_s,\
                                         0, 2

  .byte entity_index_monolith, 30, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_2_w,\
                                         0, 5

  .byte entity_index_monolith, 17, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_0_2_e,\
                                         0, 4

dungeon4_2_2_entity_instances:
  .byte 3
  .byte entity_index_monolith, 39, 44, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_SOUTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_3_n,\
                                         0, 2

  .byte entity_index_monolith, 46, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_3_2_w,\
                                         0, 5

  .byte entity_index_monolith, 33, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_2_e,\
                                         0, 4

dungeon4_3_2_entity_instances:
  .byte 1
  .byte entity_index_monolith, 49, 38, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_2_e,\
                                         0, 4

dungeon4_0_3_entity_instances:
  .byte 1
  .byte entity_index_monolith, 14, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_3_w,\
                                         0, 5

dungeon4_1_3_entity_instances:
  .byte 2
  .byte entity_index_monolith, 30, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_3_w,\
                                         0, 5

  .byte entity_index_monolith, 17, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_0_3_e,\
                                         0, 4

dungeon4_2_3_entity_instances:
  .byte 3
  .byte entity_index_monolith, 39, 49, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_NORTH,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_2_s,\
                                         0, 2

  .byte entity_index_monolith, 46, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_EAST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_3_3_w,\
                                         0, 5

  .byte entity_index_monolith, 33, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_1_3_e,\
                                         0, 4

dungeon4_3_3_entity_instances:
  .byte 1
  .byte entity_index_monolith, 49, 53, 0, MONOLITH_PARAMS,\
                                         MONOLITH_TYPE_UNLOCKED | MONOLITH_FLAGS_UP_SET,\
                                         0,\
                                         MONOLITH_DIRECTION_WEST,\
                                         ACTION_SCROLLTO_LOCATION_GROUP1, location_index_dungeon4_2_3_e,\
                                         0, 4

;****************************************************************
;Palettes.
;****************************************************************
village_palette:
  .byte $0e,$19,$12,$22,$0e,$00,$10,$38,$0e,$0e,$0a,$19,$0e,$07,$06,$36
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte PALETTE_CYCLE_LOOP

house_palette:
  .byte $0e,$04,$14,$37,$0e,$07,$17,$27,$0e,$02,$12,$22,$0e,$08,$18,$37
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$1a,$36,$0e,$0e,$15,$36
  .byte PALETTE_CYCLE_LOOP

meadow1_palette:
  .byte $0e,$0a,$08,$19,$0e,$0a,$19,$15,$0e,$0a,$19,$28,$0e,$08,$19,$18
  .byte $0e,$0e,$06,$37,$0e,$0e,$18,$20,$0e,$0e,$28,$20,$0e,$0e,$0e,$0e
  .byte PALETTE_CYCLE_LOOP

meadow2_palette:
  .byte $0e,$0a,$08,$19,$0e,$0a,$19,$15,$0e,$0a,$19,$28,$0e,$08,$19,$18
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31
  .byte PALETTE_CYCLE_LOOP

meadow3_palette:
  .byte $0e,$0a,$08,$19,$0e,$08,$19,$18,$0e,$08,$19,$28,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31
  .byte PALETTE_CYCLE_LOOP

dungeon_palette:
  .byte $0e,$1b,$0b,$08,$0e,$0b,$19,$2a,$0e,$0b,$08,$18,$0e,$08,$07,$28
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31
  .byte 15,$28,PALETTE_CYCLE_END_FRAME
  .byte PALETTE_CYCLE_END_FRAME
  .byte 15,$18,PALETTE_CYCLE_END_FRAME
  .byte PALETTE_CYCLE_END_FRAME
  .byte PALETTE_CYCLE_LOOP

dungeon1_boss_palette:
  .byte $0e,$1b,$0b,$08,$0e,$0b,$19,$2a,$0e,$0b,$08,$18,$0e,$08,$01,$12
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$01,$31
  .byte PALETTE_CYCLE_LOOP

dungeon1_boss_owl_dungeon_palette:
  .byte $0e,$1b,$0b,$08,$0e,$0b,$19,$2a,$0e,$0b,$08,$18,$0e,$08,$01,$12
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$08,$20,$0e,$00,$28,$10
  .byte PALETTE_CYCLE_LOOP

tundra1_palette:
  .byte $0e,$00,$10,$20,$0e,$12,$22,$20,$0e,$21,$31,$20,$0e,$10,$31,$20
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$12,$21,$0e,$21,$31,$20
  .byte PALETTE_CYCLE_LOOP

dungeon2_palette:
  .byte $0e,$12,$21,$20,$0e,$21,$31,$20,$0e,$0c,$22,$32,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$12,$21,$0e,$21,$31,$20
  .byte PALETTE_CYCLE_LOOP

dungeon2_boss_palette:
  .byte $0e,$12,$21,$20,$0e,$21,$21,$21,$0e,$0c,$22,$32,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$01,$22,$0e,$0e,$0e,$0e
  .byte 6,$21,7,$31,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$21,7,$20,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$21,7,$31,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$31,7,$20,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$20,7,$21,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$31,7,$21,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte PALETTE_CYCLE_LOOP

dungeon2_boss_owl_dungeon_palette:
  .byte $0e,$12,$21,$20,$0e,$21,$31,$20,$0e,$0c,$22,$32,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$10,$20,$0e,$00,$16,$10
  .byte 6,$21,7,$31,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$21,7,$20,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$21,7,$31,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$31,7,$20,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$20,7,$21,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 6,$31,7,$21,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte PALETTE_CYCLE_LOOP

mountain1_palette:
  .byte $0e,$07,$17,$26,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$05,$15,$0e,$0e,$07,$17
  .byte PALETTE_CYCLE_LOOP

cave_palette:
  .byte $0e,$07,$17,$26,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$05,$15,$0e,$0e,$07,$17
  .byte PALETTE_CYCLE_LOOP

dungeon3_palette:
  .byte $0e,$16,$26,$36,$0e,$07,$17,$27,$0e,$0e,$07,$16,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$05,$15,$0e,$0e,$07,$17
  .byte PALETTE_CYCLE_LOOP

dungeon3_0_3_palette:
  .byte $0e,$16,$26,$36,$0e,$07,$17,$27,$0e,$0e,$07,$16,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$09,$19,$0e,$0e,$10,$20
  .byte PALETTE_CYCLE_LOOP

dungeon3_boss_palette:
  .byte $0e,$16,$26,$36,$0e,$07,$17,$27,$0e,$0e,$07,$16,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$07,$17,$0e,$0e,$07,$20
  .byte PALETTE_CYCLE_LOOP

dungeon3_boss_owl_dungeon_palette:
  .byte $0e,$16,$26,$36,$0e,$07,$17,$27,$0e,$0e,$07,$16,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$10,$20,$0e,$00,$28,$10
  .byte PALETTE_CYCLE_LOOP

island_palette:
  .byte $37,$0e,$09,$19,$37,$0e,$09,$18,$37,$09,$18,$20,$37,$21,$31,$20
  .byte $37,$0e,$06,$36,$37,$0e,$18,$20,$37,$0e,$13,$23,$37,$0e,$14,$24
  .byte 14,$21,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 14,$21,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 14,$21,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 14,$31,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 14,$20,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte 14,$31,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME,PALETTE_CYCLE_END_FRAME
  .byte PALETTE_CYCLE_LOOP

temple_palette:
  .byte $37,$0e,$09,$19,$37,$0e,$09,$18,$37,$09,$18,$20,$37,$0e,$18,$28
  .byte $37,$0e,$06,$36,$37,$0e,$18,$20,$37,$0e,$13,$23,$37,$0e,$14,$24
  .byte PALETTE_CYCLE_LOOP

dungeon4_palette:
  .byte $0e,$18,$28,$37,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0e,$0e,$06,$36,$0e,$0e,$18,$20,$0e,$0e,$13,$23,$0e,$0e,$14,$24
  .byte PALETTE_CYCLE_LOOP

;****************************************************************
;Location definitions.
;****************************************************************

;village locations
village_house1_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_sprite_chr_groups, village_entity_instances, village_palette,\
                         18, 18, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_DOWN

village_housel_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_sprite_chr_groups, village_entity_instances, village_palette,\
                         19, 35, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_DOWN

village_houser_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_sprite_chr_groups, village_entity_instances, village_palette,\
                         43, 35, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_DOWN

village_housebl_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_sprite_chr_groups, village_entity_instances, village_palette,\
                         19, 48, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_DOWN

village_housebr_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_sprite_chr_groups, village_entity_instances, village_palette,\
                         43, 48, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_DOWN

village_housetr_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_village, village_sprite_chr_groups, village_entity_instances, village_palette,\
                         43, 18, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_DOWN

village_bottom_entrance:
define_south_location LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_village, village_sprite_chr_groups, village_entity_instances, village_palette,\
                      31, 54, 0, 0, 0, ENTITY_DIRECTION_UP

;house1 locations
house1_intro:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_house, house_sprite_chr_groups, house1_intro_entity_instances, house_palette,\
                         11, 13, 0, 0, 0, ENTITY_DIRECTION_UP

house1_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_house, house_sprite_chr_groups, house1_entity_instances, house_palette,\
                         14, 25, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_UP

;housel locations
housel_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_housel, house_sprite_chr_groups, housel_entity_instances, house_palette,\
                         25, 25, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_UP

;houser locations
houser_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_houser, house_sprite_chr_groups, houser_entity_instances, house_palette,\
                         16, 25, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_UP

;housebl locations
housebl_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_housebl, house_sprite_chr_groups, housebl_entity_instances, house_palette,\
                         14, 25, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_UP

;housebr locations
housebr_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_housebr, house_sprite_chr_groups, housebr_entity_instances, house_palette,\
                         14, 25, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_UP

;housetr locations
housetr_exit:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_housetr, house_sprite_chr_groups, housetr_entity_instances, house_palette,\
                         14, 25, sfx_door, 3, soundeffect_one, ENTITY_DIRECTION_UP

;meadow1 locations
meadow1_top_entrance:
define_north_location LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_meadow1, meadow1_sprite_chr_groups, meadow1_entity_instances, meadow1_palette,\
                      29, 1, 0, 0, 0, ENTITY_DIRECTION_DOWN

meadow1_west_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow1, meadow1_sprite_chr_groups, meadow1_entity_instances, meadow1_palette,\
                0, 16, 1, 24,\
                0, 0, 0, ENTITY_DIRECTION_RIGHT

;meadow2 locations
meadow2_north_entrance:
define_north_location LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_meadow2, meadow2_sprite_chr_groups, meadow2_entity_instances, meadow2_palette,\
                        8, 1, 0, 0, 0, ENTITY_DIRECTION_DOWN

meadow2_east_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow2, meadow2_sprite_chr_groups, meadow2_entity_instances, meadow2_palette,\
                48, 15, 62, 22,\
                0, 0, 0, ENTITY_DIRECTION_LEFT

;meadow3 locations
meadow3_southwest_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                area_index_meadow3, meadow3_sprite_chr_groups, meadow3_entity_instances, meadow3_palette,\
                0, 50, 8, 61,\
                0, 0, 0, ENTITY_DIRECTION_UP

meadow3_dungeon_entrance:
define_location LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_meadow3, meadow3_sprite_chr_groups, meadow3_entity_instances, meadow3_palette,\
                        1, 0, 9, 2,\
                        0, 0, 0, ENTITY_DIRECTION_DOWN

;dungeon locations
dungeon_2_3_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 42, 54, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon_0_3_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4 | LOCATION_FLAGS_DUNGEON_ENTRANCE)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_3_entity_instances, dungeon_palette, 0, 45, 7, 55, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon_0_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_3_entity_instances, dungeon_palette, 0, 45, 7, 49, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon_0_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_2_entity_instances, dungeon_palette, 0, 30, 7, 40, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon_0_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_2_entity_instances, dungeon_palette, 0, 30, 4, 34, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon_0_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 4, 25, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon_0_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 13, 22, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_0_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_1_entity_instances, dungeon_palette, 0, 15, 11, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon_0_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_0_entity_instances, dungeon_palette, 0, 0, 11, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon_0_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_0_0_entity_instances, dungeon_palette, 0, 0, 13, 7, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_1_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_1_0_entity_instances, dungeon_palette, 16, 0, 18, 7, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_1_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_1_0_entity_instances, dungeon_palette, 16, 0, 29, 7, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_1_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_1_1_entity_instances, dungeon_palette, 16, 15, 18, 22, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_1_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_1_1_entity_instances, dungeon_palette, 16, 15, 29, 22, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_2_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_2_1_entity_instances, dungeon_palette, 32, 15, 34, 22, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_1_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_1_2_entity_instances, dungeon_palette, 16, 30, 29, 37, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_1_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_1_2_entity_instances, dungeon_palette, 16, 30, 26, 40, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon_1_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_1_3_entity_instances, dungeon_palette, 16, 45, 26, 49, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon_1_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_1_3_entity_instances, dungeon_palette, 16, 45, 29, 52, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_2_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 34, 52, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_2_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_2_3_entity_instances, dungeon_palette, 32, 45, 45, 55, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_3_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_anglerfish_puzzle_sprite_chr_groups, dungeon_3_3_entity_instances, dungeon_palette, 48, 45, 50, 55, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_2_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_2_2_entity_instances, dungeon_palette, 32, 30, 34, 37, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_2_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_2_2_entity_instances, dungeon_palette, 32, 30, 45, 37, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_3_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_3_2_entity_instances, dungeon_palette, 48, 30, 50, 37, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_2_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_2_1_entity_instances, dungeon_palette, 32, 15, 45, 22, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_3_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_3_1_entity_instances, dungeon_palette, 48, 15, 50, 22, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_2_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_anglerfish_puzzle_sprite_chr_groups, dungeon_2_0_entity_instances, dungeon_palette, 32, 0, 45, 9, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon_3_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_3_0_entity_instances, dungeon_palette, 48, 0, 50, 9, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_2_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_anglerfish_puzzle_sprite_chr_groups, dungeon_2_0_entity_instances, dungeon_palette, 32, 0, 34, 7, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon_3_0_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_3_0_entity_instances, dungeon_palette, 48, 0, 55, 4, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon_3_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_3_1_entity_instances, dungeon_palette, 48, 15, 56, 25, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon_3_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)}, area_index_dungeon, dungeon_sprite_chr_groups, dungeon_3_2_entity_instances, dungeon_palette, 48, 30, 56, 34, 0, 0, 0, ENTITY_DIRECTION_DOWN

dungeon1_boss_area_entrance:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon1_boss, dungeon1_boss_sprite_chr_groups, dungeon1_boss_entity_instances, dungeon1_boss_palette,\
                        0, 0, 8, 10,\
                        0, 0, 0, ENTITY_DIRECTION_UP

dungeon1_boss_area_east_exit:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon1_boss, dungeon1_boss_sprite_chr_groups, dungeon1_boss_entity_instances, dungeon1_boss_palette,\
                        0, 0, 13, 10,\
                        0, 0, 0, ENTITY_DIRECTION_LEFT

dungeon1_boss_area_owl_dungeon:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon1_boss, dungeon1_boss_owl_dungeon_sprite_chr_groups, dungeon1_boss_owl_dungeon_entity_instances, dungeon1_boss_owl_dungeon_palette,\
                        16, 0, 18, 10,\
                        0, 0, 0, ENTITY_DIRECTION_RIGHT

tundra1_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_tundra1, tundra1_sprite_chr_groups, tundra1_entity_instances, tundra1_palette,\
                         45, 42, 0, 0, 0, ENTITY_DIRECTION_DOWN

tundra1_north_entrance:
define_north_location LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_tundra1, tundra1_sprite_chr_groups, tundra1_entity_instances, tundra1_palette,\
                        45, 1, 0, 0, 0, ENTITY_DIRECTION_DOWN

tundra1_south_entrance:
define_south_location LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_tundra1, tundra1_sprite_chr_groups, tundra1_entity_instances, tundra1_palette,\
                      24, 62, 0, 0, 0, ENTITY_DIRECTION_UP

tundra2_south_entrance:
define_south_location LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_tundra2, tundra2_sprite_chr_groups, tundra2_entity_instances, tundra1_palette,\
                      45, 62, 0, 0, 0, ENTITY_DIRECTION_UP

tundra3_north_entrance:
define_north_location LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_tundra3, tundra3_sprite_chr_groups, tundra3_entity_instances, tundra1_palette,\
                      24, 1, 0, 0, 0, ENTITY_DIRECTION_DOWN

tundra3_dungeon2_entrance:
define_centered_location LOCATION_BRIGHTNESS_LEVEL_4,\
                         area_index_tundra3, tundra3_sprite_chr_groups, tundra3_entity_instances, tundra1_palette,\
                         43, 26, 0, 0, 0, ENTITY_DIRECTION_DOWN

dungeon2_0_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_0_0_entity_instances,dungeon2_palette,0, 0, 10, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_0_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_0_0_entity_instances,dungeon2_palette,0, 0, 13, 7, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon2_1_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_0_entity_instances,dungeon2_palette,16, 0, 26, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_1_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_0_entity_instances,dungeon2_palette,16, 0, 18, 7, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon2_2_0_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_2_0_entity_instances,dungeon2_palette,32, 0, 36, 4, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_2_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_2_0_entity_instances,dungeon2_palette,32, 0, 45, 7, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon2_3_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_3_0_entity_instances,dungeon2_palette,48, 0, 59, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_3_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_3_0_entity_instances,dungeon2_palette,48, 0, 50, 7, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon2_0_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_0_1_entity_instances,dungeon2_palette,0, 15, 10, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_1_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_1_entity_instances,dungeon2_palette,16, 15, 26, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_1_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_1_entity_instances,dungeon2_palette,16, 15, 23, 25, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_1_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_1_entity_instances,dungeon2_palette,16, 15, 29, 22, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon2_2_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_2_1_entity_instances,dungeon2_palette,32, 15, 34, 22, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon2_3_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_3_1_entity_instances,dungeon2_palette,48, 15, 59, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_3_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_3_1_entity_instances,dungeon2_palette,48, 15, 58, 25, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_0_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_0_2_entity_instances,dungeon2_palette,0, 30, 10, 40, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_0_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_0_2_entity_instances,dungeon2_palette,0, 30, 13, 37, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon2_1_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_2_entity_instances,dungeon2_palette,16, 30, 23, 34, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_1_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_2_entity_instances,dungeon2_palette,16, 30, 29, 37, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon2_1_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_2_entity_instances,dungeon2_palette,16, 30, 18, 37, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon2_2_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_2_2_entity_instances,dungeon2_palette,32, 30, 42, 40, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_2_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_2_2_entity_instances,dungeon2_palette,32, 30, 34, 37, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon2_3_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_3_2_entity_instances,dungeon2_palette,48, 30, 58, 34, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_3_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_3_2_entity_instances,dungeon2_palette,48, 30, 53, 40, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_0_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_0_3_entity_instances,dungeon2_palette,0, 45, 10, 49, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_0_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_0_3_entity_instances,dungeon2_palette,0, 45, 13, 52, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon2_1_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_1_3_entity_instances,dungeon2_palette,16, 45, 18, 52, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon2_2_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_2_3_entity_instances,dungeon2_palette,32, 45, 42, 49, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_2_3_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4 | LOCATION_FLAGS_DUNGEON_ENTRANCE)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_2_3_entity_instances,dungeon2_palette,32, 45, 40, 55, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon2_2_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_2_3_entity_instances,dungeon2_palette,32, 45, 45, 52, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon2_3_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_3_3_entity_instances,dungeon2_palette,48, 45, 53, 49, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon2_3_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon2,dungeon2_sprite_chr_groups,dungeon2_3_3_entity_instances,dungeon2_palette,48, 45, 50, 52, 0, 0, 0, ENTITY_DIRECTION_RIGHT

dungeon2_boss_area_entrance:
define_location LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_dungeon2_boss, dungeon2_boss_sprite_chr_groups, dungeon2_boss_entity_instances, dungeon2_boss_palette,\
                      0, 0, 7, 10,\
                      0, 0, 0, ENTITY_DIRECTION_UP

dungeon2_boss_area_east_exit:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon2_boss, dungeon2_boss_sprite_chr_groups, dungeon2_boss_entity_instances, dungeon2_boss_palette,\
                        0, 0, 12, 10,\
                        0, 0, 0, ENTITY_DIRECTION_LEFT

dungeon2_boss_area_owl_dungeon:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon2_boss, dungeon2_boss_owl_dungeon_sprite_chr_groups, dungeon2_boss_owl_dungeon_entity_instances, dungeon2_boss_owl_dungeon_palette,\
                        16, 0, 19, 10,\
                        0, 0, 0, ENTITY_DIRECTION_RIGHT

mountain1_south_entrance:
define_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                      area_index_mountain1, mountain1_sprite_chr_groups, mountain1_entity_instances, mountain1_palette,\
                      0, 50, 8, 55,\
                      0, 0, 0, ENTITY_DIRECTION_UP

mountain1_dungeon3_entrance:
define_centered_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                               area_index_mountain1, mountain1_sprite_chr_groups, mountain1_entity_instances, mountain1_palette,\
                               44, 33, 0, 0, 0, ENTITY_DIRECTION_DOWN

mountain1_top_left_cave_entrance:
define_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                               area_index_mountain1, mountain1_sprite_chr_groups, mountain1_entity_instances, mountain1_palette,\
                               2, 0, 10, 3, 0, 0, 0, ENTITY_DIRECTION_DOWN

mountain1_bottom_left_cave_entrance:
define_centered_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                               area_index_mountain1, mountain1_sprite_chr_groups, mountain1_entity_instances, mountain1_palette,\
                               10, 51, 0, 0, 0, ENTITY_DIRECTION_DOWN

mountain1_bottom_right_cave_entrance:
define_centered_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                               area_index_mountain1, mountain1_sprite_chr_groups, mountain1_entity_instances, mountain1_palette,\
                               56, 50, 0, 0, 0, ENTITY_DIRECTION_DOWN

cave_top_left:
define_location   LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_0,\
                        area_index_cave, cave_sprite_chr_groups, cave_top_left_entity_instances, cave_palette,\
                        0, 0, 9, 12,\
                        0, 0, 0, ENTITY_DIRECTION_UP

cave_bottom_left:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_0,\
                        area_index_cave, cave_sprite_chr_groups, cave_bottom_left_entity_instances, cave_palette,\
                        3, 48, 15, 56,\
                        0, 0, 0, ENTITY_DIRECTION_UP

cave_bottom_right:
define_location   LOCATION_BRIGHTNESS_LEVEL_0,\
                        area_index_cave, cave_sprite_chr_groups, cave_bottom_right_entity_instances, cave_palette,\
                        32, 48, 40, 56,\
                        0, 0, 0, ENTITY_DIRECTION_UP

dungeon3_entrance:
define_location   {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4 | LOCATION_FLAGS_DUNGEON_ENTRANCE)},\
                        area_index_dungeon3, dungeon3_sprite_chr_groups, dungeon3_0_0_entity_instances, dungeon3_palette,\
                        0, 0, 2, 6,\
                        0, 0, 0, ENTITY_DIRECTION_RIGHT

dungeon3_0_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_0_0_entity_instances,dungeon3_palette,0, 0, 8, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon3_0_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_0_0_entity_instances,dungeon3_palette,0, 0, 13, 7, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon3_1_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_0_entity_instances,dungeon3_palette,16, 0, 24, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon3_1_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_0_entity_instances,dungeon3_palette,16, 0, 29, 8, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon3_1_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_0_entity_instances,dungeon3_palette,16, 0, 18, 7, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon3_2_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_2_0_entity_instances,dungeon3_palette,32, 0, 45, 8, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon3_2_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_2_0_entity_instances,dungeon3_palette,32, 0, 34, 8, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon3_3_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_3_0_entity_instances,dungeon3_palette,48, 0, 56, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon3_3_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_3_0_entity_instances,dungeon3_palette,48, 0, 50, 8, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon3_0_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_0_1_entity_instances,dungeon3_palette,0, 15, 8, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon3_0_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_0_1_entity_instances,dungeon3_palette,0, 15, 8, 25, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon3_1_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_1_entity_instances,dungeon3_palette,16, 15, 24, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon3_1_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_1_entity_instances,dungeon3_palette,16, 15, 29, 23, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon3_2_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_2_1_entity_instances,dungeon3_palette,32, 15, 40, 25, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon3_2_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_2_1_entity_instances,dungeon3_palette,32, 15, 34, 23, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon3_3_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_3_1_entity_instances,dungeon3_palette,48, 15, 56, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon3_3_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_3_1_entity_instances,dungeon3_palette,48, 15, 56, 25, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon3_0_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_0_2_entity_instances,dungeon3_palette,0, 30, 8, 34, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon3_0_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_0_2_entity_instances,dungeon3_palette,0, 30, 13, 37, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon3_1_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_2_entity_instances,dungeon3_palette,16, 30, 24, 40, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon3_1_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_2_entity_instances,dungeon3_palette,16, 30, 18, 37, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon3_2_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_2_2_entity_instances,dungeon3_palette,32, 30, 40, 34, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon3_3_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_3_2_entity_instances,dungeon3_palette,48, 30, 56, 34, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon3_3_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_3_2_entity_instances,dungeon3_palette,48, 30, 56, 40, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon3_0_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_0)},area_index_dungeon3,dungeon3_0_3_sprite_chr_groups,dungeon3_0_3_entity_instances,dungeon3_0_3_palette,0, 45, 13, 52, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon3_1_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_3_entity_instances,dungeon3_palette,16, 45, 24, 49, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon3_1_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_3_entity_instances,dungeon3_palette,16, 45, 29, 52, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon3_1_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_1_3_entity_instances,dungeon3_palette,16, 45, 18, 52, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon3_2_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_2_3_entity_instances,dungeon3_palette,32, 45, 34, 51, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon3_3_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_3_3_entity_instances,dungeon3_palette,48, 45, 56, 49, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon3_3_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3,dungeon3_sprite_chr_groups,dungeon3_3_3_entity_instances,dungeon3_palette,48, 45, 61, 53, 0, 0, 0, ENTITY_DIRECTION_LEFT

dungeon3_boss_area_entrance:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon3_boss,dungeon3_boss_sprite_chr_groups,dungeon3_boss_entity_instances,dungeon3_boss_palette,0, 0, 2, 10, 0, 0, 0, ENTITY_DIRECTION_RIGHT

dungeon3_boss_area_owl_dungeon:
define_location   LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | \
                  LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | \
                  LOCATION_BRIGHTNESS_LEVEL_4,\
                        area_index_dungeon3_boss, dungeon3_boss_owl_dungeon_sprite_chr_groups, dungeon3_boss_owl_dungeon_entity_instances, dungeon3_boss_owl_dungeon_palette,\
                        16, 0, 18, 10,\
                        0, 0, 0, ENTITY_DIRECTION_RIGHT

island1_entrance:
define_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                  area_index_island1, island1_sprite_chr_groups, island1_entity_instances, island_palette,\
                  0, 50, 4, 57,\
                  0, 0, 0, ENTITY_DIRECTION_UP

island1_north_exit:
define_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                  area_index_island1, island1_sprite_chr_groups, island1_entity_instances, island_palette,\
                  8, 0, 16, 0,\
                  0, 0, 0, ENTITY_DIRECTION_DOWN

island2_entrance:
define_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                  area_index_island2, island2_sprite_chr_groups, island2_entity_instances, island_palette,\
                  4, 50, 13, 61,\
                  0, 0, 0, ENTITY_DIRECTION_UP

island2_north_exit:
define_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                  area_index_island2, island2_sprite_chr_groups, island2_entity_instances, island_palette,\
                  6, 0, 14, 0,\
                  0, 0, 0, ENTITY_DIRECTION_DOWN

temple1_entrance:
define_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                  area_index_temple1, temple1_sprite_chr_groups, temple1_entity_instances, temple_palette,\
                  0, 50, 9, 61,\
                  0, 0, 0, ENTITY_DIRECTION_UP

temple1_dungeon4_entrance:
define_location   LOCATION_BRIGHTNESS_LEVEL_4,\
                  area_index_temple1, temple1_sprite_chr_groups, temple1_entity_instances, temple_palette,\
                  8, 0, 15, 2,\
                  0, 0, 0, ENTITY_DIRECTION_DOWN

dungeon4_entrance:
define_location   {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},\
                  area_index_dungeon4, dungeon4_sprite_chr_groups, dungeon4_0_0_entity_instances, dungeon4_palette,\
                  0, 0, 4, 10,\
                  0, 0, 0, ENTITY_DIRECTION_UP

dungeon4_0_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_0_0_entity_instances,dungeon4_palette,0, 0, 4, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon4_0_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_0_0_entity_instances,dungeon4_palette,0, 0, 13, 7, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_0_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_0_1_entity_instances,dungeon4_palette,0, 15, 13, 25, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_1_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_0_entity_instances,dungeon4_palette,16, 0, 20, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon4_1_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_0_entity_instances,dungeon4_palette,16, 0, 29, 7, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_1_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_0_entity_instances,dungeon4_palette,16, 0, 18, 7, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_2_0_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_0_entity_instances,dungeon4_palette,32, 0, 45, 7, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_2_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_0_entity_instances,dungeon4_palette,32, 0, 34, 7, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_3_0_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_3_0_entity_instances,dungeon4_palette,48, 0, 55, 10, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon4_3_0_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_3_0_entity_instances,dungeon4_palette,48, 0, 50, 7, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_1_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_1_entity_instances,dungeon4_palette,16, 15, 20, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon4_1_1_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_1_entity_instances,dungeon4_palette,16, 15, 20, 25, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon4_1_1_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_1_entity_instances,dungeon4_palette,16, 15, 29, 22, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_1_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_1_entity_instances,dungeon4_palette,16, 15, 18, 26, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_2_1_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_1_entity_instances,dungeon4_palette,32, 15, 34, 22, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_3_1_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_3_1_entity_instances,dungeon4_palette,48, 15, 55, 19, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon4_0_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_0_2_entity_instances,dungeon4_palette,0, 30, 13, 37, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_1_2_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_2_entity_instances,dungeon4_palette,16, 30, 20, 34, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon4_1_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_2_entity_instances,dungeon4_palette,16, 30, 29, 37, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_1_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_2_entity_instances,dungeon4_palette,16, 30, 18, 37, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_2_2_s:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_2_entity_instances,dungeon4_palette,32, 30, 39, 40, 0, 0, 0, ENTITY_DIRECTION_UP
dungeon4_2_2_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_2_entity_instances,dungeon4_palette,32, 30, 45, 37, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_2_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_2_entity_instances,dungeon4_palette,32, 30, 34, 37, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_3_2_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_3_2_entity_instances,dungeon4_palette,48, 30, 50, 37, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_0_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_0_3_entity_instances,dungeon4_palette,0, 45, 13, 52, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_1_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_3_entity_instances,dungeon4_palette,16, 45, 29, 52, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_1_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_1_3_entity_instances,dungeon4_palette,16, 45, 18, 52, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_2_3_n:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_3_entity_instances,dungeon4_palette,32, 45, 39, 49, 0, 0, 0, ENTITY_DIRECTION_DOWN
dungeon4_2_3_e:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_3_entity_instances,dungeon4_palette,32, 45, 45, 52, 0, 0, 0, ENTITY_DIRECTION_LEFT
dungeon4_2_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_2_3_entity_instances,dungeon4_palette,32, 45, 34, 52, 0, 0, 0, ENTITY_DIRECTION_RIGHT
dungeon4_3_3_w:
define_location {(LOCATION_FLAGS_CAMERA_X_SCROLLING_DISABLED_SET | LOCATION_FLAGS_CAMERA_Y_SCROLLING_DISABLED_SET | LOCATION_BRIGHTNESS_LEVEL_4)},area_index_dungeon4,dungeon4_sprite_chr_groups,dungeon4_3_3_entity_instances,dungeon4_palette,48, 45, 50, 52, 0, 0, 0, ENTITY_DIRECTION_RIGHT
