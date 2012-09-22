.segment "ROM02"

;this macro is used to maintain in one place all the includes
;that are needed for all areas in the game.
.macro area_includes

.include "map_data.inc"
.include "map.inc"
.include "areas.inc"
.include "locations.inc"

.endmacro

.scope
area_includes
.include "village.inc"
.endscope

.scope
area_includes
.include "house1.inc"
.endscope