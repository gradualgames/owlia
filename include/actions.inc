.ifndef ACTIONS_INC
ACTIONS_INC = 1

;actions 0 thru 15 are reserved for use by the map (or anybody else)
;because metatiles only can represent 4 bits for specifying an action
;to run. Actions 16 and up can be used by anybody else.
.enum
ACTION_NOP
ACTION_GOTO_LOCATION_GROUP1
ACTION_SCROLLTO_LOCATION_GROUP1
ACTION_START_CONVERSATION
ACTION_SHOW_INVENTORY_SCREEN
ACTION_CARRY_TO
ACTION_GAME_OVER
ACTION_PLAY_CUT_SCENE
ACTION_ATTACK
ACTION_FETCH
.endenum

.enum
ACTION_FROM_NOBODY
ACTION_FROM_FAMILIAR
ACTION_FROM_BOMB
.endenum

.endif
