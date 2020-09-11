#importonce
//------------------------------------------------------------------
// Constants
//------------------------------------------------------------------
.label SCREEN_W = 40
.label SCREEN_H = 25
//------------------------------------------------------------------
// Variables
//------------------------------------------------------------------
mapIdx: .byte $00
screenIdx: .byte $00
vpX: .byte $00
vpY: .byte $00
vpXbuffer: .byte $00
vpYbuffer: .byte $00
//------------------------------------------------------------------
// Macros
//------------------------------------------------------------------
.macro copyChars(source,target,size) {
        ldx #0
!:       

        .for (var i=0; i<8; i++) {
          lda source,x
          sta target,x
        }

        inx
        bne !-
}

.macro copyMap(Map, mapW, mapH, tileW, tileH, Charset, charCOUNT, Screen) {
        lda vpX
        sta mapIdx
        lda #0
        sta screenIdx

!:      ldy screenIdx
        ldx mapIdx

        .for (var i=0; i<(25 / tileH); i++) {
          lda Map+(mapW*tileH*i),x
          sta Screen+((SCREEN_W*tileH)*i),y     
        }

        inc mapIdx
        clc
        inc screenIdx
        lda screenIdx
        cmp #40
        beq !+
        // Not a screen bounds, normal map index inc
        jmp !-
        
        clc
        lda mapIdx
        adc #(mod(SCREEN_W,mapW))
        sta mapIdx
        jmp !-
!:
}

.macro copyBuffer(Map, mapW, mapH, tileW, tileH, Charset, charCOUNT, Screen) {
        lda vpXbuffer
        sta mapIdx
        lda #0
        sta screenIdx

!:      ldy screenIdx
        ldx mapIdx

        .for (var i=0; i<(25 / tileH); i++) {
          lda Map+(mapW*tileH*i),x
          sta Screen+((SCREEN_W*tileH)*i),y
        }

        inc mapIdx
        clc
        inc screenIdx
        lda screenIdx
        cmp #40
        beq !+
        // Not a screen bounds, normal map index inc
        jmp !-
        
        clc
        lda mapIdx
        adc #(mod(SCREEN_W,mapW))
        sta mapIdx
        jmp !-
!:
}

.macro copyColumn(Map, mapW, mapH, tileW, tileH, Charset, charCOUNT, Screen, ScreenCol) {
        lda vpX
        adc #ScreenCol
        tax

        lda #ScreenCol
        tay

        .for (var i=0; i<(25 / tileH); i++) {
          lda Map+(mapW*tileH*i),x
          sta Screen+((SCREEN_W*tileH)*i),y   
        }
}
//------------------------------------------------------------------
// Subroutines
//------------------------------------------------------------------
