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


macro DisableNMI()
  php
  !A8
  lda   NMITIMEN
  and   #$7F
  sta   NMITIMEN
  plp
endmacro

macro EnableNMI()
  php
  !A8
  lda   NMITIMEN
  ora   #$80
  sta   NMITIMEN
  plp
endmacro


;; From: https://codebase64.org/doku.php?id=base:small_fast_8-bit_prng
Rand8:
  php
  !A8
  !XY8
  lda   rand_seed
  ldx   rand_seed+1
  beq   .doEor
  asl
  eor   #$FF
  beq   .noEor ;if the input was $80, skip the EOR
  bcc   .noEor
.doEor:
  eor   #$1d
.noEor:
  sta   Temp1
  sta   rand_seed+1
  txa
  adc   Temp1
  sta   rand_seed
  plp
  rts