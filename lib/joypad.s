includeonce


ReadJoypads:
  !A8
.loop:
  ; Busy wait joypad auto reading
  lda   HVBJOY
  bit   #$1
  bne   .loop

  !XY16
  ldx   Joypad1
  stx   Joypad1Last

  !A16
  lda.w  JOY1L
  sta   Joypad1
  
  ; X = Current joypad state
  tax

  ; Logic for Button Up (Last & ~Current)
  eor.w #$FFFF
  and   Joypad1Last
  sta   Joypad1Up


  ; Logic for Button Down (~Last & Current)
  txa
  sta   Temp1
  lda   Joypad1Last
  eor.w #$FFFF
  and   Temp1
  sta   Joypad1Down

  ; Logic for Button Hold  (Last & Current)
  txa
  and   Joypad1Last
  sta   Joypad1Hold


  rts
