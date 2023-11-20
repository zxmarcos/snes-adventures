includeonce


macro LoadPalette(idx,addr,length)
  ; Setup CGADDR to index
  !A8
  lda.b #<idx>
  sta   CGADD
  %DmaCopyAB(<addr>, CGDATA&$FF, <length>, %00000010)
endmacro

macro LoadToVRAM(addr,length,vramAddr)
  !A8
  ; Setup VRAM Addr autoincrement to 1 byte
  lda   #$80
  sta   VMAIN
  !A16
  lda.w #<vramAddr>
  sta   VMADDL
  %DmaCopyAB(<addr>, VMDATAL&$FF, <length>, %00000001)
endmacro



macro ClearVRAM(vramAddr,length)
  !A8
  ; Setup VRAM Addr autoincrement to 1 byte
  lda   #$80
  sta   VMAIN
  !A16
  lda.w #<vramAddr>
  sta   VMADDL
  %DmaCopyAB(Zero, VMDATAL&$FF, <length>, %00011001)
endmacro