.ifndef SFX_DATA_INC
SFX_DATA_INC = 1

.global sfx_volume_envelopes
.global sfx_pitch_envelopes
.global sfx_duty_envelopes

.global sfx_set1
.global sfx_hit
.global sfx_hero_hit
.global sfx_sword
.global sfx_door
.global sfx_flap
.global sfx_explosion
.global sfx_text
.global sfx_get_item
.global sfx_move_cursor
.global sfx_select
.global sfx_inventory
.global sfx_error
.global sfx_monolith_slam
.global sfx_chest_open
.global sfx_chest_melody
.global sfx_solved_puzzle_instrument_one
.global sfx_solved_puzzle_instrument_two
.global sfx_octoboss_rise
.global sfx_octoboss_punch
.global sfx_ice_shatter_square
.global sfx_ice_shatter_noise
.global sfx_whoosh
.global sfx_coins_square1
.global sfx_coins_square2
.global sfx_boom
.global sfx_skitter

.enum
sfx_volume_envelope_index_silence
sfx_volume_envelope_index_loud
sfx_volume_envelope_index_door
sfx_volume_envelope_index_flap
sfx_volume_envelope_index_sword
sfx_volume_envelope_index_explosion
sfx_volume_envelope_index_text
sfx_volume_envelope_index_get_item
sfx_volume_envelope_index_key
sfx_volume_envelope_index_cursor
sfx_volume_envelope_index_select
sfx_volume_envelope_index_inventory
sfx_volume_envelope_index_error
sfx_volume_envelope_index_hit
sfx_volume_envelope_index_hero_hit
sfx_volume_envelope_index_monolith
sfx_volume_envelope_index_chest_open
sfx_volume_envelope_index_chest_melody
sfx_volume_envelope_index_solve_puzzle
sfx_volume_envelope_index_octoboss_rise
sfx_volume_envelope_index_ice_explosion
sfx_volume_envelope_index_whoosh
sfx_volume_envelope_index_coins
sfx_volume_envelope_index_boom
sfx_volume_envelope_index_skitter
.endenum

.enum
sfx_pitch_envelope_index_flat
sfx_pitch_envelope_index_vibrato
sfx_pitch_envelope_index_long_slide_down
.endenum

.enum
sfx_duty_envelope_index_standard
sfx_duty_envelope_index_ooo
.endenum

.endif
