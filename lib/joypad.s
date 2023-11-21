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
  lda.w JOY1L
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


; Buttons bitmasks
!JOY_Button_B       = "(1<<15)"     
!JOY_Button_Y       = "(1<<14)"     
!JOY_Select_Button  = "(1<<13)"     
!JOY_Start_Button   = "(1<<12)"     
!JOY_DPAD_Up        = "(1<<11)"     
!JOY_DPAD_Down      = "(1<<10)"     
!JOY_DPAD_Left      = "(1<<9)"      
!JOY_DPAD_Right     = "(1<<8)"      
!JOY_Button_A       = "(1<<7)"      
!JOY_Button_X       = "(1<<6)"      
!JOY_Button_L       = "(1<<5)"      
!JOY_Button_R       = "(1<<4)"      
