.linecont +
.ifndef SILMARAN_CARRY_ADLANNIEL_INC
SILMARAN_CARRY_ADLANNIEL_INC = 1

SILMARAN_CARRY_ADLANNIEL_WIDTH = $0f
SILMARAN_CARRY_ADLANNIEL_HEIGHT = $0f

SILMARAN_CARRY_ADLANNIEL_SPEED = -150

silmaran_carry_adlanniel_x_lo = entity_x_lo
silmaran_carry_adlanniel_x_hi = entity_x_hi
silmaran_carry_adlanniel_y_lo = entity_y_lo
silmaran_carry_adlanniel_y_hi = entity_y_hi

define_entity_properties silmaran_carry_adlanniel_y_fine,\
                         silmaran_carry_adlanniel_y_velocity_lo,\
                         silmaran_carry_adlanniel_y_velocity_hi

.enum
SILMARAN_CARRY_ADLANNIEL_STATE_INIT
SILMARAN_CARRY_ADLANNIEL_STATE_MAIN
.endenum

define_lohi_tables silmaran_carry_adlanniel, \
 {silmaran_carry_adlanniel_state_init, \
  silmaran_carry_adlanniel_state_main}

silmaran_carry_adlanniel_update:

  entity_state_switchboard silmaran_carry_adlanniel_lo, silmaran_carry_adlanniel_hi

silmaran_carry_adlanniel_state_init:

  jsr entity_set_drawable

  lda #<silmaran_carry_adlanniel
  sta entity_animation_address_lo,x
  lda #>silmaran_carry_adlanniel
  sta entity_animation_address_hi,x

  jsr entity_reset_animation

  lda #SILMARAN_CARRY_ADLANNIEL_WIDTH
  sta entity_width,x
  lda #SILMARAN_CARRY_ADLANNIEL_HEIGHT
  sta entity_height,x

  lda #0
  sta silmaran_carry_adlanniel_y_fine,x

  ;some entities are parameterized for graphics set, ones
  ;that are always hard coded should set their chr offset here
  lda #sprite_chr_group_index_fortress
  sta b0
  jsr entity_lookup_sprite_chr_offset

  lda #$00
  sta entity_sprite_flags,x

  entity_lda16 silmaran_carry_adlanniel_y_velocity, SILMARAN_CARRY_ADLANNIEL_SPEED

  lda #SILMARAN_CARRY_ADLANNIEL_STATE_MAIN
  sta entity_state,x

  rts

silmaran_carry_adlanniel_state_main:

  entity_add_velocity silmaran_carry_adlanniel_y, silmaran_carry_adlanniel_y_velocity

  jsr entity_update_animation

  rts

.endif
