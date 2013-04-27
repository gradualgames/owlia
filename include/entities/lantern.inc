.linecont +
.ifndef LANTERN_INC
LANTERN_INC = 1

LANTERN_WIDTH = $07
LANTERN_HEIGHT = $07

LANTERN_BRIGHTNESS_LEVELS = 4

;how many frames before changing brightness level
LANTERN_BRIGHTNESS_LEVEL_SPEED = 5

lantern_brightness_level = entity_local0
lantern_state_counter = entity_local1

lantern_brightness_levels:
  .byte 4, 2, 1, 2

.enum
LANTERN_STATE_INIT
LANTERN_STATE_MAIN
.endenum

.define lantern_states \
  lantern_state_init, \
  lantern_state_main

lantern_lo:
  .lobytes lantern_states

lantern_hi:
  .hibytes lantern_states

lantern_update:

  entity_state_switchboard lantern_lo, lantern_hi

lantern_state_init:

  jsr entity_set_drawable_unsorted

  lda #<Lantern
  sta entity_animation_address_lo,x
  lda #>Lantern
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #LANTERN_WIDTH
  sta entity_width,x
  lda #LANTERN_HEIGHT
  sta entity_height,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  ldy #sprite_chr_group_index_lantern
  lda sprite_chr_group_offsets,y
  sta entity_sprite_group_offset,x

  lda #$00
  sta entity_sprite_flags,x

  ;initialize members of the lantern
  lda #$00
  sta lantern_brightness_level,x
  lda #LANTERN_BRIGHTNESS_LEVEL_SPEED
  sta lantern_state_counter,x

  lda #LANTERN_STATE_MAIN
  sta entity_state,x

  rts

lantern_state_main:

  dec lantern_state_counter,x
  bne do_not_change_brightness_level

  ;move brightness level along
  .scope
  inc lantern_brightness_level,x
  lda lantern_brightness_level,x
  cmp #LANTERN_BRIGHTNESS_LEVELS
  bne do_not_reset_brightness_level

  lda #$00
  sta lantern_brightness_level,x

do_not_reset_brightness_level:
  .endscope

  ;change brightness level of area palette
  ldy lantern_brightness_level,x
  lda lantern_brightness_levels,y
  sta b3
  jsr entity_change_area_brightness_trampoline

  lda #LANTERN_BRIGHTNESS_LEVEL_SPEED
  sta lantern_state_counter,x

do_not_change_brightness_level:

  jsr entity_update_animation

  rts

.endif
