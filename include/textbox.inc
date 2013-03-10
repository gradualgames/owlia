.ifndef TEXTBOX_INC
TEXTBOX_INC = 1

TEXTBOX_BG_CHR_BANK = 1

TEXTBOX_SCREEN_X = 0
TEXTBOX_SCREEN_Y = 176
TEXTBOX_SCREEN_SPRITE_OCCLUDE_Y = (TEXTBOX_SCREEN_Y - 8)
TEXTBOX_WIDTH = 255
TEXTBOX_HEIGHT = 80

.global print_string_impl
.global run_conversation
.global draw_textbox
.global erase_textbox
.global draw_textbox_top_row
.global draw_textbox_middle_row
.global draw_textbox_bottom_row

.macro print_string string_address, nametable, row, column

  lda #<string_address
  sta w0
  lda #>string_address
  sta w0+1
  lda nametable
  sta b0
  lda row
  sta b1
  lda column
  sta b2
  lda textbox_and_font_chr_offset
  sta b3
  jsr print_string_impl

.endmacro

;offsets of tiles in the textbox chr graphics
;these are to be added to textbox_and_font_chr_offset
;to get correct tile numbers when drawing the textbox.
TOP_LEFT_TILE_OFFSET     = 0
TOP_RIGHT_TILE_OFFSET    = 1
LEFT_TILE_OFFSET         = 2
RIGHT_TILE_OFFSET        = 3
MIDDLE_TILE_OFFSET       = 4
BOTTOM_LEFT_TILE_OFFSET  = 5
BOTTOM_RIGHT_TILE_OFFSET = 6
TOP_TILE_OFFSET          = 7
BOTTOM_TILE_OFFSET       = 8

;offsets of tiles in the textbox chr graphics font.
;A few reserved literals, A, X, and Y had to be prefixed
;with an underscore for use.
.enum
_A = 9
B
C
D
E
F
G
H
I
J
K
L
M
N
O
P
Q
R
S
T
U
V
W
_X
_Y
Z
CA ;CommA
PD ;PerioD
EN ;ExclamatioN
QN ;QuestioN
.endenum

SP = 4  ;space is the same offset as the middle tile (just a blank black tile)

;conversation control characters
EL = -1 ;end of line. This must ALWAYS be followed by a row number and some text to print!!!
EP = -2 ;end of page
WT = -3 ;wait for player to hit A button
EC = -4 ;end of conversation

;string control characters
ES = -5 ;end of string

.endif
