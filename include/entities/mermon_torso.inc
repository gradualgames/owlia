.linecont +
.ifndef MERMON_TORSO_INC
MERMON_TORSO_INC = 1

MERMON_TAIL_X_OFFSET = 0
MERMON_TAIL_Y_OFFSET = 16

MERMON_TORSO_WIDTH = $0f
MERMON_TORSO_HEIGHT = $0f

define_entity_properties mermon_tail_index

.enum
MERMON_TORSO_STATE_INIT
MERMON_TORSO_STATE_MAIN
.endenum

define_lohi_tables mermon_torso, \
 {mermon_torso_state_init, \
  mermon_torso_state_main}

mermon_torso_update:

  entity_state_switchboard mermon_torso_lo, mermon_torso_hi

mermon_torso_state_init:

  jsr entity_set_drawable

  lda #<mermon_torso_fly
  sta entity_animation_address_lo,x
  lda #>mermon_torso_fly
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_TORSO_WIDTH
  sta entity_width,x
  lda #MERMON_TORSO_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_mermon
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #%01000000
  sta entity_sprite_flags,x

  ;find the tail entity
  .scope
  ldy #(MAX_ENTITIES-1)
next_entity:

  lda entity_type,y
  cmp #entity_index_mermon_tail
  beq done

  dey
  bpl next_entity
done:
  tya
  sta mermon_tail_index,x
  .endscope

  jsr mermon_position_tail

  lda #MERMON_TORSO_STATE_MAIN
  sta entity_state,x

  rts

mermon_torso_state_main:

  jsr mermon_position_tail

  jsr entity_update_animation

  rts

.proc mermon_position_tail

  ldy mermon_tail_index,x

  clc
  lda entity_x_lo,x
  adc #<MERMON_TAIL_X_OFFSET
  sta entity_x_lo,y
  lda entity_x_hi,x
  adc #>MERMON_TAIL_X_OFFSET
  sta entity_x_hi,y

  clc
  lda entity_y_lo,x
  adc #<MERMON_TAIL_Y_OFFSET
  sta entity_y_lo,y
  lda entity_y_hi,x
  adc #>MERMON_TAIL_Y_OFFSET
  sta entity_y_hi,y

  lda entity_sprite_flags,x
  sta entity_sprite_flags,y

  rts

.endproc

.endif
