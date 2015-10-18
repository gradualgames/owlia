.linecont +
.ifndef TREASURE_CHEST_CONSTANTS_INC
TREASURE_CHEST_CONSTANTS_INC = 1

TREASURE_CHEST_WIDTH = 15
TREASURE_CHEST_HEIGHT = 34

TREASURE_CHEST_RECT_PADDING = 10
TREASURE_CHEST_STATE_OPENING_LENGTH = 10
TREASURE_CHEST_HERO_WAIT_FRAMES = 50

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

.enum
TREASURE_CHEST_MODE_DUNGEON
TREASURE_CHEST_MODE_OVERWORLD
.endenum

TREASURE_CHEST_PARAMS = 5

define_entity_properties treasure_chest_dungeon_flags_mask,\
                         treasure_chest_mode,\
                         treasure_chest_item_type,\
                         treasure_chest_item_quantity_lo,\
                         treasure_chest_item_quantity_hi,\
                         \
                         treasure_chest_item_index,\
                         treasure_chest_state_counter

.endif
