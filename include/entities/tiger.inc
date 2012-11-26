.linecont +
.ifndef TIGER_INC
TIGER_INC = 1

.enum
TIGER_STATE_INIT
TIGER_STATE_MAIN
.endenum

.define tiger_states \
  tiger_state_init, \
  tiger_state_main

tiger_lo:
  .lobytes tiger_states

tiger_hi:
  .hibytes tiger_states

tiger_update:

  entity_state_switchboard tiger_lo, tiger_hi

tiger_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #16
  sta entity_width,x
  lda #24
  sta entity_height,x

  lda #<TigerWalkSide
  sta entity_animation_address_lo,x
  lda #>TigerWalkSide
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda entity_type,x
  tay
  lda entity_type_chr_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #TIGER_STATE_MAIN
  sta entity_state,x

  rts

tiger_state_main:

  jsr hero_is_deadly
  beq hero_not_deadly

  jsr entity_test_hero_attack_rect
  bne hero_not_deadly

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  lda #entity_index_explosion
  sta b0
  jsr entity_spawn

hero_not_deadly:

  jsr familiar_is_deadly
  beq familiar_not_deadly

  jsr entity_test_familiar_rect
  bne familiar_not_deadly

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  lda #entity_index_explosion
  sta b0
  jsr entity_spawn

  jsr familiar_hit_enemy

familiar_not_deadly:

  jsr entity_test_hero_rect
  bne entity_not_hitting_hero

  lda #$ff
  sta b0
  jsr hero_hurt

entity_not_hitting_hero:

  jsr entity_update_animation

  rts

.endif
