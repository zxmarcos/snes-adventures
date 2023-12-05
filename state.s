includeonce
org $0000

Zero:
    skip 2




; SRAM / GSU Memory
base $700000

function ComputeFramebufferSize(bpp,height) = (height/8)*(256/8)*(8*bpp)

ScreenFrameBuffer: skip ComputeFramebufferSize(2,192)


MinX: skip 2
MaxX: skip 2
MinY: skip 2
MaxY: skip 2
XPixels: skip 2
YPixels: skip 2
_AX:    skip 2
_AY:    skip 2
_BX:    skip 2
_BY:    skip 2
_CX:    skip 2
_CY:    skip 2
_W1_ROW: skip 2
_W2_ROW: skip 2
_W3_ROW: skip 2
_A12: skip 2
_B12: skip 2
_A23: skip 2
_B23: skip 2
_A31: skip 2
_B31: skip 2


__stackBottom:
skip 2*16
__gsuStackTop:


base off
