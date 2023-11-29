includeonce
org $0000

Zero:
    skip 2




; SRAM / GSU Memory
base $700000

function ComputeFramebufferSize(bpp,height) = (height/8)*(256/8)*(8*bpp)

ScreenFrameBuffer: skip ComputeFramebufferSize(2,240)

LastX: skip 2
LastY: skip 2
DrawColor: skip 2
GTemp1: skip 2
GTemp2: skip 2

__stackBottom:
skip 2*64
__gsuStackTop:


base off
