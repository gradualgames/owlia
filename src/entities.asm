.linecont +
.include "entities.inc"
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
  item_update

entity_defs_update_address_lo:
  .lobytes entity_defs_update_address
entity_defs_update_address_hi:
  .hibytes entity_defs_update_address

.segment "ROM03"

npc_direction_speed_x_lo:
  .byte NPC_SPEED, -NPC_SPEED, 0, 0

npc_direction_speed_x_hi:
  .byte 0, $ff, 0, 0

npc_direction_speed_y_lo:
  .byte 0, 0, NPC_SPEED, -NPC_SPEED

npc_direction_speed_y_hi:
  .byte 0, 0, 0, $ff

npc_opposite_direction:
  .byte NPC_DIRECTION_LEFT
  .byte NPC_DIRECTION_RIGHT
  .byte NPC_DIRECTION_UP
  .byte NPC_DIRECTION_DOWN

.define npc_animation_addresses\
  NpcManWalkSide,\
  NpcManWalkSide,\
  NpcManWalkDown,\
  NpcManWalkUp, \
  NpcWomanWalkSide,\
  NpcWomanWalkSide,\
  NpcWomanWalkDown,\
  NpcWomanWalkUp

npc_animation_addresses_lo:
  .lobytes npc_animation_addresses

npc_animation_addresses_hi:
  .hibytes npc_animation_addresses

npc_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000
  .byte %00000000, %01000000, %00000000, %00000000

.include "hero.inc"
.include "familiar.inc"
.include "explosion.inc"
.include "jellyfish.inc"
.include "npc.inc"
.include "key.inc"
.include "keyeddoor.inc"
.include "bomb.inc"
.include "lantern.inc"
.include "item.inc"
