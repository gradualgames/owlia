.linecont +
.ifndef THRONES_OVERLAY_INC
THRONES_OVERLAY_INC = 1

THRONES_OVERLAY_WIDTH = $0f
THRONES_OVERLAY_HEIGHT = $0f

.enum
THRONES_OVERLAY_STATE_INIT
THRONES_OVERLAY_STATE_MAIN
.endenum

define_lohi_tables thrones_overlay, \
 {thrones_overlay_state_init, \
  thrones_overlay_state_main}

thrones_overlay_update:

  entity_state_switchboard thrones_overlay_lo, thrones_overlay_hi

thrones_overlay_state_init:

  jsr entity_set_drawable

  lda #<end_cut_scene_slide4_sprite_overlay
  sta entity_animation_address_lo,x
  lda #>end_cut_scene_slide4_sprite_overlay
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #sprite_chr_group_index_end_cut_scene_slide4
  sta b0
  jsr entity_lookup_sprite_chr_offset

  jsr controller_clear
  set_controller_routine controller_nop

  lda #ENTITY_DIRECTION_RIGHT
  sta hero_direction

  lda hero_flags
  and #HERO_FLAGS_DRAWABLE_CLEAR
  ora #HERO_FLAGS_HIDE_STATUS_SET
  sta hero_flags

  sec
  lda entity_x_lo,x
  sbc #<8
  sta entity_x_lo,x
  lda entity_x_hi,x
  sbc #>8
  sta entity_x_hi,x

  lda #THRONES_OVERLAY_STATE_MAIN
  sta entity_state,x

  rts

thrones_overlay_state_main:

  ; lda #<end_cut_scene_slide4_sprite_overlay0
  ; sta w0
  ; lda #>end_cut_scene_slide4_sprite_overlay0
  ; sta w0+1

  ; ;assume chr group is at 0 for now
  ; lda entity_sprite_group_offset,x
  ; sta chr_group_offset
  ; far_call #23, sprite_draw_overlay

  rts

.endif
