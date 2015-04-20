.linecont +
.ifndef CRAB_BOSS_PINCER_CONSTANTS
CRAB_BOSS_PINCER_CONSTANTS = 1

CRAB_BOSS_PINCER_WIDTH = $0f
CRAB_BOSS_PINCER_HEIGHT = $0f
CRAB_BOSS_PINCER_FLASH_LENGTH = 20

define_entity_properties crab_boss_pincer_state_counter,\
                         crab_boss_pincer_punch_delay,\
                         crab_boss_pincer_punch_length,\
                         crab_boss_pincer_flash_counter

.enum
CRAB_BOSS_PINCER_STATE_INIT
CRAB_BOSS_PINCER_STATE_MAIN
CRAB_BOSS_PINCER_STATE_PUNCH
.endenum

.endif
