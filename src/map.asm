#importonce
.import source "util.asm"
.import source "zero-page.asm"
.import source "vic.asm"

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
.namespace map {
    copyRight:
        lda #0
        sta zp.tmp1

        .for (var row = 0; row <= 25; row++) {
        
            .for (var i=39; i >= 0; i--) {
                lda zp.tmp1
                sta zp.tmp2

                lda $0400+(40*row)+i
                sta zp.tmp1
                lda zp.tmp2
                sta $0400+(40*row)+i
            }
        }

        rts
}


.macro viewPort_init(mapPtr, width, height, _x, _y) {
    .var _maxX = (width - SCREEN_W)
    .var _maxY = (height - SCREEN_H)
    .var x = min(_x, _maxX)
    .var y = min(_y, _maxY)

    setPtr mapPtr:viewPort.mapPtr

    lda #width
    sta viewPort.dim.width

    lda #height
    sta viewPort.dim.height

    lda #x
    sta viewPort.pos.x

    lda #y
    sta viewPort.pos.y

    lda #_maxX
    sta viewPort.pos.maxX

    lda #_maxY
    sta viewPort.pos.maxY

    .var currentPtrLeft = mapPtr+(width*y)+x
    .var currentPtrRight = mapPtr+(width*y)+x+39

    .for (var i=0; i<25; i++) {
        lda #>currentPtrLeft
        sta viewPort.left.msb+i
        lda #<currentPtrLeft
        sta viewPort.left.lsb+i

        lda #>currentPtrRight
        sta viewPort.right.msb+i
        lda #<currentPtrRight
        sta viewPort.right.lsb+i

        .eval currentPtrLeft += width
        .eval currentPtrRight += width
    }
    

}

.namespace viewPort {
    shiftRight:
        inc pos.x
        // Update Bounds
        rts

    mapPtr: .word $0000
    .namespace dim {
        width:  .byte $00        // Width in tiles
        height: .byte $00       // Height in tiles    
    }
    .namespace pos {
        x: .byte $00
        y: .byte $00
        maxX: .byte $00    
        maxY: .byte $00
    }

    .namespace left {
        msb: .fill 25,0
        lsb: .fill 25,0
    }

    .namespace right {
        msb: .fill 25,0
        lsb: .fill 25,0
    }
}
