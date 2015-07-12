.linecont +
.ifndef OWL_SWITCH_INC
OWL_SWITCH_INC = 1

OWL_SWITCH_WIDTH = $0f
OWL_SWITCH_HEIGHT = $17

.enum
OWL_SWITCH_STATE_INIT
OWL_SWITCH_STATE_MAIN
.endenum

define_lohi_tables owl_switch, \
 {owl_switch_state_init, \
  owl_switch_state_main}

owl_switch_update:

  entity_state_switchboard owl_switch_lo, owl_switch_hi

owl_switch_state_init:

  jsr entity_set_drawable

  jsr entity_set_is_enemy

  lda #<dungeon_entrance_statue
  sta entity_animation_address_lo,x
  lda #>dungeon_entrance_statue
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #OWL_SWITCH_WIDTH
  sta entity_width,x
  lda #OWL_SWITCH_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_dungeon_entrance_statue
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #%00000001
  sta entity_sprite_flags,x

  lda #OWL_SWITCH_STATE_MAIN
  sta entity_state,x

  rts

owl_switch_state_main:

  .scope
  lda entity_action_rect1_action
  cmp #ENTITY_ACTION_ATTACK
  bne action_rect1_not_deadly

  jsr entity_test_entity_action_rect1
  bne action_rect1_not_deadly

  jsr owl_switch_hit

action_rect1_not_deadly:
  .endscope

  .scope
  lda entity_action_rect2_action
  cmp #ENTITY_ACTION_ATTACK
  bne action_rect2_not_deadly

  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  jsr owl_switch_hit

  far_call #FAMILIAR_BANK, familiar_hit_enemy

action_rect2_not_deadly:
  .endscope

  jsr entity_update_animation

  rts

.proc owl_switch_hit

  lda entity_sprite_flags,x
  and #%00000011
  sta b0
  inc b0
  lda b0
  and #%00000011
  sta entity_sprite_flags,x

  ;play a sound
  lda #<sfx_hit
  sta sound_param_word_0
  lda #>sfx_hit
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SOUND_BANK, stream_initialize

  rts

.endproc

.endif
