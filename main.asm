BasicUpstart2(start)

// Entry point
* = $4000
start:
    // Make screen black and text white
    lda #$00
    sta $d020
    sta $d021
    lda #$01
    sta $0286
    // Clear the screen and jump to draw routine
    jsr $e544
    jsr draw_text
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

.namespace vic {
    .label something = $dc00
}


