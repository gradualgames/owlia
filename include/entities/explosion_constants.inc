.ifndef EXPLOSION_CONSTANTS_INC
EXPLOSION_CONSTANTS_INC = 1

EXPLOSION_WIDTH = $f
EXPLOSION_HEIGHT = $f

.enum
EXPLOSION_STATE_INIT
EXPLOSION_STATE_MAIN
.endenum

EXPLOSION_COUNT = 5
EXPLOSION_DELAY = 6

define_entity_properties explosion_random_offset_mask,\
                         explosion_counter,\
                         explosion_frame_counter,\
                         explosion_random_offset_x,\
                         explosion_random_offset_y,\
                         explosion_spawn_x_lo,\
                         explosion_spawn_x_hi,\
                         explosion_spawn_y_lo,\
                         explosion_spawn_y_hi

.endif
