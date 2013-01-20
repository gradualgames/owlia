.include "hero_constants.inc"

.ifndef HERO_INC
HERO_INC = 1

.global hero_init
.global hero_face_in_current_direction
.global hero_update
.global hero_draw
.global align_hero_if_occluded_by_textbox
.global hero_calculate_screen_coordinates
.global hero_is_deadly
.global hero_is_moving
.global hero_hurt
.global hero_cancel_attack

.endif
