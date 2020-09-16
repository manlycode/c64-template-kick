.import source "../vendor/64spec/lib/64spec.asm"
.import source "../src/map.asm"
.import source "../src/util.asm"

sfspec: :init_spec()
    :describe("initViewport")
        :it("sets the mapPtr")
            jsr setup

            :assert_equal viewPort.mapPtr:#$00
            :assert_equal viewPort.mapPtr+1:#$04

        :it("sets the dimensions")
            jsr setup
            :assert_equal viewPort.dim.width:#80
            :assert_equal viewPort.dim.height:#25

        :it("sets the position")
            jsr setup
            :assert_equal viewPort.pos.x:#35
            :assert_equal viewPort.pos.y:#0
            :assert_equal viewPort.pos.maxX:#40
            :assert_equal viewPort.pos.maxY:#0

            jsr setupPastMaximums
            :assert_equal viewPort.pos.x:#40
            :assert_equal viewPort.pos.y:#25
            :assert_equal viewPort.pos.maxX:#40
            :assert_equal viewPort.pos.maxY:#25


        :it("sets up the left column")
            jsr setup
            .watch viewPort.left.msb
            .watch viewPort.left.lsb
            :assert_equal viewPort.left.msb:#$04
            :assert_equal viewPort.left.lsb:#$23

            :assert_equal viewPort.left.msb+1:#$04
            :assert_equal viewPort.left.lsb+1:#$73

            :assert_equal viewPort.left.msb+24:#$0B
            :assert_equal viewPort.left.lsb+24:#$A3

            jsr setupWYPos
            :assert_equal viewPort.left.msb:#$04
            :assert_equal viewPort.left.lsb:#$73

            :assert_equal viewPort.left.msb+1:#$04
            :assert_equal viewPort.left.lsb+1:#$c3

            :assert_equal viewPort.left.msb+24:#$0B
            :assert_equal viewPort.left.lsb+24:#$f3

        :it("sets up the right column")
            jsr setup
            :assert_equal viewPort.right.msb:#$04
            :assert_equal viewPort.right.lsb:#$4A

            :assert_equal viewPort.right.msb+1:#$04
            :assert_equal viewPort.right.lsb+1:#$9A

            :assert_equal viewPort.right.msb+24:#$0B
            :assert_equal viewPort.right.lsb+24:#$CA

            jsr setupWYPos
            :assert_equal viewPort.right.msb:#$04
            :assert_equal viewPort.right.lsb:#$9A

            :assert_equal viewPort.right.msb+1:#$04
            :assert_equal viewPort.right.lsb+1:#$EA

            :assert_equal viewPort.right.msb+24:#$0C
            :assert_equal viewPort.right.lsb+24:#$1A

    :finish_spec()

setup:
    viewPort_init($0400,80,25,$23,$0)
    rts

setupWYPos:
    viewPort_init($0400,80,26,$23,$1)
    rts

setupPastMaximums:
    viewPort_init($0400,80,50,80,50)
    rts

.pc = * "Data"
// Data labels go here
// vpDef:
//     @ViewPortDef($0400,80,25,35,2)
// vpDefRollover:
//     @ViewPortDef($04ff,80,25,35,2)
// vpDefAmostRollover:
//     @ViewPortDef($04b6,80,25,35,2)