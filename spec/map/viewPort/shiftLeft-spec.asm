.import source "../../../vendor/64spec/lib/64spec.asm"
.import source "../../../src/map.asm"
.import source "../../../src/util.asm"

sfspec: :init_spec()
    :describe("shiftLeft")
        :it("shifts the x position")
            jsr setup
            jsr viewPort.shiftLeft
            :assert_equal viewPort.pos.x:#$00

        :it("updates the left col")
            jsr setup
            jsr viewPort.shiftLeft
            :assert_equal viewPort.left.msb:#$04
            :assert_equal viewPort.left.lsb:#$00
            :assert_equal viewPort.left.msb+1:#$04
            :assert_equal viewPort.left.lsb+1:#$50
            :assert_equal viewPort.left.msb+24:#$0B
            :assert_equal viewPort.left.lsb+24:#$80

            jsr setupOverflow
            jsr viewPort.shiftLeft
            :assert_equal viewPort.left.msb:#$03
            :assert_equal viewPort.left.lsb:#$ff
            :assert_equal viewPort.left.msb+1:#$04
            :assert_equal viewPort.left.lsb+1:#$4f
            :assert_equal viewPort.left.msb+24:#$0b
            :assert_equal viewPort.left.lsb+24:#$7f

        :it("updates the right col")
            jsr setup
            jsr viewPort.shiftLeft
            :assert_equal viewPort.right.msb:#$04
            :assert_equal viewPort.right.lsb:#$27
            :assert_equal viewPort.right.msb+1:#$04
            :assert_equal viewPort.right.lsb+1:#$77
            :assert_equal viewPort.right.msb+24:#$0B
            :assert_equal viewPort.right.lsb+24:#$A7

            jsr setupOverflow
            jsr viewPort.shiftLeft
            :assert_equal viewPort.right.msb:#$04
            :assert_equal viewPort.right.lsb:#$26
            :assert_equal viewPort.right.msb+1:#$04
            :assert_equal viewPort.right.lsb+1:#$76
            :assert_equal viewPort.right.msb+24:#$0b
            :assert_equal viewPort.right.lsb+24:#$a6

    :describe("when the viewport is all the way to the left")
        :it("won't shift the position, or update the columns")
            jsr setupMinBounds
            jsr viewPort.shiftLeft
            :assert_equal viewPort.pos.x:#$00

            :assert_equal viewPort.left.msb:#$04
            :assert_equal viewPort.left.lsb:#$00
            :assert_equal viewPort.right.msb:#$04
            :assert_equal viewPort.right.lsb:#$27
    
    :finish_spec()

setup:
    viewPort_init($0400,80,26,$01,$0)
    rts
setupOverflow:
    viewPort_init($03ff,80,26,$1,$0)
    rts
setupMinBounds:
    viewPort_init($0400,80,26,$0,$0)
    rts