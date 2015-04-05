.ifndef RAY_CONSTANTS
RAY_CONSTANTS = 1

RAY_STATE_WAIT_UNDER_SAND_LENGTH = 40
RAY_STATE_RISE_FROM_SAND_LENGTH = 30
RAY_STATE_RISE_LENGTH = 40

RAY_RISE_SPEED = 100

RAY_WIDTH = $0f
RAY_HEIGHT = $0f

RAY_PARAMS = 1

ray_initial_direction = entity_local0

ray_state_counter = entity_local1
ray_direction = entity_local2
ray_x_lo = entity_local3
ray_x_hi = entity_local4
ray_x_fine = entity_local5
ray_y_lo = entity_local6
ray_y_hi = entity_local7
ray_y_fine = entity_local8
ray_x_velocity_lo = entity_local9
ray_x_velocity_hi = entity_local10
ray_y_velocity_lo = entity_local11
ray_y_velocity_hi = entity_local12
ray_altitude_lo = entity_local13
ray_altitude_hi = entity_local14
ray_altitude_fine = entity_local15
ray_altitude_velocity_lo = entity_local16
ray_altitude_velocity_hi = entity_local17

.enum
RAY_STATE_INIT
RAY_STATE_WAIT_UNDER_SAND
RAY_STATE_RISE_FROM_SAND
RAY_STATE_RISE
RAY_STATE_MEANDER
.endenum

.endif
