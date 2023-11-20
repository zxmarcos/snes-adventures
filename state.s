includeonce
org $0000

Zero:
    skip 2


Joypad1:     skip 2
Joypad1Last: skip 2
Joypad1Down: skip 2
Joypad1Up:   skip 2
Joypad1Hold: skip 2

struct player
    .x      skip 2
    .y      skip 2
    .last_x skip 2
    .last_y skip 2
    .speed  skip 2
    .timer  skip 2
    .dir    skip 1
    .moved  skip 1
endstruct
skip sizeof(player)


; Temporary variables
Temp1: skip 2
Temp2: skip 2
Temp3: skip 2 


; Draw Tile XY parameters
DRAW_TILE_X: skip 2
DRAW_TILE_Y: skip 2
DRAW_TILE_ATTR: skip 2


!DIR_X = $0
!DIR_NX = $1
!DIR_Y = $2
!DIR_NY = $3