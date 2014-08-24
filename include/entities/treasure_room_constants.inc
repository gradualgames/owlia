.ifndef TREASURE_ROOM_CONSTANTS_INC
TREASURE_ROOM_CONSTANTS_INC = 1

.enum
TREASURE_ROOM_STATE_INIT
TREASURE_ROOM_STATE_MAIN
TREASURE_ROOM_STATE_SPAWN_TREASURE_CHEST
.endenum

TREASURE_ROOM_PARAMS = 4

treasure_room_dungeon_flags_mask = entity_local0
treasure_room_treasure_chest_type = entity_local1
treasure_room_treasure_chest_quantity_lo = entity_local2
treasure_room_treasure_chest_quantity_hi = entity_local3

treasure_room_state_counter = entity_local4

.endif
