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

ray_state_counter = entity_local0
ray_direction = entity_local1
ray_x_lo = entity_local2
ray_x_hi = entity_local3
ray_x_fine = entity_local4
ray_y_lo = entity_local5
ray_y_hi = entity_local6
ray_y_fine = entity_local7
ray_x_velocity_lo = entity_local8
ray_x_velocity_hi = entity_local9
ray_y_velocity_lo = entity_local10
ray_y_velocity_hi = entity_local11
ray_altitude_lo = entity_local12
ray_altitude_hi = entity_local13
ray_altitude_fine = entity_local14
ray_altitude_velocity_lo = entity_local15
ray_altitude_velocity_hi = entity_local16
ray_health = entity_local17
ray_knockback_counter = entity_local18
ray_flash_counter = entity_local19

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
