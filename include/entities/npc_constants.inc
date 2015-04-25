.ifndef NPC_CONSTANTS_INC
NPC_CONSTANTS_INC = 1

NPC_MODE_WALK       = %00000000
NPC_MODE_MOTIONLESS = %00000001
NPC_MODE_TEST       = %00000001

NPC_GRAPHICS_SET_MAN = 0
NPC_GRAPHICS_SET_WOMAN = 4
NPC_GRAPHICS_SET_COMMODORE = 8
NPC_GRAPHICS_SET_CAPTAIN = 12
NPC_GRAPHICS_SET_BOSUN = 16

.enum
NPC_STATE_INIT
NPC_STATE_WALK
NPC_STATE_PAUSE
NPC_STATE_MOTIONLESS
.endenum

NPC_WIDTH = 15
NPC_HEIGHT = 31

NPC_CONVERSATION_RECT_X_OFFSET = 8
NPC_CONVERSATION_RECT_Y_OFFSET = 0
NPC_CONVERSATION_RECT_WIDTH    = 8 * 2 + 16
NPC_CONVERSATION_RECT_HEIGHT   = 32

NPC_SPEED = 1

NPC_PARAMS = 6

define_entity_properties npc_conversation,\
                         npc_graphics_set,\
                         npc_walk_rect_width,\
                         npc_walk_rect_height,\
                         npc_mode,\
                         npc_direction,\
                         \
                         npc_random_turnleft_counter,\
                         npc_random_turnright_counter,\
                         npc_random_pause_counter,\
                         npc_spawn_x_lo,\
                         npc_spawn_x_hi,\
                         npc_spawn_y_lo,\
                         npc_spawn_y_hi

.endif
