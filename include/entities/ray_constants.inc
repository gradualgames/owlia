.ifndef RAY_CONSTANTS
RAY_CONSTANTS = 1

RAY_STATE_WAIT_UNDER_SAND_LENGTH = 40
RAY_STATE_RISE_FROM_SAND_LENGTH = 30

RAY_WIDTH = $0f
RAY_HEIGHT = $0f

RAY_PARAMS = 1

ray_initial_direction = entity_local0

ray_state_counter = entity_local1
ray_direction = entity_local2

.enum
RAY_STATE_INIT
RAY_STATE_WAIT_UNDER_SAND
RAY_STATE_RISE_FROM_SAND
RAY_STATE_RISE
.endenum

.endif
