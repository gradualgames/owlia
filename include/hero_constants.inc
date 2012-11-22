.include "ram.inc"

.ifndef HERO_CONSTANTS_INC
HERO_CONSTANTS_INC = 1

HERO_WIDTH = $10
HERO_HEIGHT = $18

.enum
HERO_STATE_INIT
HERO_STATE_MAIN
HERO_STATE_ATTACK
.endenum

HERO_FLAGS_DEADLY_SET    = %00000001
HERO_FLAGS_DEADLY_TEST   = %00000001
HERO_FLAGS_DEADLY_CLEAR  = %11111110

HERO_STATE_ATTACK_LENGTH = 20

HERO_KNOCKBACK_LENGTH = 5

HERO_INVINCIBILITY_LENGTH = 40

;knockback speed. This must be a power of 2 to work well with the map engine.
HERO_KNOCKBACK_SPEED = $04
;this mask makes certain that the hero always moves on power 2 grids on the
;map. It is used to cancel out the two lowest bits of the hero's x and y
;coordinate. If knockback speed is changed to another power of 2, this mask
;must be changed also.
HERO_KNOCKBACK_COORDINATE_MASK = %11111100

;hero's normal walking speed. This must be a power of 2 to work well with the
;map engine.
HERO_SPEED = $02

.enum
HERO_DIRECTION_RIGHT
HERO_DIRECTION_LEFT
HERO_DIRECTION_DOWN
HERO_DIRECTION_UP
.endenum

.endif
