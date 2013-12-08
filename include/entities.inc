.ifndef ENTITIES_INC
ENTITIES_INC = 1

.global entity_defs_update_address_lo
.global entity_defs_update_address_hi
.global entity_defs_update_address_bank
.global entity_defs_sprites_and_animations_bank

.enum
entity_index_explosion
entity_index_bomb
entity_index_octopus
entity_index_npc
entity_index_key
entity_index_door
entity_index_lantern
entity_index_item
entity_index_innkeep
entity_index_pufferfish
entity_index_crab
entity_index_traproom
entity_index_anglerfish
entity_index_spotlight
entity_index_spotlight_puzzle
entity_index_octoboss_head
entity_index_octoboss_legs
entity_index_splash
.endenum

entity_update_bank_explosion = 3
entity_update_bank_bomb = 3
entity_update_bank_octopus = 3
entity_update_bank_npc = 3
entity_update_bank_key = 3
entity_update_bank_door = 3
entity_update_bank_lantern = 4
entity_update_bank_item = 4
entity_update_bank_innkeep = 4
entity_update_bank_pufferfish = 4
entity_update_bank_crab = 4
entity_update_bank_traproom = 4
entity_update_bank_anglerfish = 4
entity_update_bank_spotlight = 4
entity_update_bank_spotlight_puzzle = 4
entity_update_bank_octoboss_head = 4
entity_update_bank_octoboss_legs = 4
entity_update_bank_splash = 4

entity_sprites_and_animations_bank_explosion = 0
entity_sprites_and_animations_bank_bomb = 0
entity_sprites_and_animations_bank_octopus = 0
entity_sprites_and_animations_bank_npc = 0
entity_sprites_and_animations_bank_key = 1
entity_sprites_and_animations_bank_door = 1
entity_sprites_and_animations_bank_lantern = 0
entity_sprites_and_animations_bank_item = 0
entity_sprites_and_animations_bank_innkeep = 1
entity_sprites_and_animations_bank_pufferfish = 1
entity_sprites_and_animations_bank_crab = 1
;entity_sprites_and_animations_bank_traproom ;this entity has no graphics
entity_sprites_and_animations_bank_anglerfish = 1
entity_sprites_and_animations_bank_spotlight = 1
;entity_sprites_and_animations_bank_spotlight_puzzle ;this entity has no graphics
entity_sprites_and_animations_bank_octoboss_head = 3
entity_sprites_and_animations_bank_octoboss_legs = 3
entity_sprites_and_animations_bank_splash = 3

.endif
