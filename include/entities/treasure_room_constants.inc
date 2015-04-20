.linecont +
.ifndef TREASURE_ROOM_CONSTANTS_INC
TREASURE_ROOM_CONSTANTS_INC = 1

.enum
TREASURE_ROOM_STATE_INIT
TREASURE_ROOM_STATE_MAIN
TREASURE_ROOM_STATE_SPAWN_TREASURE_CHEST
.endenum

TREASURE_ROOM_PARAMS = 4

define_entity_properties treasure_room_dungeon_flags_mask,\
                         treasure_room_treasure_chest_type,\
                         treasure_room_treasure_chest_quantity_lo,\
                         treasure_room_treasure_chest_quantity_hi,\
                         \
                         treasure_room_state_counter

.endif
