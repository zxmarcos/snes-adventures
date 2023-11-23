
Start:
  sei
  clc
  xce

  !A8
  ; Mode 1, 8x8
  lda.b #1
  sta   BGMODE

  ; BG1Char = $0000, BG2Char = $3000
  lda   #$30
  sta   BG12NBA
  
  ; BG1Map = $2000
  lda   #$20
  sta   BG1SC
  ; BG2Map = $4000
  lda   #$40
  sta   BG2SC

  %LoadPalette(0, title_pal, datasize(title_pal))
  %LoadToVRAM(title_charset, datasize(title_charset), 0)
  %LoadToVRAM(title_map, datasize(title_map), $2000)


  %LoadPalette($10, char_pal, datasize(char_pal))
  %LoadToVRAM(char_charset, datasize(char_charset), $3000)


  ; Clear BG2 maptable
  %ClearVRAM($4000,32*32*2)

  ; Enable BG1 & BG2 layer
  !A8
  lda   #$03
  sta   TM

  ; Enable video output
  lda   #$0F
  sta   INIDISP

  ; Enable NMI ($80) + Joypad Auto Read ($01)
  lda   #$81
  sta   NMITIMEN

  ; Clear state
  !XY16
  ldx.w #0

  stx   Joypad1
  stx   Joypad1Last
  stx   Joypad1Down
  stx   Joypad1Up
  stx   Joypad1Hold
  stx   player.x
  stx   player.y
  stx   body_parts_x
  stx   body_parts_y
  stx   player.last_x
  stx   player.last_y
  stx   BG1_SCROLL_X
  stx   BG1_MOSAIC
  stx   BG1_MOSAIC_TIMER
  stx   player.length

  stx   Temp1
  ldx   #$33
  stx   rand_seed

  ; 30ticks 
  ldx.w #10
  stx   player.speed
  stx   player.timer

  jsr   GenerateFood
  
  cli
.loop:
  jmp   .loop

NMI:
  ; %DisableNMI()
  php
  sei
  pha

  ; Wait for joypad reading
  jsr   ReadJoypads
  jsr   UpdatePlayer

  jsr   DrawFood
  jsr   DrawPlayer
  jsr   UpdateBackground

  ; ACK NMI
  !A8
  lda   RDNMI

  pla
  plp
  cli
  ;%EnableNMI()
  rti


;; *******************************************************
;; Player movement logic
;; *******************************************************
UpdatePlayer:
  !AXY16

  ; Save old values
  ; ldx   player.x
  ; stx   player.last_x
  ; ldx   player.y
  ; stx   player.last_y

  jsr   UpdateDirectionFromJoypad

  ; Check if move timer expired
  ldx   player.timer
  dex
  beq   .move

  ; Reload timer.
  stx   player.timer
  jmp   .end

.move:
  ; reload timer from speed
  ldx   player.speed
  stx   player.timer


  !A16
  ; A = 0x0000
  lda   #$0000
  
  !A8
  lda   player.dir
  ldx   #$0000
  asl   ; Jump table has 2 bytes for each entry.
  tax
  jmp   (.jump_table,x)
.stuck:
  brk
.positiveX:
  jsr   PlayerMoveRight
  jmp   .updateBody
.negativeX:
  jsr   PlayerMoveLeft
  jmp   .updateBody
.positiveY:
  jsr   PlayerMoveUp
  jmp   .updateBody
.negativeY:
  jsr   PlayerMoveDown
  jmp   .updateBody
.jump_table:
  dw .positiveX, .negativeX, .positiveY, .negativeY

.updateBody:
  jsr   CheckFood
  jsr   UpdateBodyParts

.end:
  rts


UpdateBodyParts:
  php
  !AXY16

  ; Update last x & y
  lda   player.length
  asl
  tax
  lda   body_parts_x,x
  sta   player.last_x
  lda   body_parts_y,x
  sta   player.last_y
  

  ; BodyParts[0].x = player.x, BodyParts[0].y = player.y
  lda   player.x
  sta   body_parts_x
  lda   player.y
  sta   body_parts_y

  
  lda   player.length
  tay

  ; BodyPos == 0? nothing to do...
  beq   .end

  ; Loop(i) = BodyParts[i] = BodyParts[i-1]
  ; i = Y
.loop:
  
  ; PTR[i-1] = (Y - 1) * 2
  tya
  dec
  asl
  ; X = PTR[i-1]
  tax
  ; Temp1 = BodyParts[i-1].x 
  lda     body_parts_x,x
  sta     Temp1 
  ; Temp2 = BodyParts[i-1].y
  lda     body_parts_y,x
  sta     Temp2

  ; PTR[i] = Y * 2
  tya
  asl
  ; X = PTR[i]
  tax

  ; BodyParts[i-1].y = Temp2 
  lda     Temp1
  sta     body_parts_x,x

  ; BodyParts[i-1].y = Temp2 
  lda     Temp2
  sta     body_parts_y,x  
  
  dey
  bne   .loop
.end:
  plp
  rts

CheckFood:
  php
  !A16
  ; X == Food.X?
  lda   player.x
  cmp   player.food_x  
  bne   .end
  ; Y == Food.Y?
  lda   player.y
  cmp   player.food_y 
  bne   .end

  jsr   GenerateFood
  inc   player.length

.end:
  plp
  rts


;; Update player movement using joypad dpad
UpdateDirectionFromJoypad:
  !AXY16
  lda   Joypad1Down

.updateRight:
  bit.w #!JOY_DPAD_Right
  beq   .updateLeft
  ; Update direction
  !A8
  lda.b #!DIR_X
  sta   player.dir
  jmp   .end

.updateLeft:
  bit.w   #!JOY_DPAD_Left
  beq   .updateUp
  ; Update direction
  !A8
  lda.b #!DIR_NX
  sta   player.dir
  jmp   .end

.updateUp:
  bit.w   #!JOY_DPAD_Up
  beq   .updateDown
  ; Update direction
  !A8
  lda.b #!DIR_Y
  sta   player.dir
  jmp   .end

.updateDown:
  bit.w   #!JOY_DPAD_Down
  beq   .end
  ; Update direction
  !A8
  lda.b #!DIR_NY
  sta   player.dir

.end:
  rts

PlayerMoveLeft:
  ldx   player.x
  cpx.w #0
  beq   .wrap
  dex
  stx   player.x
  jmp   .end
.wrap:
  ldx.w #!BOARD_WIDTH
  stx   player.x
.end:
  rts


PlayerMoveRight:
  ldx   player.x
  cpx.w #!BOARD_WIDTH
  bcs   .wrap
  inx
  stx   player.x
  jmp   .end
.wrap:
  ldx   #$0000
  stx   player.x
.end:
  rts

PlayerMoveUp:
  ldx   player.y
  cpx.w #0
  beq   .wrap
  dex
  stx   player.y
  jmp   .end
.wrap:
  ldx.w #!BOARD_HEIGHT
  stx   player.y
.end:
  rts


PlayerMoveDown:
  ldx   player.y
  cpx.w #!BOARD_HEIGHT
  beq   .wrap
  inx
  stx   player.y
  jmp   .end
.wrap:
  ldx   #$0000
  stx   player.y
.end:
  rts


GenerateFood:
  php
  !A16
  lda   #$0000
  !A8
  !XY16

  jsr   Rand8
  and   #$1F  ; X%32
  tax
  phx
  jsr   Rand8
  and   #$1F
  plx
.round:
  cmp   #27
  ; Y < 17
  bcc   .ok
  ; Y = Y/2
  lsr
  jmp   .round

.ok:
  tay

  !A16
  stx   player.food_x
  sty   player.food_y
  plp
  rts

;; *******************************************************
;; Update background "animations"
;; *******************************************************
UpdateBackground:
  ; Update scrolling
  !A8
  !XY8
  lda   BG1_SCROLL_X
  inc
  sta   BG1_SCROLL_X
  sta   BG1HOFS
  sta   BG1VOFS

  jmp   .end

  ; Update mosaic effect
  ldx   BG1_MOSAIC_TIMER
  bne   .updateMosaicTimer

  ldx   #60
  stx   BG1_MOSAIC_TIMER

  lda   BG1_MOSAIC
  ldx   BG1_MOSAIC_TIMER+1
  bne   .backward
  
.forward:
  inc
  cmp   #1
  bcc   .writeMosaic
  ldx   #1
  stx   BG1_MOSAIC_TIMER+1
  jmp   .writeMosaic

.backward:
  dec
  cmp   #0
  bne   .writeMosaic
  ldx   #0
  stx   BG1_MOSAIC_TIMER+1

.writeMosaic:
  sta   BG1_MOSAIC
  
  ; Factor << 4 
  asl
  asl
  asl
  asl
  ; BG1 only
  ora   #$01
  sta   MOSAIC
  jmp   .end

.updateMosaicTimer:
  dex
  stx   BG1_MOSAIC_TIMER
.end:

  rts

;; *******************************************************
;; Drawing logic
;; *******************************************************
DrawPlayer:
  !AXY16
  ; Clear last position
  ldx   player.last_y
  stx   DRAW_TILE_Y
  ldx   player.last_x
  stx   DRAW_TILE_X
  ; Transparent tile
  ldx.w #$0000
  stx   DRAW_TILE_ATTR
  jsr   DrawTileBG1XY

  ; Draw each body part.
  ldy   player.length
  
.drawNextPart:
  phy

  ; PTR = BodyParts[y]
  tya
  asl
  tax

  lda   body_parts_x,x
  sta   DRAW_TILE_X
  lda   body_parts_y,x
  sta   DRAW_TILE_Y

  ; Tile 2, Palette 1, Higher priority 
  ldx.w #2|(1<<10)|(1<<13)
  stx   DRAW_TILE_ATTR
  jsr   DrawTileBG1XY


  ply
  beq   .end
  dey
  bne   .drawNextPart

.end:

  rts

; TODO: Move food to OAM.
DrawFood:
  !AXY16
  ; Draw new position
  ldx   player.food_y
  stx   DRAW_TILE_Y
  ldx   player.food_x
  stx   DRAW_TILE_X
  ; Tile 1, Palette 1, Higher priority 
  ldx.w #1|(1<<10)|(1<<13)
  stx   DRAW_TILE_ATTR
  jsr   DrawTileBG1XY

  rts

DrawTileBG1XY:
  php
  !AXY16

  ; Compute Y index on table (2 bytes per entry)
  ldy   DRAW_TILE_Y
  tya
  ; Y*2
  asl
  tay
  ; X = TileMap ROW (32 tiles per row)
  ldx   X32LUT,y   
  ; A = (ROW + X) * 2 byte per tile
  txa
  clc
  adc   DRAW_TILE_X

  clc
  adc.w #CHAR_BGMAP

  ; Store TileMap address to VRAM
  sta   VMADDL
  ldx.w DRAW_TILE_ATTR
  stx   VMDATAL
  plp
  rts


CHAR_BGMAP = $4000

;; RESOURCES...

;;32x table
X32LUT:
  !i = 0
  while !i <= 32
    dw !i*32
    !i #= !i+1
  endif

; title_pal:
;   incbin  "gfx/title.pal"
; title_charset:
;   incbin  "gfx/title.chr"
; title_map:
;   incbin  "gfx/title.map"


title_pal:
  incbin  "gfx/grass.pal"
title_charset:
  incbin  "gfx/grass.chr"
title_map:
  incbin  "gfx/grass.map"


char_pal:
  incbin  "gfx/char.pal"
char_charset:
  incbin  "gfx/char.chr"


__end:

