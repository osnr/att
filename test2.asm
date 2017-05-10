
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

SECTION "RAM",BSS[$c000]

  ; The buttons that are joypad pressed on the joypad. The fields are
  ; as follows:
  ;   bit 7: down
  ;   bit 6: up
  ;   bit 5: left
  ;   bit 4: right
  ;   bit 3: start
  ;   bit 2: select
  ;   bit 1: B
  ;   bit 0: A
  ; When a bit is set, the corresponding button is pressed. This
  ; structure is updated by read_joypad.
PAD   : DB
OLDPAD: DB

MOVED : DB ; whether or not the player has moved
ANIFRM: DB ; the current frame of animation
MUSCNT: DB ; the current "beat" in the tempo

WNDWON: DB ; whether or not the window is visible
BGSCRL: DB ; amount to scroll the background by

VBFLAG: DB ; whether or not we are in V-Blank

  ; Instead of directly manipulating values in the OAM during V-Blank,
  ; we store a copy of the OAM. Then, we can alter this copy at any
  ; time, not just during V-Blank, and when the OAM is indeed
  ; available, we initiate a DMA transfer from the copy to the OAM.
OAMBUF EQU $df00  ; allocate the last page in RAM for the copy
PLAYER EQU OAMBUF ; the player starts at the first sprite

hram_sprite_dma EQU  $ff80

  ; = INTERRUPT HANDLERS ==============================================

  ; These are simple interrupt handlers that simply call the actual
  ; procedures responsible for taking any action. The procedures will
  ; call "reti".

SECTION "vblank",HOME[$40]
  nop
  reti

SECTION "timer" ,HOME[$50]
  nop
  reti

SECTION "start",HOME[$100]
  nop
  jp    start
  
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
vblank:
timer:
start2:
  ld [hl-], a
  bit 7, h
  jr nz, start2

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

  

  ld h, a
  ld a, $64
  ld d, a
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
  inc h
  ld a, h
  cp $62
  jr z, playsound
  ld e, $c1
  cp $64
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

  ld d, $20
  jr soundcountdown

  


