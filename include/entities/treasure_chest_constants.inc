.ifndef TREASURE_CHEST_CONSTANTS_INC
TREASURE_CHEST_CONSTANTS_INC = 1

TREASURE_CHEST_WIDTH = $0f
TREASURE_CHEST_HEIGHT = $0f

TREASURE_CHEST_STATE_OPENING_LENGTH = 10

.enum
TREASURE_CHEST_STATE_INIT
TREASURE_CHEST_STATE_IDLE
TREASURE_CHEST_STATE_OPENING
TREASURE_CHEST_STATE_OPENED
.endenum

.enum
TREASURE_CHEST_ITEM_TYPE_KEY
TREASURE_CHEST_ITEM_TYPE_GP
TREASURE_CHEST_ITEM_TYPE_HEALTH
TREASURE_CHEST_ITEM_TYPE_LANTERN
TREASURE_CHEST_ITEM_TYPE_BOMB
.endenum

TREASURE_CHEST_PARAMS = 4

treasure_chest_puzzle_flags_mask = entity_local0
treasure_chest_item_type = entity_local1
treasure_chest_item_quantity_lo = entity_local2
treasure_chest_item_quantity_hi = entity_local3

treasure_chest_item_index = entity_local4
treasure_chest_state_counter = entity_local5

.endif
