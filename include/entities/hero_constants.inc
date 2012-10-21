.include "ram.inc"

.ifndef HERO_CONSTANTS_INC
HERO_CONSTANTS_INC = 1

HERO_WIDTH = $10
HERO_HEIGHT = $18

HERO_STATE_INIT   = 0
HERO_STATE_MAIN   = 1
HERO_STATE_ATTACK = 2

HERO_STATE_ATTACK_LENGTH = 20

HERO_SPEED = $02

hero_previous_direction = entity_local0
hero_state_counter = entity_local1

.enum
HERO_DIRECTION_RIGHT
HERO_DIRECTION_LEFT
HERO_DIRECTION_DOWN
HERO_DIRECTION_UP
.endenum

.endif
