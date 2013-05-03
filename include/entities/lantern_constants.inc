.ifndef LANTERN_CONSTANTS_INC
LANTERN_CONSTANTS_INC = 1

LANTERN_WIDTH = $07
LANTERN_HEIGHT = $07

LANTERN_BRIGHTNESS_LEVELS = 4

LANTERN_CARRIED_X_OFFSET = 4
LANTERN_CARRIED_Y_OFFSET = 16

;how many frames before changing brightness level
LANTERN_BRIGHTNESS_LEVEL_SPEED = 5

lantern_brightness_level = entity_local0
lantern_state_counter = entity_local1
lantern_saved_brightness_level = entity_local2

.enum
LANTERN_STATE_INIT
LANTERN_STATE_MAIN
LANTERN_STATE_REVERT_BRIGHTNESS
.endenum

.endif
