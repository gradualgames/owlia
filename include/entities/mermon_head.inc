.linecont +
.ifndef MERMON_HEAD_INC
MERMON_HEAD_INC = 1

MERMON_HEAD_WIDTH = $0f
MERMON_HEAD_HEIGHT = $0f

.enum
MERMON_HEAD_STATE_INIT
MERMON_HEAD_STATE_MAIN
.endenum

define_lohi_tables mermon_head, \
 {mermon_head_state_init, \
  mermon_head_state_main}

mermon_head_update:

  entity_state_switchboard mermon_head_lo, mermon_head_hi

mermon_head_state_init:

  jsr entity_set_drawable

  lda #<mermon_head_ears_forward
  sta entity_animation_address_lo,x
  lda #>mermon_head_ears_forward
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_HEAD_WIDTH
  sta entity_width,x
  lda #MERMON_HEAD_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_mermon_head
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #MERMON_HEAD_STATE_MAIN
  sta entity_state,x

  rts

mermon_head_state_main:

  jsr entity_update_animation

  rts

.endif
