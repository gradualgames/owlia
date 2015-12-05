.ifndef KRAKEN_TENTACLE_CONSTANTS_INC
KRAKEN_TENTACLE_CONSTANTS_INC = 1

KRAKEN_TENTACLE_WIDTH = $f
KRAKEN_TENTACLE_HEIGHT = $f

KRAKEN_TENTACLE_INITIAL_HEALTH = 20
KRAKEN_TENTACLE_KNOCKBACK_LENGTH = 20
KRAKEN_TENTACLE_ATTACKED_LENGTH = 20
KRAKEN_TENTACLE_STATE_EXPLODE_LENGTH = 255

define_entity_properties kraken_tentacle_spawn_x_position_lo,\
                         kraken_tentacle_spawn_x_position_hi,\
                         kraken_tentacle_spawn_y_position_lo,\
                         kraken_tentacle_spawn_y_position_hi,\
                         kraken_tentacle_knockback_counter,\
                         kraken_tentacle_flash_counter,\
                         kraken_tentacle_health,\
                         kraken_tentacle_direction,\
                         kraken_tentacle_explode,\
                         kraken_tentacle_state_counter

.enum
KRAKEN_TENTACLE_STATE_INIT
KRAKEN_TENTACLE_STATE_ATTACK_LEFT_INIT
KRAKEN_TENTACLE_STATE_ATTACK_RIGHT_INIT
KRAKEN_TENTACLE_STATE_ATTACK
KRAKEN_TENTACLE_STATE_IDLE
KRAKEN_TENTACLE_STATE_EXPLODE
.endenum

.endif
