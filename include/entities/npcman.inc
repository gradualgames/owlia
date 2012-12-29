.linecont +
.ifndef NPCMAN_INC
NPCMAN_INC = 1

.enum
NPCMAN_STATE_INIT
NPCMAN_STATE_MAIN
.endenum

.enum
NPCMAN_DIRECTION_RIGHT
NPCMAN_DIRECTION_LEFT
NPCMAN_DIRECTION_DOWN
NPCMAN_DIRECTION_UP
.endenum

npcman_hero_still_in_rect = entity_local0
npcman_direction = entity_local1

npcman_opposite_direction:
  .byte NPCMAN_DIRECTION_LEFT
  .byte NPCMAN_DIRECTION_RIGHT
  .byte NPCMAN_DIRECTION_UP
  .byte NPCMAN_DIRECTION_DOWN

.define npcman_animation_addresses\
  NpcManWalkSide,\
  NpcManWalkSide,\
  NpcManWalkDown,\
  NpcManWalkUp

npcman_animation_addresses_lo:
  .lobytes npcman_animation_addresses

npcman_animation_addresses_hi:
  .hibytes npcman_animation_addresses

npcman_sprite_flags_direction:
  .byte %00000000, %01000000, %00000000, %00000000

.define npcman_states \
  npcman_state_init, \
  npcman_state_main

npcman_lo:
  .lobytes npcman_states

npcman_hi:
  .hibytes npcman_states

npcman_update:

  entity_state_switchboard npcman_lo, npcman_hi

npcman_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #NPCMAN_DIRECTION_LEFT
  sta npcman_direction,x

  ldy npcman_direction,x
  lda npcman_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npcman_animation_addresses_hi,y
  sta entity_animation_address_hi,x

  lda npcman_sprite_flags_direction,y
  sta entity_sprite_flags,x

  lda #16
  sta entity_width,x
  lda #24
  sta entity_height,x

  jsr entity_reset_animation

  lda entity_type,x
  tay
  lda entity_type_chr_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta npcman_hero_still_in_rect,x

  lda #NPCMAN_STATE_MAIN
  sta entity_state,x

  rts

npcman_state_main:

  jsr hero_is_moving
  beq do_not_start_conversation

  ;test whether hero intersects npc's rect and rotate the result
  ;into npcman_hero_still_in_rect. This makes it easy to detect
  ;a transition into the npc's rect and a transition out.
  .scope
  jsr entity_test_hero_rect
  bne not_in_hero_rect
in_hero_rect:
  lda #$01
  jmp done
not_in_hero_rect:
  lda #$00
done:
  ror
  rol npcman_hero_still_in_rect,x
  .endscope

  lda npcman_hero_still_in_rect,x
  and #%00000011
  cmp #%00000001
  bne do_not_start_conversation

  ;face the hero
  ldy hero_direction
  lda npcman_opposite_direction,y
  sta npcman_direction,x
  tay
  lda npcman_animation_addresses_lo,y
  sta entity_animation_address_lo,x
  lda npcman_animation_addresses_hi,y
  sta entity_animation_address_hi,x
  lda npcman_sprite_flags_direction,y
  sta entity_sprite_flags,x

  ;enter conversation mode
  lda #ACTION_START_CONVERSATION
  sta state_control_params+play_state_control::action
  lda entity_param,x
  sta state_control_params+play_state_control::param

do_not_start_conversation:

  jsr entity_update_animation

  rts

.endif
