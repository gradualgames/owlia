.linecont +
.ifndef MONOLITH_CONSTANTS_INC
MONOLITH_CONSTANTS_INC = 1

MONOLITH_WIDTH = $0f
MONOLITH_HEIGHT = $0f

MONOLITH_Y_OFFSET = 32

MONOLITH_INSERTED_KEY_X_OFFSET = 1
MONOLITH_INSERTED_KEY_Y_OFFSET = -33

MONOLITH_KEYHOLE_X_OFFSET = 1
MONOLITH_KEYHOLE_Y_OFFSET = -60

MONOLITH_TYPE_UNLOCKED             = %00000000
MONOLITH_TYPE_KEYED                = %00000001
MONOLITH_TYPE_LOCKED               = %00000010

MONOLITH_TYPE_ISOLATE              = %00000011
MONOLITH_TYPE_CLEAR                = %11111100

MONOLITH_FLAGS_SHAKE_SCREEN_SET    = %00000100
MONOLITH_FLAGS_SHAKE_SCREEN_CLEAR  = %11111011
MONOLITH_FLAGS_SHAKE_SCREEN_TEST   = %00000100

MONOLITH_FLAGS_UP_SET              = %00001000
MONOLITH_FLAGS_DOWN_CLEAR          = %11110111
MONOLITH_FLAGS_UP_OR_DOWN_ISOLATE  = %00001000

MONOLITH_FLAGS_EXIT_ENABLED_SET    = %00010000
MONOLITH_FLAGS_EXIT_DISABLED_CLEAR = %11101111
MONOLITH_FLAGS_EXIT_ENABLED_TEST   = %00010000

MONOLITH_FLAGS_UNLOCKED_SET        = %00100000
MONOLITH_FLAGS_UNLOCKED_CLEAR      = %11011111
MONOLITH_FLAGS_UNLOCKED_TEST       = %00100000

.enum
MONOLITH_DIRECTION_EAST
MONOLITH_DIRECTION_WEST
MONOLITH_DIRECTION_SOUTH
MONOLITH_DIRECTION_NORTH
.endenum

MONOLITH_SHAKE_SCREEN_COUNTER = 20

.enum
MONOLITH_STATE_INIT
MONOLITH_STATE_FALL_INIT
MONOLITH_STATE_FALL
MONOLITH_STATE_RISE_INIT
MONOLITH_STATE_RISE
MONOLITH_STATE_IDLE
.endenum

MONOLITH_PARAMS = 7

define_entity_properties monolith_flags,\
                         monolith_unlock_immediately_dungeon_flags_mask,\
                         monolith_direction,\
                         monolith_goto_location_action,\
                         monolith_location_index,\
                         monolith_foreground_patch_index,\
                         monolith_background_patch_index,\
                         \
                         monolith_state_counter,\
                         monolith_patch_row,\
                         monolith_patch_column, \
                         monolith_inserted_key_index

.endif
