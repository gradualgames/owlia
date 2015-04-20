.linecont +
.ifndef BOSS_CONSTANTS_INC
BOSS_CONSTANTS_INC = 1

BOSS_PARAMS = 1

define_entity_properties boss_earned_tech,\
                         boss_state_counter

.enum
BOSS_STATE_INIT
BOSS_STATE_WAIT_FOR_BOSS_TO_DIE
BOSS_STATE_VICTORY
.endenum

.endif
