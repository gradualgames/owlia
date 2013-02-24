.ifndef CAMERA_INC
CAMERA_INC = 1

;we tweaked the camera and map code so that the origin of map coordinates
;maps to screen coordinate 0, 8. This is so the hidden 8 pixels from the
;NTSC overscan don't obscure the origin when we're scrolled right up
;against it. This origin should be added to the screen coordinates of all
;metasprites so that they line up with the map.
;Note we subtract 1 to account for the Y-coordinate-1 quirk of the PPU
;when interpreting sprite coordinates.
CAMERA_SCREEN_ORIGIN_X = 0
CAMERA_SCREEN_ORIGIN_Y = 15

.global update_camera
.global attach_camera_to_entity
.global increment_camera_x
.global increment_camera_x_scroll
.global increment_camera_y
.global increment_camera_y_scroll
.global decrement_camera_x
.global decrement_camera_x_scroll
.global decrement_camera_y
.global decrement_camera_y_scroll

.endif
