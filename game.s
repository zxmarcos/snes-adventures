
Start:
  sei
  clc
  xce

  jsr   SetupPPU
  jsr   ClearSRAM

  ; Copy S-CPU code to WRAM
  !AXY16

  ; Copy dummy vectors to 00:0100
  lda   #DummyVector_0100_end-DummyVector_0100-1
  ldx   #DummyVector_0100
  ldy   #$0100
  mvn   $00,$00

  ; A = size, X = src, Y = dst
  lda   #RunGSUCode_WRAM_end-RunGSUCode_WRAM-1
  ldx   #RunGSUCode
  ldy   #RunGSUCode_WRAM
  ; Copy from Bank $00->$00
  mvn   $00,$00

  jsr   RunGSUCode_WRAM

  
  ; Copy SRAM (GSU) to VRAM
  %LoadToVRAM($700000,$8000,$0000)

  jsr   EnableVideo

.loop:
  wai
  jsr   RunGSUCode_WRAM
  jmp   .loop

SetupPPU:
  !A8
  ; Mode 1, 8x8
  lda.b #1
  sta   BGMODE

  ; BG1Char = $0000, BG2Char = $3000
  lda   #$00
  sta   BG34NBA
  
  ; BG1Map = $4000
  lda   #$40
  sta   BG3SC

  ; Enable BG1 & BG2 layer
  !A8
  lda   #$04
  sta   TM

  %LoadPalette(0, title_pal, datasize(title_pal))
  %LoadToVRAM(screen_map,datasize(screen_map),$4000)
  rts

EnableVideo:
  !A8

  lda   #$00
  sta   SETINI

  ; Enable video output
  lda   #$0F
  sta   INIDISP

  ; Enable NMI ($80) + Joypad Auto Read ($01)
  lda   #$81
  sta   NMITIMEN
  rts

ClearSRAM:
  !AXY16
  lda   #$0000
  ldx   #$0000
.loop:
  sta.l $700000,x
  inx
  inx
  cpx.w  #32*32*32
  bcc   .loop
  rts

NMI:
  php
  pha
  phx
  phy

  !A16
  lda.w #$0020
  bit   GSU_SFR     ; wait for GSU...
	bne   .end

  !A8
  lda STAT78
  bpl .activeFrame

  ;;Force VBlank
  lda   #$80
  sta   INIDISP

  %LoadToVRAM($700000,ComputeFramebufferSize(2,192),$0000)
  ; jmp   .end


.activeFrame:
  !A8
  lda   #$0F
  sta   INIDISP

.end:
  ply
  plx
  pla
  plp
  rti

IRQ:
  rti

DummyVector_0100:
  dw  NMI_WRAM   ;  ABORT/NMI -> 00:0100
  dw  $00
  dw  BRK_WRAM   ;  BRK       -> 00:0104
  dw  $00
  dw  RESET_WRAM ;  RESET     -> 00:0108
  dw  $00
  dw  IRQ_WRAM   ;  IRQ       -> 00:010C
  dw  $00
DummyVector_0100_end:


; ROM Address
RunGSUCode:
; WRAM Address This code will run from $00:0200
base $200
RunGSUCode_WRAM:
  php

  !A8
  lda   #01
  sta   GSU_CLSR  ; 1 = Clock 21.477 MHz
  sta   GSU_CFGR  ; 
  lda.b #(ScreenFrameBuffer)>>10
  sta   GSU_SCBR
  lda   #$00
  sta   GSU_PBR   ; ProgramBank = 0
  ; Give GSU exclusive access to ROM/SRAM
  ; height: 192 4bpp
  lda   #(!GSU_SCMR_RAN|!GSU_SCMR_ROM|!GSU_SCMR_2BPP|!GSU_SCMR_HEIGHT_192)
  sta   GSU_SCMR
  ; Set GSU PC and wakeup GSU
  !A16
  lda.w #GSU_Entry
  sta   GSU_PC

  lda.w #$0020
- bit   GSU_SFR     ; wait for GSU...
	bne   -

  !A8
	stz   GSU_SCMR    ; Give S-CPU ROM/SRAM access

  plp
  rts

NMI_WRAM:
  rti

IRQ_WRAM:
  rti

BRK_WRAM:
  rti

RESET_WRAM:
- jmp -

RunGSUCode_WRAM_end:
base off

GSU_Entry:
arch superfx
  ; Opaque
  ibt     r0,#$00
  cmode


  ; Draw current line
  move    r7,#DrawColor
  to      r7
  ldw     (r7)
  with    r7
  and     #3  
  from    r7
  color

  ; PLOT
  iwt   r1,#0 ; X = 100

  move  r9,#LastY
  to    r9
  ldw   (r9)
  move  r2,r9

  iwt   r12,#256
  ;
  cache
  ; Save loop address
  move  r13,r15
.repeat:
  plot
  loop
  nop

  rpix

  inc   r9
  iwt   r8, #192
  from  r8
  cmp   r9
  bpl   .writeback
  nop

  iwt   r9,#0


.writeback:
  move  r8,#LastY
  from  r9
  stw   (r8)

  move  r8,#DrawColor
  with  r8
  ldw   (r8)
  with  r8
  inc   r8
  move  r7,#DrawColor
  from  r8
  stw   (r7)

  stop


macro sfx_push(r)
  with   r10
  sub    #2
  from   <r>
  stw    (r10)
endmacro

macro sfx_pop(r)
  to    <r>
  ldw   (r10)
  with  r10
  add   #4
endmacro

macro sfx_jsr(addr)
  link  #4
  iwt   r15,#addr
  nop
endmacro

GSU_EntryX:
arch superfx
  iwt     r10,#__gsuStackTop
  ; Opaque
  ibt     r0,#$00
  cmode

  

  ; for (int y = clipMinY; y < clipMaxY; y++) {
  ;       for (int x = clipMinX; x < clipMaxX; x++) {

  ;           Vertex p{ x,y };

  ;           const float e1 = edgeFunctionf(v1, v2, p);
  ;           const float e2 = edgeFunctionf(v2, v3, p);
  ;           const float e3 = edgeFunctionf(v3, v1, p);

  ;           if ((e1 >= 0) && (e2 >= 0) && (e3 >= 0)) {
  ;               writePixel(g_Framebuffer, x, y, r, g, b);
  ;           }
  ;       }
  ;   }


  stop






; float edgeFunctionf(const Vertex& a, const Vertex& b, const Vertex& c)
; {
;     return (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x);
; }
; r0 = a.x
; r3 = a.Y
; r5 = b.x
; r7 = b.y
; r8 = c.x
; r9 = c.y

EdgeFunction:  
  ; R8 = CAX = (c.x - a.x)
  with  r8
  sub   r0
  ; R7 = BAY = (b.y - a.y)
  with  r7
  sub   r3
  ; R9 = CAY = (c.y - a.y)
  with  r9
  sub   r3
  ; R5 = BAX = (b.x - a.x)
  with  r5
  sub   r0
  ; (CAX*BAY)
  move  r6,r7
  from  r8
  lmult
  move  r8,r4
  ; (CAY*BAX)
  move  r6,r5
  from  r9
  lmult
  ; R0 = (CAX*BAY)-(CAY*BAX)
  with  r8
  sub   r9
  move  r0,r8
  jmp   r11


;;
V1: dw 100,20
V2: dw 23,140
V3: dw 190,170




title_pal:
  incbin  "gfx/grass.pal"

screen_map:
  ; !y = 0
  ; while !y <= 27 ; 192pixels
  ;   !x = 0
    
  ;   while !x < 32
  ;     if !y < 24 
  ;       dw !x*24+!y
  ;     else
  ;       dw 32*32-1 ; blank tile, last tile.
  ;     endif
  ;     !x #= !x+1
  ;   endif

  ;   !y #= !y+1
  ; endif

  !y = 0
  while !y <= 27 ; 192pixels
    !x = 0
    
    while !x < 32
      dw  !x*24+!y
      !x #= !x+1
    endif

    !y #= !y+1
  endif
  

____end: