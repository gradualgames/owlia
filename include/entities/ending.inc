.linecont +
.ifndef ENDING_INC
ENDING_INC = 1

ENDING_WIDTH = $0f
ENDING_HEIGHT = $0f

.enum
ENDING_STATE_INIT
ENDING_STATE_MAIN
ENDING_STATE_DESTROY_FORTRESS
.endenum

define_entity_properties ending_big_explosion_index,\
                         ending_state_counter

define_lohi_tables ending, \
 {ending_state_init, \
  ending_state_main, \
  ending_state_destroy_fortress}

ending_update:

  entity_state_switchboard ending_lo, ending_hi

ending_state_init:

  jsr entity_set_drawable

  lda #<fortress
  sta entity_animation_address_lo,x
  lda #>fortress
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_fortress
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  lda #entity_index_big_explosion
  sta b0

  clc
  lda entity_x_lo,x
  adc #<8
  sta w0
  lda entity_x_hi,x
  adc #>8
  sta w0+1
  lda entity_y_lo,x
  sta w1
  lda entity_y_hi,x
  sta w1+1

  jsr entity_spawn

  lda spawned_entity
  sta ending_big_explosion_index,x
  tay
  lda #31
  sta entity_width,y
  sta entity_height,y
  lda #32
  sta big_explosion_time_between_explosions,y
  lda #255
  sta big_explosion_length,y

  lda #255
  sta ending_state_counter,x

  jsr controller_clear
  set_controller_routine controller_nop

  lda hero_flags
  and #HERO_FLAGS_DRAWABLE_CLEAR
  ora #HERO_FLAGS_HIDE_STATUS_SET
  sta hero_flags

  lda #ENDING_STATE_MAIN
  sta entity_state,x

  rts

ending_state_main:

  .scope
  dec ending_state_counter,x
  bne do_not_advance_state_yet

  ldy ending_big_explosion_index,x
  lda big_explosion_time_between_explosions,y
  lsr
  sta big_explosion_time_between_explosions,y

  lda big_explosion_time_between_explosions,y
  cmp #16
  bne do_not_spawn_silmaran_carry_adlanniel_yet

  lda #entity_index_silmaran_carry_adlanniel
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

do_not_spawn_silmaran_carry_adlanniel_yet:

  lda big_explosion_time_between_explosions,y
  cmp #1
  bne do_not_advance_state_yet

  lda #<tortoise_fortress_sinking
  sta entity_animation_address_lo,x
  lda #>tortoise_fortress_sinking
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  ldy ending_big_explosion_index,x
  lda #25
  sta big_explosion_length,y

  lda #25
  sta ending_state_counter,x

  lda #ENDING_STATE_DESTROY_FORTRESS
  sta entity_state,x
  rts

do_not_advance_state_yet:
  .endscope

  ldy ending_big_explosion_index,x
  lda #255
  sta big_explosion_length,y

  jsr entity_update_animation

  rts

ending_state_destroy_fortress:

  .scope
  dec ending_state_counter,x
  bne do_not_transition_yet

  lda entity_flags,x
  and #ENTITY_FLAGS_ALIVE_CLEAR
  sta entity_flags,x

  rts

do_not_transition_yet:
  .endscope

  jsr entity_update_animation

  rts

.endif
