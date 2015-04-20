.linecont +
.ifndef RAY_CONSTANTS
RAY_CONSTANTS = 1

RAY_STATE_WAIT_UNDER_SAND_LENGTH = 40
RAY_STATE_FALL_UNDER_SAND_LENGTH = 20
RAY_STATE_RISE_FROM_SAND_LENGTH = 30
RAY_STATE_RISE_LENGTH = 20
RAY_STATE_FALL_LENGTH = 20

RAY_SPEED = 300

RAY_RISE_SPEED = 200
RAY_FLOAT_ACCELERATION = 30
RAY_FLOAT_ALTITUDE = 15

RAY_INITIAL_HEALTH = 10
RAY_ATTACKED_LENGTH = 30
RAY_KNOCKBACK_LENGTH = 10

RAY_WIDTH = $0f
RAY_HEIGHT = $0f
RAY_HALFWIDTH = (RAY_WIDTH >> 1)
RAY_HALFHEIGHT = (RAY_HEIGHT >> 1)

define_entity_properties ray_state_counter,\
                         ray_direction,\
                         ray_x_lo,\
                         ray_x_hi,\
                         ray_x_fine,\
                         ray_y_lo,\
                         ray_y_hi,\
                         ray_y_fine,\
                         ray_x_velocity_lo,\
                         ray_x_velocity_hi,\
                         ray_y_velocity_lo,\
                         ray_y_velocity_hi,\
                         ray_altitude_lo,\
                         ray_altitude_hi,\
                         ray_altitude_fine,\
                         ray_altitude_velocity_lo,\
                         ray_altitude_velocity_hi,\
                         ray_health,\
                         ray_knockback_counter,\
                         ray_flash_counter

.enum
RAY_STATE_INIT
RAY_STATE_WAIT_UNDER_SAND
RAY_STATE_RISE_FROM_SAND
RAY_STATE_RISE
RAY_STATE_MEANDER
RAY_STATE_FALL
RAY_STATE_FALL_UNDER_SAND
.endenum

.endif
