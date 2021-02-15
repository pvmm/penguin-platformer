Scroll:

    ; search names table buffer looking for tiles 
    ; other than 0
    ld      hl, NamesTableBuffer + 512
    xor     a                           ; same as ld a, 0
    ld      b, 0                        ; counter
.loop:
    or      (hl)
    jp      z, .next

.animate:

    inc     (hl)

.next:

    inc     hl
    djnz    .loop
    
    ; at each 8 pixel fine scrolls, do a tile scroll
    ld      a, (BgScrollRegister)
    inc     a
    cp      8
    call    z, ScrollTiles

    ld      (BgScrollRegister), a

    ; call    UpdateNamesTable_BackGround
    ;call    UpdateNamesTable

    ret

ScrollTiles:

; test only last line

    ; scroll all tiles
	; ld	    hl, (NextBgLineAddr)
	ld	    hl, TileMap_LevelTest_Start + SCREEN_HEIGHT_IN_TILES - 1    ; Origin
    ld      de, NamesTableBuffer + (SCREEN_WIDTH_IN_TILES * 23)         ; Destiny
    ld      b, SCREEN_WIDTH_IN_TILES - 1
.loop:
    ld      a, (hl)
    ld      (de), a
    push    bc
    ld      bc, SCREEN_HEIGHT_IN_TILES
    add     hl, bc
    pop     bc
    inc     de
; .loopEnternal:
;     jp .loopEnternal
    djnz    .loop    

    ;inc     de
    ld      a, 1
    ld      (de), a ; load tile in last column


    ; load next bg line
    ; ld	    hl, (NextBgLineAddr)
	; ld	    bc, 32                                                  ; Block length
    ; and     a                                                       ; Clear C flag
    ; sbc     hl, bc
    ; ld	    (NextBgLineAddr), hl
    ; ld      de, NamesTableBuffer + SCREEN_WIDTH_IN_TILES            ; Destiny
    ; ; ldir                                                        ; Copy BC number of bytes from HL to DE
    ; ; 32 unrolled ldi's (160 less cycles). Made with MSXUtilities
    ; ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi ldi 

    ; clear BgScrollRegister when exit subroutine
    xor     a                                                       ; same as ld a, 0 but faster

    ret
