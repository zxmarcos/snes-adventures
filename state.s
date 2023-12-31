includeonce
org $0000

Zero:
    skip 2

Joypad1:     skip 2
Joypad1Last: skip 2
Joypad1Down: skip 2
Joypad1Up:   skip 2
Joypad1Hold: skip 2


; Temporary variables
Temp1: skip 2
Temp2: skip 2
Temp3: skip 2 


; 8-bit random seed
rand_seed: skip 2

; Draw Tile XY parameters
DRAW_TILE_X:      skip 2
DRAW_TILE_Y:      skip 2
DRAW_TILE_ATTR:   skip 2

BG1_SCROLL_X:     skip 2
BG1_MOSAIC:       skip 2
BG1_MOSAIC_TIMER: skip 2


!DIR_X = $0
!DIR_NX = $1
!DIR_Y = $2
!DIR_NY = $3

!BOARD_WIDTH = 31
!BOARD_HEIGHT = 27
!MAX_BODY_LENGTH = 100

struct player
    .x          skip 2
    .y          skip 2
    .last_x     skip 2
    .last_y     skip 2
    .speed      skip 2
    .timer      skip 2
    .dir        skip 2
    .food_x     skip 2
    .food_y     skip 2
    .length     skip 2
endstruct
skip sizeof(player)



body_parts_x: skip 2*!MAX_BODY_LENGTH
body_parts_y: skip 2*!MAX_BODY_LENGTH
