.linecont +
.ifndef MERMON_TAIL_INC
MERMON_TAIL_INC = 1

MERMON_TAIL_WIDTH = $0f
MERMON_TAIL_HEIGHT = $0f

.enum
MERMON_TAIL_STATE_INIT
MERMON_TAIL_STATE_MAIN
.endenum

define_lohi_tables mermon_tail, \
 {mermon_tail_state_init, \
  mermon_tail_state_main}

mermon_tail_update:

  entity_state_switchboard mermon_tail_lo, mermon_tail_hi

mermon_tail_state_init:

  jsr entity_set_drawable

  lda #<mermon_tail_swim
  sta entity_animation_address_lo,x
  lda #>mermon_tail_swim
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #MERMON_TAIL_WIDTH
  sta entity_width,x
  lda #MERMON_TAIL_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_mermon
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #MERMON_TAIL_STATE_MAIN
  sta entity_state,x

  rts

mermon_tail_state_main:

  jsr entity_update_animation

  rts

.endif
