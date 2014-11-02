.ifndef BOMB_CONSTANTS_INC
BOMB_CONSTANTS_INC = 1

BOMB_INITIAL_BOUNCE_OFFSET = 8
BOMB_BOUNCE_Y_ACCELERATION = 50
BOMB_SLIDING_DECELERATION = 16
BOMB_BOUNCES = 5
BOMB_TIMER = 200

BOMB_CARRIED_X_OFFSET = 4
BOMB_CARRIED_Y_OFFSET = 16

BOMB_WIDTH = 7
BOMB_HALF_WIDTH = 4
BOMB_HEIGHT = 7
BOMB_HALF_HEIGHT = 4

;the target is just an invisible moving spot the bomb bounces above.
;it slides while the bomb bounces above it, and these two constants
;define the initial velocity for the slide. We are constraining the
;movement to only ever be horizontal or vertical, since the familiar
;will only fly out from the hero horizontally or vertically.
BOMB_TARGET_X_DEFAULT_VELOCITY = 0
BOMB_TARGET_Y_DEFAULT_VELOCITY = 200

.enum
BOMB_STATE_INIT_CARRIED
BOMB_STATE_CARRIED
BOMB_STATE_INIT_FALL
BOMB_STATE_FALL
.endenum

bomb_target_x_lo = entity_x_lo
bomb_target_x_hi = entity_x_hi
bomb_target_x_fine = entity_local0

bomb_target_y_lo = entity_local1
bomb_target_y_hi = entity_local2
bomb_target_y_fine = entity_local3

bomb_target_x_velocity_lo = entity_local4
bomb_target_x_velocity_hi = entity_local5

bomb_target_y_velocity_lo = entity_local6
bomb_target_y_velocity_hi = entity_local7

bomb_bounce_offset_y_lo = entity_local8
bomb_bounce_offset_y_hi = entity_local9
bomb_bounce_offset_y_fine = entity_local10

bomb_bounce_y_velocity_lo = entity_local11
bomb_bounce_y_velocity_hi = entity_local12

bomb_bounces = entity_local13

bomb_timer = entity_local14

bomb_frames_since_last_direction_negation = entity_local15

.endif
