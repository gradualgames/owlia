.linecont +
.ifndef PROJECTILE_CONSTANTS_INC
PROJECTILE_CONSTANTS_INC = 1

PROJECTILE_MODE_SLOW = 0
PROJECTILE_MODE_FAST = 8

PROJECTILE_WIDTH = $07
PROJECTILE_HEIGHT = $07

PROJECTILE_INITIAL_LIFE = 100

PROJECTILE_ORTHOGONAL_VELOCITY = 300
PROJECTILE_DIAGONAL_VELOCITY = 220

PROJECTILE_ORTHOGONAL_FAST_VELOCITY = 500
PROJECTILE_DIAGONAL_FAST_VELOCITY = 300

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

define_entity_properties projectile_mode,\
                         projectile_direction,\
                         projectile_life_lo,\
                         projectile_life_hi,\
                         projectile_x_fine,\
                         projectile_y_fine,\
                         projectile_x_velocity_lo,\
                         projectile_x_velocity_hi,\
                         projectile_y_velocity_lo,\
                         projectile_y_velocity_hi

.enum
PROJECTILE_STATE_INIT
PROJECTILE_STATE_MAIN
.endenum

.endif
