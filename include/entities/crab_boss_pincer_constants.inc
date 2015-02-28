.ifndef CRAB_BOSS_PINCER_CONSTANTS
CRAB_BOSS_PINCER_CONSTANTS = 1

CRAB_BOSS_PINCER_WIDTH = $0f
CRAB_BOSS_PINCER_HEIGHT = $0f
CRAB_BOSS_PINCER_FLASH_LENGTH = 20

crab_boss_pincer_state_counter = entity_local0
crab_boss_pincer_punch_delay = entity_local1
crab_boss_pincer_punch_length = entity_local2
crab_boss_pincer_flash_counter = entity_local3

.enum
CRAB_BOSS_PINCER_STATE_INIT
CRAB_BOSS_PINCER_STATE_MAIN
CRAB_BOSS_PINCER_STATE_PUNCH
.endenum

.endif
