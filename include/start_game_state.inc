.ifndef START_GAME_STATE_INC
START_GAME_STATE_INC = 1

START_GAME_STATE_BANK = 1

.global start_game_state_init

.struct start_game_state_control
  menu_position .byte
.endstruct

.enum
NEW_GAME
CONTINUE
.endenum

.endif
