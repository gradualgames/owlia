.ifndef JELLYFISH_CONSTANTS_INC
JELLYFISH_CONSTANTS_INC = 1

JELLYFISH_WIDTH = $0f
JELLYFISH_HEIGHT = $0f

JELLYFISH_INITIAL_HEALTH = 3

JELLYFISH_INITIAL_Y_OFFSET = 40

JELLYFISH_OFFSET_MIDPOINT = 35

JELLYFISH_UNDULATION_ACCELERATION = 5

JELLYFISH_ATTACKED_LENGTH = 30

JELLYFISH_KNOCKBACK_LENGTH = 30

JELLYFISH_FOLLOW_X_OFFSET = 0
JELLYFISH_FOLLOW_Y_OFFSET = 52

;supply new set of x and y coordinates, because
;we compute the coordinates of the jellyfish as
;floating above this point.
define_entity_properties jellyfish_x_lo,\
                         jellyfish_x_hi,\
                         jellyfish_x_fine,\
                         jellyfish_y_lo,\
                         jellyfish_y_hi,\
                         jellyfish_y_fine,\
                         jellyfish_x_velocity_lo,\
                         jellyfish_x_velocity_hi,\
                         jellyfish_y_velocity_lo,\
                         jellyfish_y_velocity_hi,\
                         jellyfish_y_offset_lo,\
                         jellyfish_y_offset_hi,\
                         jellyfish_y_offset_fine,\
                         jellyfish_y_offset_velocity_lo,\
                         jellyfish_y_offset_velocity_hi,\
                         jellyfish_direction,\
                         jellyfish_health,\
                         jellyfish_knockback_counter,\
                         jellyfish_flash_counter,\
                         jellyfish_frame_counter

.enum
JELLYFISH_STATE_INIT
JELLYFISH_STATE_MAIN
.endenum

.endif
