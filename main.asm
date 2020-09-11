.segmentdef ZeroPage [start=$0002]

.segmentdef Char [start=$3000]
.segmentdef Map [start=$6000]

BasicUpstart2(start)

* = $3000
.segment Char "Characters"
.import source "assets/commando-charset.s"    
* = $6000
.segment Map "Map"
.import source "assets/commando-map.s"

.segment Default "Code"

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

    vic_clearScreen($0400)


    EnableTimers()
    addRasterInterrupt irqTop:#0
    cli        
    jmp *

renderMap1:
        copyMap(map, MAP_WIDTH, MAP_HEIGHT, 1, 1, charset, CHARSET_COUNT, $0400)
        rts
renderBuffer1:
        copyBuffer(map, MAP_WIDTH, MAP_HEIGHT, 1, 1, charset, CHARSET_COUNT, $2000)
        rts
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
        jsr draw_text
        // jsr checkJoystick
        // End Code ----------
        lda #3
        sta vic.cborder
        addRasterInterrupt irqMiddle:#150

        endISR
        rts

irqMiddle:
       // Begin Code ----------
        jsr draw_text
        // jsr checkJoystick
        // End Code ----------
        lda #5
        sta vic.cborder
        addRasterInterrupt irqBottom:#190

        endISR
        rts
irqBottom:
       // Begin Code ----------
        jsr draw_text
        // jsr checkJoystick
        // End Code ----------
        lda #7
        sta vic.cborder
        addRasterInterrupt irqTop:#0

        endISRFinal
        rts





.import source "assets/commando-colors.s"
