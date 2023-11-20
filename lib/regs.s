includeonce
; SNES REGisters

; Address Bus B REGisters

INIDISP     =   $2100   ;   Screen Display REGister   single   write   any time
OBSEL       =   $2101   ;   Object Size and Character Size REGister   single   write   f-blank, v-blank
OAMADDL     =   $2102   ;   OAM Address REGisters (Low)   single   write   f-blank, v-blank
OAMADDH     =   $2103   ;   OAM Address REGisters (High)   single   write   f-blank, v-blank
OAMDATA     =   $2104   ;   OAM Data Write REGister   single   write   f-blank, v-blank
BGMODE      =   $2105   ;   BG Mode and Character Size REGister   single   write   f-blank, v-blank, h-blank
MOSAIC      =   $2106   ;   Mosaic REGister   single   write   f-blank, v-blank, h-blank
BG1SC       =   $2107   ;   BG Tilemap Address REGisters (BG1)   single   write   f-blank, v-blank
BG2SC       =   $2108   ;   BG Tilemap Address REGisters (BG2)   single   write   f-blank, v-blank
BG3SC       =   $2109   ;   BG Tilemap Address REGisters (BG3)   single   write   f-blank, v-blank
BG4SC       =   $210A   ;   BG Tilemap Address REGisters (BG4)   single   write   f-blank, v-blank
BG12NBA     =   $210B   ;   BG Character Address REGisters (BG1&2)   single   write   f-blank, v-blank
BG34NBA     =   $210C   ;   BG Character Address REGisters (BG3&4)   single   write   f-blank, v-blank
BG1HOFS     =   $210D   ;   BG Scroll REGisters (BG1)   dual   write   f-blank, v-blank, h-blank
BG1VOFS     =   $210E   ;   BG Scroll REGisters (BG1)   dual   write   f-blank, v-blank, h-blank
BG2HOFS     =   $210F   ;   BG Scroll REGisters (BG2)   dual   write   f-blank, v-blank, h-blank
BG2VOFS     =   $2110   ;   BG Scroll REGisters (BG2)   dual   write   f-blank, v-blank, h-blank
BG3HOFS     =   $2111   ;   BG Scroll REGisters (BG3)   dual   write   f-blank, v-blank, h-blank
BG3VOFS     =   $2112   ;   BG Scroll REGisters (BG3)   dual   write   f-blank, v-blank, h-blank
BG4HOFS     =   $2113   ;   BG Scroll REGisters (BG4)   dual   write   f-blank, v-blank, h-blank
BG4VOFS     =   $2114   ;   BG Scroll REGisters (BG4)   dual   write   f-blank, v-blank, h-blank
VMAIN       =   $2115   ;   Video Port Control REGister   single   write   f-blank, v-blank
VMADDL      =   $2116   ;   VRAM Address REGisters (Low)   single   write   f-blank, v-blank
VMADDH      =   $2117   ;   VRAM Address REGisters (High)   single   write   f-blank, v-blank
VMDATAL     =   $2118   ;   VRAM Data Write REGisters (Low)   single   write   f-blank, v-blank
VMDATAH     =   $2119   ;   VRAM Data Write REGisters (High)   single   write   f-blank, v-blank
M7SEL       =   $211A   ;   Mode 7 Settings REGister   single   write   f-blank, v-blank
M7A         =   $211B   ;   Mode 7 Matrix REGisters   dual   write   f-blank, v-blank, h-blank
M7B         =   $211C   ;   Mode 7 Matrix REGisters   dual   write   f-blank, v-blank, h-blank
M7C         =   $211D   ;   Mode 7 Matrix REGisters   dual   write   f-blank, v-blank, h-blank
M7D         =   $211E   ;   Mode 7 Matrix REGisters   dual   write   f-blank, v-blank, h-blank
M7X         =   $211F   ;   Mode 7 Matrix REGisters   dual   write   f-blank, v-blank, h-blank
M7Y         =   $2120   ;   Mode 7 Matrix REGisters   dual   write   f-blank, v-blank, h-blank
CGADD       =   $2121   ;   CGRAM Address REGister   single   write   f-blank, v-blank, h-blank
CGDATA      =   $2122   ;   CGRAM Data Write REGister   dual   write   f-blank, v-blank, h-blank
W12SEL      =   $2123   ;   Window Mask Settings REGisters   single   write   f-blank, v-blank, h-blank
W34SEL      =   $2124   ;   Window Mask Settings REGisters   single   write   f-blank, v-blank, h-blank
WOBJSEL     =   $2125   ;   Window Mask Settings REGisters   single   write   f-blank, v-blank, h-blank
WH0         =   $2126   ;   Window Position REGisters (WH0)   single   write   f-blank, v-blank, h-blank
WH1         =   $2127   ;   Window Position REGisters (WH1)   single   write   f-blank, v-blank, h-blank
WH2         =   $2128   ;   Window Position REGisters (WH2)   single   write   f-blank, v-blank, h-blank
WH3         =   $2129   ;   Window Position REGisters (WH3)   single   write   f-blank, v-blank, h-blank
WBGLOG      =   $212A   ;   Window Mask Logic REGisters (BG)   single   write   f-blank, v-blank, h-blank
WOBJLOG     =   $212B   ;   Window Mask Logic REGisters (OBJ)   single   write   f-blank, v-blank, h-blank
TM          =   $212C   ;   Screen Destination REGisters   single   write   f-blank, v-blank, h-blank
TS          =   $212D   ;   Screen Destination REGisters   single   write   f-blank, v-blank, h-blank
TMW         =   $212E   ;   Window Mask Destination REGisters   single   write   f-blank, v-blank, h-blank
TSW         =   $212F   ;   Window Mask Destination REGisters   single   write   f-blank, v-blank, h-blank
CGWSEL      =   $2130   ;   Color Math REGisters   single   write   f-blank, v-blank, h-blank
CGADSUB     =   $2131   ;   Color Math REGisters   single   write   f-blank, v-blank, h-blank
COLDATA     =   $2132   ;   Color Math REGisters   single   write   f-blank, v-blank, h-blank
SETINI      =   $2133   ;   Screen Mode Select REGister   single   write   f-blank, v-blank, h-blank
MPYL        =   $2134   ;   Multiplication Result REGisters   single   read   f-blank, v-blank, h-blank
MPYM        =   $2135   ;   Multiplication Result REGisters   single   read   f-blank, v-blank, h-blank
MPYH        =   $2136   ;   Multiplication Result REGisters   single   read   f-blank, v-blank, h-blank
SLHV        =   $2137   ;   Software Latch REGister   single      any time
OAMDATAREAD =   $2138   ;   OAM Data Read REGister   dual   read   f-blank, v-blank
VMDATALREAD =   $2139   ;   VRAM Data Read REGister (Low)   single   read   f-blank, v-blank
VMDATAHREAD =   $213A   ;   VRAM Data Read REGister (High)   single   read   f-blank, v-blank
CGDATAREAD  =   $213B   ;   CGRAM Data Read REGister   dual   read   f-blank, v-blank
OPHCT       =   $213C   ;   Scanline Location REGisters (Horizontal)   dual   read   any time
OPVCT       =   $213D   ;   Scanline Location REGisters (Vertical)   dual   read   any time
STAT77      =   $213E   ;   PPU Status REGister   single   read   any time
STAT78      =   $213F   ;   PPU Status REGister   single   read   any time
APUIO0      =   $2140   ;   APU IO REGisters   single   both   any time
APUIO1      =   $2141   ;   APU IO REGisters   single   both   any time
APUIO2      =   $2142   ;   APU IO REGisters   single   both   any time
APUIO3      =   $2143   ;   APU IO REGisters   single   both   any time
WMDATA      =   $2180   ;   WRAM Data REGister   single   both   any time
WMADDL      =   $2181   ;   WRAM Address REGisters   single   write   any time
WMADDM      =   $2182   ;   WRAM Address REGisters   single   write   any time
WMADDH      =   $2183   ;   WRAM Address REGisters   single   write   any time


; Old Style Joypad REGisters

JOYSER0     =   $4016   ;   Old Style Joypad REGisters   single (write)   read/write   any time that is not auto-joypad
JOYSER1     =   $4017   ;   Old Style Joypad REGisters   many (read)   read   any time that is not auto-joypad


; Internal CPU REGisters

NMITIMEN    =   $4200   ;   Interrupt Enable REGister   single   write   any time
WRIO        =   $4201   ;   IO Port Write REGister   single   write   any time
WRMPYA      =   $4202   ;   Multiplicand REGisters   single   write   any time
WRMPYB      =   $4203   ;   Multiplicand REGisters   single   write   any time
WRDIVL      =   $4204   ;   Divisor & Dividend REGisters   single   write   any time
WRDIVH      =   $4205   ;   Divisor & Dividend REGisters   single   write   any time
WRDIVB      =   $4206   ;   Divisor & Dividend REGisters   single   write   any time
HTIMEL      =   $4207   ;   IRQ Timer REGisters (Horizontal - Low)   single   write   any time
HTIMEH      =   $4208   ;   IRQ Timer REGisters (Horizontal - High)   single   write   any time
VTIMEL      =   $4209   ;   IRQ Timer REGisters (Vertical - Low)   single   write   any time
VTIMEH      =   $420A   ;   IRQ Timer REGisters (Vertical - High)   single   write   any time
MDMAEN      =   $420B   ;   DMA Enable REGister   single   write   any time
HDMAEN      =   $420C   ;   HDMA Enable REGister   single   write   any time
MEMSEL      =   $420D   ;   ROM Speed REGister   single   write   any time
RDNMI       =   $4210   ;   Interrupt Flag REGisters   single   read   any time
TIMEUP      =   $4211   ;   Interrupt Flag REGisters   single   read   any time
HVBJOY      =   $4212   ;   PPU Status REGister   single   read   any time
RDIO        =   $4213   ;   IO Port Read REGister   single   read   any time
RDDIVL      =   $4214   ;   Multiplication Or Divide Result REGisters (Low)   single   read   any time
RDDIVH      =   $4215   ;   Multiplication Or Divide Result REGisters (High)   single   read   any time
RDMPYL      =   $4216   ;   Multiplication Or Divide Result REGisters (Low)   single   read   any time
RDMPYH      =   $4217   ;   Multiplication Or Divide Result REGisters (High)   single   read   any time
JOY1L       =   $4218   ;   Controller Port Data REGisters (Pad 1 - Low)   single   read   any time that is not auto-joypad
JOY1H       =   $4219   ;   Controller Port Data REGisters (Pad 1 - High)   single   read   any time that is not auto-joypad
JOY2L       =   $421A   ;   Controller Port Data REGisters (Pad 2 - Low)   single   read   any time that is not auto-joypad
JOY2H       =   $421B   ;   Controller Port Data REGisters (Pad 2 - High)   single   read   any time that is not auto-joypad
JOY3L       =   $421C   ;   Controller Port Data REGisters (Pad 3 - Low)   single   read   any time that is not auto-joypad
JOY3H       =   $421D   ;   Controller Port Data REGisters (Pad 3 - High)   single   read   any time that is not auto-joypad
JOY4L       =   $421E   ;   Controller Port Data REGisters (Pad 4 - Low)   single   read   any time that is not auto-joypad
JOY4H       =   $421F   ;   Controller Port Data REGisters (Pad 4 - High)   single   read   any time that is not auto-joypad

; DMA/HDMA REGisters

DMAP0       =   $4300   ;   (H)DMA Control REGister
BBAD0       =   $4301   ;   (H)DMA Destination REGister
A1T0L       =   $4302   ;   (H)DMA Source Address REGisters
A1T0H       =   $4303   ;   (H)DMA Source Address REGisters
A1B0        =   $4304   ;   (H)DMA Source Address REGisters
DAS0L       =   $4305   ;   (H)DMA Size REGisters (Low)
DAS0H       =   $4306   ;   (H)DMA Size REGisters (High)
DASB0       =   $4307   ;   HDMA Indirect Address REGisters
A2A0L       =   $4308   ;   HDMA Mid Frame Table Address REGisters (Low)
A2A0H       =   $4309   ;   HDMA Mid Frame Table Address REGisters (High)
NTLR0       =   $430A   ;   HDMA Line Counter REGister

DMAP1       =   $4310   ;   (H)DMA Control REGister
BBAD1       =   $4311   ;   (H)DMA Destination REGister
A1T1L       =   $4312   ;   (H)DMA Source Address REGisters
A1T1H       =   $4313   ;   (H)DMA Source Address REGisters
A1B1        =   $4314   ;   (H)DMA Source Address REGisters
DAS1L       =   $4315   ;   (H)DMA Size REGisters (Low)
DAS1H       =   $4316   ;   (H)DMA Size REGisters (High)
DASB1       =   $4317   ;   HDMA Indirect Address REGisters
A2A1L       =   $4318   ;   HDMA Mid Frame Table Address REGisters (Low)
A2A1H       =   $4319   ;   HDMA Mid Frame Table Address REGisters (High)
NTLR1       =   $431A   ;   HDMA Line Counter REGister

DMAP2       =   $4320   ;   (H)DMA Control REGister
BBAD2       =   $4321   ;   (H)DMA Destination REGister
A1T2L       =   $4322   ;   (H)DMA Source Address REGisters
A1T2H       =   $4323   ;   (H)DMA Source Address REGisters
A1B2        =   $4324   ;   (H)DMA Source Address REGisters
DAS2L       =   $4325   ;   (H)DMA Size REGisters (Low)
DAS2H       =   $4326   ;   (H)DMA Size REGisters (High)
DASB2       =   $4327   ;   HDMA Indirect Address REGisters
A2A2L       =   $4328   ;   HDMA Mid Frame Table Address REGisters (Low)
A2A2H       =   $4329   ;   HDMA Mid Frame Table Address REGisters (High)
NTLR2       =   $432A   ;   HDMA Line Counter REGister

DMAP3       =   $4330   ;   (H)DMA Control REGister
BBAD3       =   $4331   ;   (H)DMA Destination REGister
A1T3L       =   $4332   ;   (H)DMA Source Address REGisters
A1T3H       =   $4333   ;   (H)DMA Source Address REGisters
A1B3        =   $4334   ;   (H)DMA Source Address REGisters
DAS3L       =   $4335   ;   (H)DMA Size REGisters (Low)
DAS3H       =   $4336   ;   (H)DMA Size REGisters (High)
DASB3       =   $4337   ;   HDMA Indirect Address REGisters
A2A3L       =   $4338   ;   HDMA Mid Frame Table Address REGisters (Low)
A2A3H       =   $4339   ;   HDMA Mid Frame Table Address REGisters (High)
NTLR3       =   $433A   ;   HDMA Line Counter REGister

DMAP4       =   $4340   ;   (H)DMA Control REGister
BBAD4       =   $4341   ;   (H)DMA Destination REGister
A1T4L       =   $4342   ;   (H)DMA Source Address REGisters
A1T4H       =   $4343   ;   (H)DMA Source Address REGisters
A1B4        =   $4344   ;   (H)DMA Source Address REGisters
DAS4L       =   $4345   ;   (H)DMA Size REGisters (Low)
DAS4H       =   $4346   ;   (H)DMA Size REGisters (High)
DASB4       =   $4347   ;   HDMA Indirect Address REGisters
A2A4L       =   $4348   ;   HDMA Mid Frame Table Address REGisters (Low)
A2A4H       =   $4349   ;   HDMA Mid Frame Table Address REGisters (High)
NTLR4       =   $434A   ;   HDMA Line Counter REGister

DMAP5       =   $4350   ;   (H)DMA Control REGister
BBAD5       =   $4351   ;   (H)DMA Destination REGister
A1T5L       =   $4352   ;   (H)DMA Source Address REGisters
A1T5H       =   $4353   ;   (H)DMA Source Address REGisters
A1B5        =   $4354   ;   (H)DMA Source Address REGisters
DAS5L       =   $4355   ;   (H)DMA Size REGisters (Low)
DAS5H       =   $4356   ;   (H)DMA Size REGisters (High)
DASB5       =   $4357   ;   HDMA Indirect Address REGisters
A2A5L       =   $4358   ;   HDMA Mid Frame Table Address REGisters (Low)
A2A5H       =   $4359   ;   HDMA Mid Frame Table Address REGisters (High)
NTLR5       =   $435A   ;   HDMA Line Counter REGister

DMAP6       =   $4360   ;   (H)DMA Control REGister
BBAD6       =   $4361   ;   (H)DMA Destination REGister
A1T6L       =   $4362   ;   (H)DMA Source Address REGisters
A1T6H       =   $4363   ;   (H)DMA Source Address REGisters
A1B6        =   $4364   ;   (H)DMA Source Address REGisters
DAS6L       =   $4365   ;   (H)DMA Size REGisters (Low)
DAS6H       =   $4366   ;   (H)DMA Size REGisters (High)
DASB6       =   $4367   ;   HDMA Indirect Address REGisters
A2A6L       =   $4368   ;   HDMA Mid Frame Table Address REGisters (Low)
A2A6H       =   $4369   ;   HDMA Mid Frame Table Address REGisters (High)
NTLR6       =   $436A   ;   HDMA Line Counter REGister

DMAP7       =   $4370   ;   (H)DMA Control REGister
BBAD7       =   $4371   ;   (H)DMA Destination REGister
A1T7L       =   $4372   ;   (H)DMA Source Address REGisters
A1T7H       =   $4373   ;   (H)DMA Source Address REGisters
A1B7        =   $4374   ;   (H)DMA Source Address REGisters
DAS7L       =   $4375   ;   (H)DMA Size REGisters (Low)
DAS7H       =   $4376   ;   (H)DMA Size REGisters (High)
DASB7       =   $4377   ;   HDMA Indirect Address REGisters
A2A7L       =   $4378   ;   HDMA Mid Frame Table Address REGisters (Low)
A2A7H       =   $4379   ;   HDMA Mid Frame Table Address REGisters (High)
NTLR7       =   $437A   ;   HDMA Line Counter REGister