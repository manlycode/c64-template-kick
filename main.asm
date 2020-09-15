.segmentdef Data [startAfter="Default", align=$100]


BasicUpstart2(start)

// Entry point
* = $4000
.import source "src/irq_macros.asm"
.import source "src/vchar.asm"
.import source "src/map.asm"
.import source "src/cia.asm"
.import source "src/vic.asm"

start:
    // Make screen black and text white
    sei
    DisableTimers()

    //jsr initJoystick
    vic_SelectBank(0)
    vic_SelectScreenMemory(1)   // $0400
    vic_SelectCharMemory(14)    // $3000
    vic_SetMultiColorMode()
    vic_set38ColumnMode()

    // vic_clearScreen($0400)
    vic_CopyChars(charset.data,$3000,2048)
    vic_CopyColors(colors)
    copyMap(map,MAP_WIDTH,MAP_HEIGHT,1,1,charset,2048,$0400)

    EnableTimers()

    addRasterInterrupt irqTop:#0
    cli
    jmp *

msg:
    .text "              hello world!              "

draw_text:
    ldx #$00
draw_loop:
    lda msg,x
    sta $05e0,x
    inx
    cpx #$28
    bne draw_loop
    rts

irqTop:        
        // Begin Code ----------
        // End Code -----------
        addRasterInterrupt irqMiddle:#150
        copyMap(map,MAP_WIDTH,MAP_HEIGHT,1,1,charset,2048,$0400)

        endISR
        rts

irqMiddle:
    // Begin Code ----------
    // End Code ------------
    addRasterInterrupt irqBottom:#190
    endISR
    rts
irqBottom:
    // Begin Code ----------
    // End Code ------------
    addRasterInterrupt irqTop:#0
    endISRFinal
    rts

.import source "assets/commando-charset.s"
.import source "assets/commando-colors.s"
.import source "assets/commando-map.s"