.ifndef FAMILIAR_INC
FAMILIAR_INC = 1

.global familiar_init
.global familiar_spawn
.global familiar_draw
.global familiar_update

FAMILIAR_FLAGS_ALIVE_SET     = %00000001
FAMILIAR_FLAGS_ALIVE_TEST    = %00000001
FAMILIAR_FLAGS_ALIVE_CLEAR   = %11111110

.endif
