.include "entities.inc"

.segment "ROM01"

.include "hero.inc"

entity_defs_update_address_lo:
  .byte <hero_update
entity_defs_update_address_hi:
  .byte >hero_update