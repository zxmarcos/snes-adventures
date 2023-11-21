
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
  stx   player.last_x
  stx   player.last_y

  stx   Temp1

  ; 30ticks 
  ldx.w #10
  stx   player.speed
  stx   player.timer

  
  cli
.loop:
  jmp   .loop



NMI:
  php
  pha

  ; Wait for joypad reading
  jsr   ReadJoypads
  jsr   UpdatePlayer
  jsr   DrawPlayer

  ; ACK NMI
  !A8
  lda   RDNMI

  pla
  plp
  rti


;; *******************************************************
;; Player movement logic
;; *******************************************************
UpdatePlayer:
  !AXY16

  ; Save old values
  ldx   player.x
  stx   player.last_x
  ldx   player.y
  stx   player.last_y

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

  ; A = 0x0000
  lda.w #$0000
  !A8
  
  lda   player.dir
  ldx.w #0
  asl   ; Jump table has 2 bytes for each entry.
  tax   
  jmp   (.jump_table,x)

.positiveX:
  jsr   PlayerMoveRight
  jmp   .end
.negativeX:
  jsr   PlayerMoveLeft
  jmp   .end
.positiveY:
  jsr   PlayerMoveUp
  jmp   .end
.negativeY:
  jsr   PlayerMoveDown
  jmp   .end
.jump_table:
  dw .positiveX, .negativeX, .positiveY, .negativeY
.end:
  rts


;; Update player movement using joypad dpad
UpdateDirectionFromJoypad:
  !AXY16
  lda   Joypad1Up

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
  beq   .end
  dex
  stx   player.x
.end
  rts


PlayerMoveRight:
  ldx   player.x
  cpx.w #32
  bcs   .end
  inx
  stx   player.x
.end
  rts

PlayerMoveUp:
  ldx   player.y
  cpx.w #0
  beq   .end
  dex
  stx   player.y
.end
  rts


PlayerMoveDown:
  ldx   player.y
  cpx.w #27
  beq   .end
  inx
  stx   player.y
.end
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

  ; Draw new position
  ldx   player.y
  stx   DRAW_TILE_Y
  ldx   player.x
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

title_pal:
  incbin  "gfx/title.pal"
title_charset:
  incbin  "gfx/title.chr"
title_map:
  incbin  "gfx/title.map"


char_pal:
  incbin  "gfx/char.pal"
char_charset:
  incbin  "gfx/char.chr"


__end:

