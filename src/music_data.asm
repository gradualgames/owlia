.include "music_data.inc"
.include "soundengine.inc"

.segment "ROM00"

song1:
.scope
.include "hero_theme.inc"
.endscope
song2:
.scope
.include "dungeon_theme.inc"
.endscope
song3:
.scope
.include "town_theme.inc"
.endscope
game_over:
.scope
.include "game_over.inc"
.endscope
