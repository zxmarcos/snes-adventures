includeonce

!A8     = "sep #$20"
!XY8    = "sep #$10"
!AXY8   = "sep #$30"

!A16    = "rep #$20"
!XY16   = "rep #$10"
!AXY16  = "rep #$30"



macro DmaCopyAB(addr,dstReg,length,mode)
  !A16
  ; Setup A-Bus src address BHL
  lda.w #<addr>
  sta   A1T0L
  
  !XY8
  ldx.b #bank(<addr>)
  stx   A1B0

  ; Setup transfer length
  lda.w #<length>
  sta   DAS0L

  ; Setup B-Bus dst register number
  !A8
  lda.b #<dstReg>
  sta   BBAD0

  ; Setup mode
  lda.b #<mode>
  sta   DMAP0

  ; Start transfer
  lda.b #%00000001
  sta   MDMAEN
endmacro



!JOY_Button_B = "(1<<15)"     
!JOY_Button_Y = "(1<<14)"     
!JOY_Select_Button = "(1<<13)"     
!JOY_Start_Button = "(1<<12)"     
!JOY_DPAD_Up = "(1<<11)"     
!JOY_DPAD_Down = "(1<<10)"     
!JOY_DPAD_Left = "(1<<9)"      
!JOY_DPAD_Right = "(1<<8)"      
!JOY_Button_A = "(1<<7)"      
!JOY_Button_X = "(1<<6)"      
!JOY_Button_L = "(1<<5)"      
!JOY_Button_R = "(1<<4)"      
