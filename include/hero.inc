.include "hero_constants.inc"

.ifndef HERO_INC
HERO_INC = 1

.global hero_face_in_current_direction
.global hero_turn_clockwise
.global hero_update
.global hero_draw
.global hero_draw_status
.global hero_eject_from_solid_tiles
.global align_hero_if_occluded_by_textbox
.global hero_calculate_screen_coordinates
.global hero_is_moving
.global hero_is_attacking
.global hero_hurt
.global hero_cancel_attack
.global hero_prepare_familiar_carry_hero
.global hero_set_down
.global hero_wait_frames

.endif
