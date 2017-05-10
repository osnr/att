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

SECTION "vblank",ROM0[$40]
  nop
  ;; jp vblank

SECTION "timer" ,ROM0[$50]
  nop
  ;; jp timer

SECTION "start",ROM0[$100]
  nop
  jp start

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
  call init_audio
  call start_timer

  ld a,%11010101
  ld [$ff40],a   ; write it to the LCD Control register

  ;; ld a,%00000101 ; enable V-Blank interrupt
  ;;                ; enable timer   interrupt
  ;; ld [$ffff],a
  ;; ei

  ; = MAIN LOOP =======================================================

  ld h, a                     ; initialize scroll count, H = 0

  ld a, $64
  ld d, $84                       ; set loop count, D = $64
  ld [$ff42],a
  ld a, $91
  ld [$ff40],a
  inc b
soundcountdown:
  ld e, $02
resetc:
  ld c, $0c
waitforvblank:
  ld a,[$ff44]
  cp $90
  jr nz, waitforvblank

  dec c
  jr nz, waitforvblank

  dec e
  jr nz, resetc
  ld c, $13

  inc h         ; increment scroll count
  ld a, h

  ld e, $83                     ; sound 1
  cp $56
  jr z, playsound

  ld e, $c1                     ; sound 2
  cp $58
  jr nz, skipplaysound

playsound:
  ld a, e
  ld [$ff13], a
  ld a, $87
  ld [$ff14], a

skipplaysound:
  ld a, [$ff42]
  sub b
  ld [$ff42], a
  dec d
  jr nz, soundcountdown

  dec b
  jr nz, loop

  ld d, $20
  jr soundcountdown

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
  ld a,$37    ; we will only be writing 37
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

load_bg:
  ;; ; reset the screen position
  ld a,$C9
  ld [$ff43],a ; scrollx will always be this
  ld a,$60
  ld [$ff42],a

  ; load the background tiles into the Tile Data Table
  ld hl,attgameboy_tile_data  ; source address
  ld de,$8000  ; destination address
  ld bc,attgameboy_tile_data_size     ; number of bytes to copy
  call memcpy

  ; load background into Background Tile Map
  ld de,$9800
  ld bc,$400
  call zeromem

  ld hl,attgameboy_map_data
  ld de,$9800
  ld bc,$6
  call memcpy

  ld hl,attgameboy_map_data
  ld de,$9820
  ld bc,$6
  add hl,bc
  call memcpy

  ld hl,attgameboy_map_data
  ld de,$9840
  ld bc,$6
  add hl,bc
  add hl,bc
  call memcpy

  ld hl,attgameboy_map_data
  ld de,$9860
  ld bc,$6
  add hl,bc
  add hl,bc
  add hl,bc
  call memcpy

  ld hl,attgameboy_map_data
  ld de,$9880
  ld bc,$6
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  call memcpy

  ld hl,attgameboy_map_data
  ld de,$98A0
  ld bc,$6
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  call memcpy

  ld hl,attgameboy_map_data
  ld de,$98C0
  ld bc,$6
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  call memcpy

  ld hl,attgameboy_map_data
  ld de,$98E0
  ld bc,$6
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  call memcpy

  ld hl,attgameboy_map_data
  ld de,$9900
  ld bc,$6
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  add hl,bc
  call memcpy

  ret

init_audio:
  ld a, $0
  ld [$ff26], a

  ld a, $80
  ld [$ff26], a
  ld [$ff11], a
  ld a, $f3
  ld [$ff12], a
  ld [$ff25], a
  ld a, $77
  ld [$ff24], a

start_timer:
  ; The timer will be incremented 4096 times each second, and each time
  ; it overflows, it will be reset to 0. This means that the timer will
  ; overflow every (1/4096) * 256 = 0.0625s.
  ld a,0         ; the value of rTIMA after it overflows
  ld [$ff06],a
  ld a,%00000100 ; enable the timer
                 ; increment rTIMA at 4096Hz
  ld [$ff07],a

  ret
