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

    vic_SelectBank(0)
    vic_SelectScreenMemory(1)   // $0400
    vic_SelectCharMemory(14)    // $3000

    // Set colors for map
    lda #9
    sta vic.cbg0
    lda #0
    sta vic.cbg1
    lda #15
    sta vic.cbg2


    copyMap(map,MAP_WIDTH,MAP_HEIGHT,1,1,charset,2048,$0400)
    vic_CopyChars(charset.data,$3000,2048)
    vic_CopyColors(colors)

    EnableTimers()

    addRasterInterrupt irqTop:#0
    cli
    jmp *

irqTop:        
        // Begin Code ----------
        vic_ClearModes()
        vic_StandardCharacterModeOn()
        vic_MultiColorModeOn()
        // End Code -----------
        endISRFinal
        rts

.import source "assets/commando-charset.s"
.import source "assets/commando-colors.s"
.import source "assets/commando-map.s"