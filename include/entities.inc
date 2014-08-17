.ifndef ENTITIES_INC
ENTITIES_INC = 1

.feature force_range

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
.endenum

entity_update_bank_instance_placeholder = 5
entity_update_bank_explosion = 5
entity_update_bank_bomb = 5
entity_update_bank_octopus = 5
entity_update_bank_npc = 5
entity_update_bank_key = 5
entity_update_bank_treasure_chest = 5
entity_update_bank_lantern = 5
entity_update_bank_item = 5
entity_update_bank_innkeep = 5
entity_update_bank_pufferfish = 5
entity_update_bank_crab = 5
entity_update_bank_traproom = 5
entity_update_bank_treasure_room = 5
entity_update_bank_anglerfish = 5
entity_update_bank_spotlight = 5
entity_update_bank_spotlight_puzzle = 5
entity_update_bank_octoboss_head = 5
entity_update_bank_octoboss_legs = 5
entity_update_bank_splash = 5
entity_update_bank_intro = 5
entity_update_bank_silmaran = 5
entity_update_bank_rescueowl = 5
entity_update_bank_cage = 5
entity_update_bank_monolith = 5

;entity_sprites_and_animations_bank_instance_placeholder ;this entity has no graphics
entity_sprites_and_animations_bank_explosion = 6
entity_sprites_and_animations_bank_bomb = 6
entity_sprites_and_animations_bank_octopus = 6
entity_sprites_and_animations_bank_npc = 6
entity_sprites_and_animations_bank_key = 6
entity_sprites_and_animations_bank_treasure_chest = 6
entity_sprites_and_animations_bank_lantern = 6
entity_sprites_and_animations_bank_item = 6
entity_sprites_and_animations_bank_innkeep = 6
entity_sprites_and_animations_bank_pufferfish = 6
entity_sprites_and_animations_bank_crab = 6
;entity_sprites_and_animations_bank_traproom ;this entity has no graphics
;entity_sprites_and_animations_bank_treasure_room ;this entity has no graphics
entity_sprites_and_animations_bank_anglerfish = 6
entity_sprites_and_animations_bank_spotlight = 6
;entity_sprites_and_animations_bank_spotlight_puzzle ;this entity has no graphics
entity_sprites_and_animations_bank_octoboss_head = 6
entity_sprites_and_animations_bank_octoboss_legs = 6
entity_sprites_and_animations_bank_splash = 6
entity_sprites_and_animations_bank_intro = 6
entity_sprites_and_animations_bank_silmaran = 6
entity_sprites_and_animations_bank_rescueowl = 6
entity_sprites_and_animations_bank_cage = 6
;entity_sprites_and_animations_bank_monolith ;this entity has no graphics

.endif
