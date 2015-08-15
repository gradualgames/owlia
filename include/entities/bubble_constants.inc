.linecont +
.ifndef BUBBLE_CONSTANTS_INC
BUBBLE_CONSTANTS_INC = 1

BUBBLE_WIDTH = $0f
BUBBLE_HEIGHT = $0f

BUBBLE_INITIAL_LIFE = 255

.enum
BUBBLE_STATE_INIT
BUBBLE_STATE_MAIN
.endenum

bubble_x_lo = entity_x_lo
bubble_x_hi = entity_x_hi
bubble_y_lo = entity_y_lo
bubble_y_hi = entity_y_hi

define_entity_properties bubble_x_fine,\
                         bubble_y_fine,\
                         bubble_x_velocity_lo,\
                         bubble_x_velocity_hi,\
                         bubble_y_velocity_lo,\
                         bubble_y_velocity_hi,\
                         bubble_life

.endif
