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
entity_index_bomb
entity_index_octopus
entity_index_npc
entity_index_key
entity_index_treasure_chest
entity_index_lantern
entity_index_item
entity_index_innkeep
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
.endenum

entity_update_bank_instance_placeholder = 4
entity_update_bank_explosion = 4
entity_update_bank_bomb = 4
entity_update_bank_octopus = 4
entity_update_bank_npc = 4
entity_update_bank_key = 4
entity_update_bank_treasure_chest = 4
entity_update_bank_lantern = 4
entity_update_bank_item = 4
entity_update_bank_innkeep = 4
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

;entity_sprites_and_animations_bank_instance_placeholder ;this entity has no graphics
entity_sprites_and_animations_bank_explosion = 7
entity_sprites_and_animations_bank_bomb = 7
entity_sprites_and_animations_bank_octopus = 7
entity_sprites_and_animations_bank_npc = 7
entity_sprites_and_animations_bank_key = 7
entity_sprites_and_animations_bank_treasure_chest = 7
entity_sprites_and_animations_bank_lantern = 7
entity_sprites_and_animations_bank_item = 7
entity_sprites_and_animations_bank_innkeep = 7
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

.endif
