.linecont +
.ifndef JELLYFISH_INC
JELLYFISH_INC = 1

.enum
JELLYFISH_STATE_INIT
JELLYFISH_STATE_MAIN
.endenum

.define jellyfish_states \
  jellyfish_state_init, \
  jellyfish_state_main

jellyfish_lo:
  .lobytes jellyfish_states

jellyfish_hi:
  .hibytes jellyfish_states

jellyfish_update:

  entity_state_switchboard jellyfish_lo, jellyfish_hi

jellyfish_state_init:

  lda entity_flags,x
  ora #ENTITY_FLAGS_DRAWABLE_SET
  sta entity_flags,x

  lda #16
  sta entity_width,x
  lda #16
  sta entity_height,x

  lda #<JellyFishFloat
  sta entity_animation_address_lo,x
  lda #>JellyFishFloat
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda entity_type,x
  tay
  lda entity_type_chr_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  lda #JELLYFISH_STATE_MAIN
  sta entity_state,x

  rts

jellyfish_state_main:

  jsr hero_is_deadly
  beq hero_not_deadly

  jsr entity_test_hero_attack_rect
  bne hero_not_deadly

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  lda #entity_index_explosion
  sta b0

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

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

  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

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
