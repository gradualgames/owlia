.ifndef ENTITIES_INC
ENTITIES_INC = 1

.feature force_range

ENTITIES_BANK = 0

.global entity_defs_update_address_lo
.global entity_defs_update_address_hi
.global entity_defs_update_address_bank
.global entity_defs_sprites_and_animations_bank

.enum
entity_index_instance_placeholder
entity_index_explosion
entity_index_projectile
entity_index_bomb
entity_index_octopus
entity_index_npc
entity_index_key
entity_index_treasure_chest
entity_index_lantern
entity_index_item
entity_index_pufferfish
entity_index_crab
entity_index_traproom
entity_index_treasure_room
entity_index_anglerfish
entity_index_spotlight
entity_index_spotlight_puzzle
entity_index_octoboss_head
entity_index_octoboss_legs
entity_index_splash
entity_index_intro
entity_index_silmaran
entity_index_rescueowl
entity_index_cage
entity_index_monolith
entity_index_dungeon_entrance_statue
entity_index_eel
entity_index_jellyfish
entity_index_urchin
entity_index_ice_shards_explosion
entity_index_bombable_wall
entity_index_ice_block
entity_index_ordered_defeat_puzzle
entity_index_simultaneous_defeat_puzzle
entity_index_swordfish_boss
entity_index_horseshoe_crab
entity_index_monolith_puzzle
entity_index_triple_anglerfish_puzzle
entity_index_seahorse
entity_index_crab_boss_body
entity_index_crab_boss_pincer
entity_index_crab_boss_eye
entity_index_starfish
entity_index_tunicate
entity_index_clam
entity_index_switch
entity_index_switch_puzzle
entity_index_ray
entity_index_boss
entity_index_target
entity_index_shooting_gallery
entity_index_bottle
entity_index_ring
entity_index_submarine_scene
.endenum

entity_update_bank_instance_placeholder = 4
entity_update_bank_explosion = 4
entity_update_bank_projectile = 4
entity_update_bank_bomb = 4
entity_update_bank_octopus = 4
entity_update_bank_npc = 4
entity_update_bank_key = 4
entity_update_bank_treasure_chest = 4
entity_update_bank_lantern = 4
entity_update_bank_item = 4
entity_update_bank_pufferfish = 4
entity_update_bank_crab = 4
entity_update_bank_traproom = 4
entity_update_bank_treasure_room = 4
entity_update_bank_anglerfish = 4
entity_update_bank_spotlight = 4
entity_update_bank_spotlight_puzzle = 4
entity_update_bank_octoboss_head = 4
entity_update_bank_octoboss_legs = 4
entity_update_bank_splash = 4
entity_update_bank_intro = 4
entity_update_bank_silmaran = 4
entity_update_bank_rescueowl = 4
entity_update_bank_cage = 4
entity_update_bank_monolith = 4
entity_update_bank_dungeon_entrance_statue = 4
entity_update_bank_eel = 4
entity_update_bank_jellyfish = 5
entity_update_bank_urchin = 5
entity_update_bank_ice_shards_explosion = 5
entity_update_bank_bombable_wall = 5
entity_update_bank_ice_block = 5
entity_update_bank_ordered_defeat_puzzle = 5
entity_update_bank_simultaneous_defeat_puzzle = 5
entity_update_bank_swordfish_boss = 5
entity_update_bank_horseshoe_crab = 5
entity_update_bank_monolith_puzzle = 5
entity_update_bank_triple_anglerfish_puzzle = 5
entity_update_bank_seahorse = 5
entity_update_bank_crab_boss_body = 5
entity_update_bank_crab_boss_pincer = 5
entity_update_bank_crab_boss_eye = 5
entity_update_bank_starfish = 5
entity_update_bank_tunicate = 5
entity_update_bank_clam = 5
entity_update_bank_switch = 5
entity_update_bank_switch_puzzle = 5
entity_update_bank_ray = 5
entity_update_bank_boss = 5
entity_update_bank_target = 5
entity_update_bank_shooting_gallery = 5
entity_update_bank_bottle = 5
entity_update_bank_ring = 5
entity_update_bank_submarine_scene = 5

;entity_sprites_and_animations_bank_instance_placeholder ;this entity has no graphics
entity_sprites_and_animations_bank_explosion = 7
entity_sprites_and_animations_bank_projectile = 7
entity_sprites_and_animations_bank_bomb = 7
entity_sprites_and_animations_bank_octopus = 7
entity_sprites_and_animations_bank_npc = 7
entity_sprites_and_animations_bank_key = 7
entity_sprites_and_animations_bank_treasure_chest = 7
entity_sprites_and_animations_bank_lantern = 7
entity_sprites_and_animations_bank_item = 7
entity_sprites_and_animations_bank_pufferfish = 7
entity_sprites_and_animations_bank_crab = 7
;entity_sprites_and_animations_bank_traproom ;this entity has no graphics
;entity_sprites_and_animations_bank_treasure_room ;this entity has no graphics
entity_sprites_and_animations_bank_anglerfish = 7
entity_sprites_and_animations_bank_spotlight = 7
;entity_sprites_and_animations_bank_spotlight_puzzle ;this entity has no graphics
entity_sprites_and_animations_bank_octoboss_head = 7
entity_sprites_and_animations_bank_octoboss_legs = 7
entity_sprites_and_animations_bank_splash = 7
entity_sprites_and_animations_bank_intro = 7
entity_sprites_and_animations_bank_silmaran = 7
entity_sprites_and_animations_bank_rescueowl = 7
entity_sprites_and_animations_bank_cage = 7
;entity_sprites_and_animations_bank_monolith ;this entity has no graphics
entity_sprites_and_animations_bank_dungeon_entrance_statue = 7
entity_sprites_and_animations_bank_eel = 7
entity_sprites_and_animations_bank_jellyfish = 7
entity_sprites_and_animations_bank_urchin = 7
entity_sprites_and_animations_bank_ice_shards_explosion = 7
;entity_sprites_and_animations_bank_bombable_wall ;this entity has no graphics
entity_sprites_and_animations_bank_ice_block = 7
;entity_sprites_and_animations_bank_ordered_defeat_puzzle ;this entity has no graphics
;entity_sprites_and_animations_bank_simultaneous_defeat_puzzle ;this entity has no graphics
entity_sprites_and_animations_bank_swordfish_boss = 7
entity_sprites_and_animations_bank_horseshoe_crab = 7
;entity_sprites_and_animations_bank_monolith_puzzle ;this entity has no graphics
;entity_sprites_and_animations_bank_triple_anglerfish_puzzle ;this entity has no graphics
entity_sprites_and_animations_bank_seahorse = 7
entity_sprites_and_animations_bank_crab_boss_body = 7
entity_sprites_and_animations_bank_crab_boss_pincer = 7
entity_sprites_and_animations_bank_crab_boss_eye = 7
entity_sprites_and_animations_bank_starfish = 7
entity_sprites_and_animations_bank_tunicate = 7
entity_sprites_and_animations_bank_clam = 7
;entity_sprites_and_animations_bank_switch ;this entity has no graphics
;entity_sprites_and_animations_bank_switch_puzzle ;this entity has no graphics
entity_sprites_and_animations_bank_ray = 7
;entity_sprites_and_animations_bank_boss ;this entity has no graphics
entity_sprites_and_animations_bank_target = 7
;entity_sprites_and_animations_bank_shooting_gallery ;this entity has no graphics
entity_sprites_and_animations_bank_bottle = 7
entity_sprites_and_animations_bank_ring = 7
entity_sprites_and_animations_bank_submarine_scene = 7

.endif
