; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: att-gameboy.png
; Pixel Width: 48px
; Pixel Height: 72px

; WARNING: Height of input image padded 4px to 72px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

attgameboy_tile_map_size EQU $36
attgameboy_tile_map_width EQU $06
attgameboy_tile_map_height EQU $09

attgameboy_tile_data_size EQU $0360
attgameboy_tile_count EQU $36

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

attgameboy_map_data:
DB $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
DB $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F
DB $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F
DB $30,$31,$32,$33,$34,$35

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

attgameboy_tile_data:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
DB $00,$00,$00,$00,$00,$03,$00,$0F,$00,$1F,$00,$7F,$00,$FE,$00,$FC
DB $00,$0F,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$C0,$00,$00,$00,$00
DB $00,$F0,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$03,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$C0,$00,$F0,$00,$F8,$00,$FE,$00,$7F,$00,$3F
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80
DB $00,$03,$00,$07,$00,$07,$00,$0F,$00,$1F,$00,$1F,$00,$3E,$00,$3E
DB $00,$F0,$00,$E0,$00,$C0,$00,$80,$00,$01,$00,$03,$00,$03,$00,$03
DB $00,$07,$00,$07,$00,$07,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$E0
DB $00,$E0,$00,$E0,$00,$E0,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$07
DB $00,$0F,$00,$07,$00,$03,$00,$01,$00,$80,$00,$C0,$00,$C0,$00,$C0
DB $00,$C0,$00,$E0,$00,$E0,$00,$F0,$00,$F8,$00,$F8,$00,$7C,$00,$7C
DB $00,$7C,$00,$7C,$00,$7C,$00,$78,$00,$78,$00,$F8,$00,$F8,$00,$F8
DB $00,$07,$00,$07,$00,$07,$00,$07,$00,$07,$00,$07,$00,$07,$00,$07
DB $00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0
DB $00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03
DB $00,$E0,$00,$E0,$00,$E0,$00,$E0,$00,$E0,$00,$E0,$00,$E0,$00,$E0
DB $00,$3E,$00,$3E,$00,$3E,$00,$1E,$00,$1E,$00,$1F,$00,$1F,$00,$1F
DB $00,$F8,$00,$F8,$00,$F8,$00,$F8,$00,$78,$00,$78,$00,$7C,$00,$7C
DB $00,$07,$00,$0F,$00,$1F,$00,$7F,$00,$7E,$00,$7F,$00,$7F,$00,$7F
DB $00,$80,$00,$80,$00,$80,$00,$00,$00,$00,$00,$FF,$00,$FF,$00,$FF
DB $00,$01,$00,$01,$00,$01,$00,$00,$00,$00,$00,$FF,$00,$FF,$00,$FF
DB $00,$E0,$00,$F0,$00,$F8,$00,$FE,$00,$7E,$00,$FE,$00,$FE,$00,$FE
DB $00,$1F,$00,$1F,$00,$1F,$00,$1F,$00,$1E,$00,$1E,$00,$3E,$00,$3E
DB $00,$3C,$00,$3E,$00,$3E,$00,$1F,$00,$0F,$00,$0F,$00,$07,$00,$03
DB $00,$7F,$00,$7F,$00,$00,$00,$00,$00,$80,$00,$C0,$00,$E0,$00,$F0
DB $00,$FF,$00,$FF,$00,$07,$00,$07,$00,$07,$00,$00,$00,$00,$00,$00
DB $00,$FF,$00,$FF,$00,$E0,$00,$E0,$00,$E0,$00,$00,$00,$00,$00,$00
DB $00,$FE,$00,$FE,$00,$00,$00,$00,$00,$01,$00,$03,$00,$07,$00,$0F
DB $00,$3C,$00,$7C,$00,$7C,$00,$F8,$00,$F0,$00,$F0,$00,$E0,$00,$C0
DB $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$F8,$00,$FE,$00,$7F,$00,$3F,$00,$0F,$00,$07,$00,$01,$00,$00
DB $00,$00,$00,$00,$00,$80,$00,$F8,$00,$FF,$00,$FF,$00,$FF,$00,$0F
DB $00,$00,$00,$00,$00,$01,$00,$1F,$00,$FF,$00,$FF,$00,$FF,$00,$F0
DB $00,$1F,$00,$7F,$00,$FE,$00,$FC,$00,$F0,$00,$E0,$00,$80,$00,$00
DB $00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$01,$01,$03,$03,$03,$03,$07,$07,$07,$07,$07,$07
DB $00,$00,$00,$00,$E3,$E3,$E3,$E3,$F3,$F3,$F3,$F3,$F0,$F0,$78,$78
DB $00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3C,$3C,$3C,$3C
DB $00,$00,$00,$00,$C0,$C0,$C0,$C0,$C0,$C0,$C4,$C4,$3F,$3F,$3F,$3F
DB $00,$00,$00,$00,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$81,$81,$81,$81
DB $00,$00,$00,$00,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$E0,$E0,$E0,$E0
DB $0F,$0F,$0E,$0E,$1E,$1E,$1E,$1E,$1C,$1C,$3F,$3F,$3F,$3F,$3F,$3F
DB $78,$78,$38,$38,$3C,$3C,$3C,$3C,$1C,$1C,$FE,$FE,$FE,$FE,$FE,$FE
DB $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C
DB $7B,$7B,$79,$79,$79,$79,$3E,$3E,$7F,$7F,$7F,$7F,$77,$77,$73,$73
DB $C1,$C1,$C1,$C1,$C1,$C1,$39,$39,$39,$39,$B9,$B9,$F9,$F9,$F1,$F1
DB $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
DB $7C,$7C,$7C,$7C,$7C,$7C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $1F,$1F,$1F,$1F,$1F,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $3C,$3C,$3C,$3C,$3C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $79,$79,$7F,$7F,$3F,$3F,$0F,$0F,$00,$00,$00,$00,$00,$00,$00,$00
DB $FD,$FD,$FD,$FD,$DD,$DD,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $E0,$E0,$E0,$E0,$E0,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00