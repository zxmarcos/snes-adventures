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

__stackBottom:
skip 2*64
__gsuStackTop:


base off
