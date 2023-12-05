
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
  %LoadToVRAM($700000,ComputeFramebufferSize(2,192),$0000)

  jsr   EnableVideo

.loop:
  wai
  ;jsr   RunGSUCode_WRAM
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
  rti
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

  %EnableNMI()
  rti

IRQ:
  rti

DummyVector_0100:
  jmp NMI_WRAM
  db $00
  jmp BRK_WRAM
  db $00
  jmp RESET_WRAM
  db $00
  jmp IRQ_WRAM


  ; dw  NMI_WRAM   ;  ABORT/NMI -> 00:0100
  ; dw  $00
  ; dw  BRK_WRAM   ;  BRK       -> 00:0104
  ; dw  $00
  ; dw  RESET_WRAM ;  RESET     -> 00:0108
  ; dw  $00
  ; dw  IRQ_WRAM   ;  IRQ       -> 00:010C
  ; dw  $00
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
  lda.b   #(1<<7)|(1<<5)
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
  lda.w #GSU_EntryX
  sta   GSU_PC

  !A8
  lda   #$20
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

; ---- CONVENTIONS
; R10 = Stack pointer
; R11 = Load Address Pointer
; 

macro g_push(r)
  with   r10
  sub    #2
  from   <r>
  stw    (r10)
endmacro

macro g_pop(r)
  to    <r>
  ldw   (r10)
  add   #2
endmacro

macro g_jsr(addr)
  link  #4
  iwt   r15,#<addr>
  nop
endmacro

macro g_getw(r,addr)
  move  r14,#<addr> ; 6 cyc
  with  <r>         ; 8 cyc
  getb
  inc   r14         ; 3 cyc
  with  <r>
  getbh
endmacro

macro g_ldw(r,addr)
  lm  <r>,(<addr>)
endmacro

; R11? 
macro g_stw(r,addr)
  sm (<addr>),<r>
endmacro

macro g_sub(dst,a,b)
  from <a>
  to <dst>
  sub <b>
endmacro

macro g_sub2(dst,b)
  with <dst>
  sub <b>
endmacro

macro g_add(dst,a,b)
  from <a>
  to <dst>
  add <b>
endmacro

macro g_add2(dst,b)
  with <dst>
  add <b>
endmacro

macro g_ljmp(label)
  iwt    r11,#<label>
  jmp    r11
  nop
endmacro

macro g_rts()
  jmp    r11
  nop
endmacro

macro g_lmult(dst,a,b)
  move  r6,<b>
  with  <a>
  lmult
  move  <dst>,r4
endmacro



macro orient2D(A,B,dst)
  %g_stw(r1,_CX)
  %g_stw(r2,_CY)
  ; V1
  %g_getw(r0,<A>)
  %g_stw(r0,_AX)
  %g_getw(r3,<A>+2)
  %g_stw(r3,_AY)
  ; V2
  %g_getw(r0,<B>)
  %g_stw(r0,_BX)
  %g_getw(r3,<B>+2)
  %g_stw(r3,_BY)
  
  %g_jsr(Orient2D)
  %g_stw(r0,<dst>)
endmacro


; https://fgiesen.wordpress.com/2013/02/10/optimizing-the-basic-rasterizer/
GSU_EntryX:
arch superfx
  iwt     r10,#__gsuStackTop
  ; Opaque
  ibt     r0,#$00
  cmode
  ibt     r0,#$03
  color

  %g_jsr(ComputeBBox)
  ; Triangle setup
  %g_jsr(TriangleSetup)

  %g_ldw(r1,MinX)
  %g_ldw(r2,MinY)
  %orient2D(Vertex2,Vertex3,_W1_ROW)
  %orient2D(Vertex3,Vertex1,_W2_ROW)
  %orient2D(Vertex1,Vertex2,_W3_ROW)

  ; Maximum register pressure!
  ; R0 = scratch
  ; R1 = X
  ; R2 = Y
  ; R3 = XMin
  ; R4 = YPixels
  ; R5 = A12
  ; R6 = A23
  ; R7 = A31
  ; R8 = W0
  ; R9 = W1
  ; R10 = W2
  ; R11 = LastPixelWasValid
  ; R12 = loop counter
  ; R13 = loop pointer
  ; R14 = XPixels
  ; R15 = ProgramCounter
  
  %g_ldw(r3,MinX)
  %g_ldw(r4,MinY)
  move  r1,r3
  move  r2,r4
  %g_ldw(r4,YPixels)

  %g_ldw(r14,XPixels)

  %g_ldw(r5,_A12)
  %g_ldw(r6,_A23)
  %g_ldw(r7,_A31)

  ; Reload W1,W2,W3
  %g_ldw(r8,_W1_ROW)
  %g_ldw(r9,_W2_ROW)
  %g_ldw(r10,_W3_ROW)

.loopY:
  ibt   r0,#0
  from  r4
  cmp   r0
  bpl   .nextY
  nop

  ; End
  rpix
  stop
  nop

.nextY:
  cache
  ; Reset last pixel validity
  ibt   r11,#0

  ; Reset X = XMin
  move  r1,r3

  ; Reset loop counter = XPixels
  move  r12,r14
  
  ibt    r0,#0
  move  r13,r15
  
.loopX:
  ; w1 >= 0
  from   r8
  cmp    r0
  blt    .blankPixel
  ; w2 >= 0
  from   r9
  cmp    r0
  blt    .blankPixel
  ; w3 >= 0
  from   r10
  cmp    r0
  blt    .blankPixel
  nop
  
  plot
 
  bra   .nextPixel
  ; valid pixel
  ; 1 byte instruction
  inc     r11

.blankPixel:

  ; Check if last pixel was valid. != 0
  moves   r11,r11
  bne   .skipLeftPixels

  ; Increment X
  inc     r1
.nextPixel:
  ; w1 += A23;
  ; w2 += A31;
  ; w3 += A12;
  %g_add2(r8,r6)
  %g_add2(r9,r7)
  %g_add2(r10,r5)

  loop
  nop
.skipLeftPixels:
  ; Flush pixel cache for this line
  rpix

  ;w1_row += B23;
  ;w2_row += B31;
  ;w3_row += B12;

  %g_ldw(r0,_B23)
  %g_ldw(r8,_W1_ROW)
  %g_add2(r8,r0)
  from  r8
  sbk
  
  %g_ldw(r0,_B31)
  %g_ldw(r9,_W2_ROW)
  %g_add2(r9,r0)
  from  r9
  sbk

  %g_ldw(r0,_B12)
  %g_ldw(r10,_W3_ROW)
  %g_add2(r10,r0)
  from  r10
  sbk

  ; Y++
  inc   r2
  bra   .loopY
  ; YPixels--
  dec   r4

.end:
  rpix
  stop
  nop


TriangleSetup:
  %g_push(r11)
  ; ---
  %g_getw(r0,Vertex1+2)
  %g_getw(r1,Vertex2+2)
  %g_sub2(r0,r1)
  %g_stw(r0,_A12)

  %g_getw(r2,Vertex2)
  %g_getw(r3,Vertex1)
  %g_sub2(r2,r3)
  %g_stw(r2,_B12)

  ; ---
  %g_getw(r0,Vertex2+2)
  %g_getw(r1,Vertex3+2)
  %g_sub2(r0,r1)
  %g_stw(r0,_A23)

  %g_getw(r2,Vertex3)
  %g_getw(r3,Vertex2)
  %g_sub2(r2,r3)
  %g_stw(r2,_B23)

  ; ---
  %g_getw(r0,Vertex3+2)
  %g_getw(r1,Vertex1+2)
  %g_sub2(r0,r1)
  %g_stw(r0,_A31)

  %g_getw(r2,Vertex1)
  %g_getw(r3,Vertex3)
  %g_sub2(r2,r3)
  %g_stw(r2,_B31)

  %g_pop(r11)
  %g_rts()

ComputeBBox:
  %g_push(r11)
  ; r1 = X1
  ; r2 = X2
  ; r3 = X3

  ; Get Min X
  %g_getw(r1,Vertex1)
  %g_getw(r2,Vertex2)
  move      r7,r1
  move      r8,r2
  %g_jsr(Min)
  %g_stw(r7,MinX)

  
  %g_getw(r1,Vertex3)
  move      r8,r1
  %g_jsr(Min)
  %g_stw(r7,MinX)

  ; Get Max X
  %g_getw(r1,Vertex1)
  %g_getw(r2,Vertex2)
  move      r7,r1
  move      r8,r2
  %g_jsr(Max)

  %g_stw(r7,MaxX)
  
  %g_getw(r1,Vertex3)
  move      r8,r1
  %g_jsr(Max)
  %g_stw(r7,MaxX)

  ; Get Min Y
  %g_getw(r1,Vertex1+2)
  %g_getw(r2,Vertex2+2)
  move      r7,r1
  move      r8,r2
  %g_jsr(Min)
  %g_stw(r7,MinY)
  
  %g_getw(r1,Vertex3+2)
  move      r8,r1
  %g_jsr(Min)
  %g_stw(r7,MinY)

  ; Get Max Y
  %g_getw(r1,Vertex1+2)
  %g_getw(r2,Vertex2+2)
  move      r7,r1
  move      r8,r2
  %g_jsr(Max)

  %g_stw(r7,MaxY)
  
  %g_getw(r1,Vertex3+2)
  move      r8,r1
  %g_jsr(Max)
  %g_stw(r7,MaxY)
  
  %g_ldw(r0,MaxX)
  %g_ldw(r1,MinX)
  %g_sub(r0,r0,r1)
  %g_stw(r0,XPixels)

  %g_ldw(r0,MaxY)
  %g_ldw(r1,MinY)
  %g_sub(r0,r0,r1)
  %g_stw(r0,YPixels)

  %g_pop(r11)


  jmp       r11
  nop

; r7 = A 
; r8 = B
Min:
  from  r7
  cmp   r8
  bpl   .minor
  nop
  jmp   r11
  nop
.minor:
  move  r7,r8
  jmp   r11
  nop

; r7 = A 
; r8 = B
Max:
  from  r7
  cmp   r8
  bmi   .major
  nop
  jmp   r11
  nop
.major:
  move  r7,r8
  jmp   r11
  nop



Orient2D: 
  ; move r0,#1
  ; jmp r11
  ; nop
  %g_ldw(r0,_BX)
  %g_ldw(r3,_AX)
  %g_sub(r0,r0,r3)

  %g_ldw(r3,_CY)
  %g_ldw(r5,_AY)
  %g_sub(r3,r3,r5)

  %g_lmult(r0,r0,r3)
  %g_push(r0)

  %g_ldw(r0,_BY)
  %g_ldw(r3,_AY)
  %g_sub(r0,r0,r3)

  %g_ldw(r3,_CX)
  %g_ldw(r5,_AX)
  %g_sub(r3,r3,r5)

  %g_lmult(r0,r0,r3)
  move r3,r0

  %g_pop(r0)
  %g_sub(r0,r0,r3)
  
  jmp   r11
  nop

Vertex1: dw 128,10
Vertex2: dw 200,130
Vertex3: dw 56,130


title_pal:
  incbin  "gfx/grass.pal"

screen_map:
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