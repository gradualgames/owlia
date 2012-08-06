.include "entities.inc"
.include "sprite_chr_data.inc"

.segment "ROM01"

.include "hero.inc"

entity_defs_update_address_lo:
  .byte <hero_update
entity_defs_update_address_hi:
  .byte >hero_update
  
entity_defs_chr_address_lo:
  .byte <hero_chr
entity_defs_chr_address_hi:
  .byte >hero_chr