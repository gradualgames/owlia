.ifndef ENTITIES_INC
ENTITIES_INC = 1

.global entity_defs_update_address_lo
.global entity_defs_update_address_hi
.global entity_defs_update_address_bank

.enum
entity_index_explosion
entity_index_bomb
entity_index_jellyfish
entity_index_npc
entity_index_key
entity_index_keyeddoor
entity_index_lantern
entity_index_item
entity_index_innkeep
.endenum

entity_update_bank_explosion = 3
entity_update_bank_bomb = 3
entity_update_bank_jellyfish = 3
entity_update_bank_npc = 3
entity_update_bank_key = 3
entity_update_bank_keyeddoor = 4
entity_update_bank_lantern = 4
entity_update_bank_item = 4
entity_update_bank_innkeep = 4

.endif
