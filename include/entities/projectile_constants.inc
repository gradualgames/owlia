.ifndef PROJECTILE_CONSTANTS_INC
PROJECTILE_CONSTANTS_INC = 1

PROJECTILE_WIDTH = $07
PROJECTILE_HEIGHT = $07

PROJECTILE_INITIAL_LIFE = 100

PROJECTILE_ORTHOGONAL_VELOCITY = 300
PROJECTILE_DIAGONAL_VELOCITY = 220

.enum
PROJECTILE_NORTH
PROJECTILE_NORTHEAST
PROJECTILE_EAST
PROJECTILE_SOUTHEAST
PROJECTILE_SOUTH
PROJECTILE_SOUTHWEST
PROJECTILE_WEST
PROJECTILE_NORTHWEST
.endenum

projectile_x_lo = entity_x_lo
projectile_x_hi = entity_x_hi
projectile_y_lo = entity_y_lo
projectile_y_hi = entity_y_hi

projectile_direction = entity_local0
projectile_life_lo = entity_local1
projectile_life_hi = entity_local2
projectile_x_fine = entity_local3
projectile_y_fine = entity_local4
projectile_x_velocity_lo = entity_local5
projectile_x_velocity_hi = entity_local6
projectile_y_velocity_lo = entity_local7
projectile_y_velocity_hi = entity_local8

.enum
PROJECTILE_STATE_INIT
PROJECTILE_STATE_MAIN
.endenum

.endif
