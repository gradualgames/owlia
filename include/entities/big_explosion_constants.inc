.ifndef BIG_EXPLOSION_CONSTANTS_INC
BIG_EXPLOSION_CONSTANTS_INC = 1

.enum
BIG_EXPLOSION_STATE_INIT
BIG_EXPLOSION_STATE_MAIN
.endenum

define_entity_properties big_explosion_length,\
                         big_explosion_time_between_explosions,\
                         big_explosion_state_counter

.endif
