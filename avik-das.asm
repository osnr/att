; sprite.asm - Avik Das
;
; A very simple demo, based on the Game Boy Programming Tutorial by
; David Pello available at
; http://wiki.ladecadence.net/doku.php?id=tutorial_de_ensamblador.
; This demo can be assembled using RGBDS. The resulting output should
; be viewable in any compliant Game Boy emulator.
;
; This demo serves two purposes. Firstly, my goal is to learn Game Boy
; development, which I can only achieve by creating a program.
; Secondly, the entirety of the program will be in one file, in order
; to show at a glance all the different parts of the program.

  ; = DATA/VARIABLES ==================================================

  ; Here we set up some locations in memory to store data that will be
  ; used in the program. Typically, we will store data in the internal
  ; RAM, which gives us 8KB to work with.

SECTION "RAM",WRAM0[$c000]

BGSCRL: DB ; amount to scroll the background by

SECTION "vblank",ROM0[$40]
  nop
  jp vblank

SECTION "timer" ,ROM0[$50]
  nop
  reti

SECTION "start",ROM0[$100]
  jp start
  reti

  ; = CATRIDGE HEADER =================================================

  ; Nintendo logo. must be exactly as given
  DB $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
  DB $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
  DB $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E
  
  DB "AVIKTEST",0,0,0,0,0,0,0 ; title, upper case ASCII, 15 bytes
  DB 0   ; not a GBC catridge
  DB 0,0 ; new licensee code, high and low nibbles. not important
  DB 0   ; not SGB
  DB 0   ; catridge type, ROM only
  DB 0   ; ROM size, 256Kbit = 32KByte = 2 banks
  DB 0   ; RAM size, no RAM
  DB 1   ; destination code, non-Japanese
  DB $33 ; old licensee code, $33 => check new licensee code
  DB 0   ; mask ROM version number, usually 0
  DB 0   ; complement check. computed by rgbfix. important.
  DW 0   ; checksum. computed by rgbfix. not important.

  ; = INITIALIZATION ==================================================

start:
  nop
  di           ; disable interrupts
  ld sp, $ffff ; put the stack at the top of the RAM

init:
  ld  a,[$ff40] ; load the LCD Control register
  bit 7,a       ; check bit 7, whether the LCD is on
  jr z,continue_init         ; if off, return immediately

wait_vblank:
  ld a,[$ff44]  ; load the vertical line the LCD is at
  cp 145
  jr nz, wait_vblank

  ; Technically, at this point, we are not just at VBlank, but exactly
  ; at the start of VBlank. This is because the previous instruction
  ; made sure that [LY] is exactly 145, the first value when entering
  ; VBlank.

  ld  a,[$ff40] ; load the LCD Control register
  res 7,a       ; clear bit 7, turning off the LCD
  ld  [$ff40],a ; write the new value back to the LCD Control register

continue_init: 
  ; TODO init ram variables

  call load_bg

  ld a,%11010101
  ld [$ff40],a   ; write it to the LCD Control register


  ;; ld a,%00000101 ; enable V-Blank interrupt
  ;;                ; enable timer   interrupt
  ;; ld [$ffff],a
  ;; ei

  ; = MAIN LOOP =======================================================

loop:
  ;; halt
  ;; nop

  jr   loop

  ; = INITIALIZATION FUNCTIONS ========================================

  ; = UTILITY FUNCTIONS ===============================================

memcpy:
  ; parameters:
  ;   hl = source address
  ;   de = destination address
  ;   bc = number of bytes to copy
  ; assumes:
  ;   bc > 0
  ld a,[hl] ; load a byte from the source
  ld [de],a ; store it in the destination
  inc hl    ; prepare to load another byte...
  inc de    ; ...and prepare to write it

  ; Now we'll decrement the counter and check if it's zero.
  ; Unfortunately, when a 16-bit register is decremented, the zero flag
  ; is not updated, so we need to check if the counter is zero manually.
  ; A 16-bit value is zero when its constituent 8-bit portions are both
  ; zero, that is when (b | c) == 0, where "|" is a bitwise OR.
  dec bc    ; decrement the counter
  ld  a,b
  or  c
  ret z     ; return if all bytes written

  jr memcpy

zeromem:
    ; parameters
    ;   de = destination address
    ;   bc = number of bytes to zero out
    ; assumes:
    ;   bc > 0
.zeromem_loop:
  ld a,0    ; we will only be writing zeros
  ld [de],a ; store one byte in the destination
  inc de    ; prepare to write another byte

  ; the same caveat applies as in memcpy
  dec bc    ; decrement the counter
  ld  a,b
  or  c
  ret z     ; return if all bytes written

  jr .zeromem_loop


  ; = DATA ============================================================

bgpal:
  DB %00000100 ; white is transparent, with another non-transparent
               ; white. The only other important color is the second-
               ; lightest color.
wnpal:
  DB %00011001 ; light gray is transparent, with the only non-
               ; transparent color being dark gray.

sppal:
  DB %00011100 ; missing second darkest
  DB %11100000 ; missing second lightest


INCLUDE "att-gameboy.inc"

; vim: ft=rgbasm:tw=72:ts=2:sw=2
scroll_bg:
  ld a,[BGSCRL]
  ld [$ff42],a ; set scrolly
  ret
  
load_bg:
  ;; ; reset the screen position
  ld a,0
  ld [$ff43],a ; scrollx will always be 0
  ld [BGSCRL],a
  call scroll_bg

  ; load the background tiles into the Tile Data Table
  ld hl,attgameboy_tile_data  ; source address
  ld de,$8000  ; destination address
  ld bc,attgameboy_tile_data_size     ; number of bytes to copy
  call memcpy

  ; load background into Background Tile Map
  ld hl,attgameboy_map_data
  ld de,$9800
  ld bc,$10
  call memcpy

  ret

vblank:
  push af
  push bc
  push de
  push hl
  call scroll_bg
  pop  hl
  pop  de
  pop  bc
  pop  af
  reti
