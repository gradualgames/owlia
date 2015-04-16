.linecont +
.ifndef RING_INC
RING_INC = 1

RING_WIDTH = $0f
RING_HEIGHT = $0f

.enum
RING_STATE_INIT
RING_STATE_MAIN
.endenum

define_lohi_tables ring, \
 {ring_state_init, \
  ring_state_main}

ring_update:

  entity_state_switchboard ring_lo, ring_hi

ring_state_init:

  jsr entity_set_drawable

  lda #<ring
  sta entity_animation_address_lo,x
  lda #>ring
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #RING_WIDTH
  sta entity_width,x
  lda #RING_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_minigame
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #RING_STATE_MAIN
  sta entity_state,x

  rts

ring_state_main:

  jsr entity_update_animation

  rts

.endif
