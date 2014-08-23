.linecont +
.ifndef CAGE_INC
CAGE_INC = 1

.include "rescueowl_constants.inc"

CAGE_WIDTH = $1f
CAGE_HEIGHT = $27

CAGE_ATTACKED_LENGTH = 20
CAGE_HEALTH = 3

.enum
CAGE_STATE_INIT
CAGE_STATE_MAIN
CAGE_STATE_EXPLODE
CAGE_STATE_RELEASE_RESCUE_OWL
.endenum

cage_attacked_counter = entity_local0
cage_health = entity_local1
cage_rescue_owl_entity_index = entity_local2

.define cage_states \
  cage_state_init, \
  cage_state_main, \
  cage_state_explode, \
  cage_state_release_rescue_owl

cage_lo:
  .lobytes cage_states

cage_hi:
  .hibytes cage_states

cage_update:

  entity_state_switchboard cage_lo, cage_hi

cage_state_init:

  jsr entity_set_drawable

  lda #<cage
  sta entity_animation_address_lo,x
  lda #>cage
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #CAGE_WIDTH
  sta entity_width,x
  lda #CAGE_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_cage
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #$00
  sta cage_attacked_counter,x

  lda #CAGE_HEALTH
  sta cage_health,x

  ;find the rescue owl entity index
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_type,y
  cmp #entity_index_rescueowl
  beq done

  dey
  bpl next_entity
done:
  tya
  sta cage_rescue_owl_entity_index,x
  .endscope

  lda #CAGE_STATE_MAIN
  sta entity_state,x

  rts

cage_state_main:

  jsr cage_advance_attacked_state

  .scope
  lda entity_action_rect2_action
  cmp #ACTION_ATTACK
  bne action_rect2_not_deadly

  jsr entity_test_entity_action_rect2
  bne action_rect2_not_deadly

  jsr cage_attacked

  far_call #FAMILIAR_BANK, familiar_hit_enemy
action_rect2_not_deadly:
  .endscope

  jsr entity_update_animation

  rts

cage_explosion_offset_x:
  .byte 0, 16, 0, 16

cage_explosion_offset_y:
  .byte 0, 0, 16, 16

cage_state_explode:

  lda #entity_index_explosion
  sta b0

  ldy #0

next_explosion:
  lda entity_x_lo,x
  sta w0
  lda entity_x_hi,x
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  clc
  lda w0
  adc cage_explosion_offset_x,y
  sta w0
  lda w0+1
  adc #$00
  sta w0+1

  clc
  lda w1
  adc cage_explosion_offset_y,y
  sta w1
  lda w1+1
  adc #$00
  sta w1+1

  jsr entity_spawn

  iny
  cpy #4
  bne next_explosion

  lda #CAGE_STATE_RELEASE_RESCUE_OWL
  sta entity_state,x

  rts

cage_state_release_rescue_owl:

  ;tell the rescued owl to enter its released state
  ldy cage_rescue_owl_entity_index,x
  lda #RESCUEOWL_STATE_RELEASED_INIT
  sta entity_state,y

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

.proc cage_advance_attacked_state

  lda cage_attacked_counter,x
  beq attacked_state_machine_not_running

  dec cage_attacked_counter,x

  lda cage_attacked_counter,x
  and #%00000011
  sta b0

  lda entity_sprite_flags,x
  and #%11111100
  ora b0
  sta entity_sprite_flags,x

attacked_state_machine_not_running:

  rts

.endproc

.proc cage_attacked

  lda cage_attacked_counter,x
  bne attacked_state_machine_already_running

  ;play a sound
  lda #<sfx_hit
  sta sound_param_word_0
  lda #>sfx_hit
  sta sound_param_word_0+1

  lda #3
  sta sound_param_byte_0

  lda #soundeffect_one
  sta sound_param_byte_1

  far_call #SFX_BANK, stream_initialize

  dec cage_health,x
  bne :+
  lda #CAGE_STATE_EXPLODE
  sta entity_state,x
:

  lda #CAGE_ATTACKED_LENGTH
  sta cage_attacked_counter,x

attacked_state_machine_already_running:

  rts

.endproc

.endif
