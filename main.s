incsrc "snes_header.s"

; RAM SECTION
incsrc "state.s"

; CODE SECTION
org $8000
base $8000

incsrc "lib/regs.s"
incsrc "lib/utils.s"
incsrc "lib/gfx.s"
incsrc "lib/joypad.s"
incsrc "game.s"
