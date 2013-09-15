.linecont +
.include "entities.inc"
.include "hero_constants.inc"
.include "hero.inc"
.include "familiar_constants.inc"
.include "familiar.inc"
.include "entities.inc"
.include "sprite.inc"
.include "sprite_chr_data.inc"
.include "soundengine.inc"
.include "sfx_data.inc"
.include "zp.inc"
.include "ram.inc"
.include "sprites_and_animations_data.inc"
.include "entity.inc"
.include "controller.inc"
.include "map.inc"
.include "actions.inc"
.include "play_state.inc"
.include "geotests.inc"
.include "conversation_data.inc"
.include "inventory.inc"
.include "camera.inc"
.include "textbox.inc"
.include "ppu.inc"

.segment "CODE"

;update routines for entities. The hero and familiar are left blank because
;they only use the entity system for loading CHR graphics.
.define entity_defs_update_address \
  explosion_update, \
  bomb_update, \
  jellyfish_update, \
  npc_update, \
  key_update, \
  keyeddoor_update, \
  lantern_update, \
  item_update, \
  innkeep_update

entity_defs_update_address_lo:
  .lobytes entity_defs_update_address
entity_defs_update_address_hi:
  .hibytes entity_defs_update_address

entity_defs_update_address_bank:
  .byte entity_update_bank_explosion
  .byte entity_update_bank_bomb
  .byte entity_update_bank_jellyfish
  .byte entity_update_bank_npc
  .byte entity_update_bank_key
  .byte entity_update_bank_keyeddoor
  .byte entity_update_bank_lantern
  .byte entity_update_bank_item
  .byte entity_update_bank_innkeep

entity_defs_sprites_and_animations_bank:
  .byte entity_sprites_and_animations_bank_explosion
  .byte entity_sprites_and_animations_bank_bomb
  .byte entity_sprites_and_animations_bank_jellyfish
  .byte entity_sprites_and_animations_bank_npc
  .byte entity_sprites_and_animations_bank_key
  .byte entity_sprites_and_animations_bank_keyeddoor
  .byte entity_sprites_and_animations_bank_lantern
  .byte entity_sprites_and_animations_bank_item
  .byte entity_sprites_and_animations_bank_innkeep

.segment "ROM03"
.include "explosion.inc"
.include "bomb.inc"
.include "jellyfish.inc"
.include "npc.inc"
.include "key.inc"
.segment "ROM04"
.include "keyeddoor.inc"
.include "lantern.inc"
.include "item.inc"
.include "innkeep.inc"
