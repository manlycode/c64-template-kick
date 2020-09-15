.import source "../vendor/64spec/lib/64spec.asm"
.import source "../src/map.asm"
.import source "../src/util.asm"

sfspec: :init_spec()
    :describe("initViewport")
        :it("sets the mapPtr")
            jsr initSetup

            :assert_equal viewPort.mapPtr:#$00
            :assert_equal viewPort.mapPtr+1:#$04

        :it("sets the dimensions")
            jsr initSetup
            :assert_equal viewPort.dim.width:#80
            :assert_equal viewPort.dim.height:#25

        :it("sets the position")
            jsr initSetup
            :assert_equal viewPort.pos.x:#0
            :assert_equal viewPort.pos.y:#0

    :describe("shiftRight")
        :it("sets the x position")
            jsr viewPort.shiftRight
            :assert_equal viewPort.pos.x:#1
            :assert_equal viewPort.pos.y:#0

    :describe("updateTopBounds")
        :describe("when shifting doesn't cross $ff")
            :it("won't change the msb")
                jsr initSetup
                jsr viewPort.updateBounds

                :assert_equal16 #$0400:viewPort.bounds.top.left
                :assert_equal16 #$0400+$27:viewPort.bounds.top.right
                :assert_equal16 #$0400+$27+(24*80):viewPort.bounds.bottom.right //0ba7
                :assert_equal16 #$0b80:viewPort.bounds.bottom.left //0b80
                
        // :describe("when shifting crosses $ff")
        //     :it("bumps the msb")
        //         jsr initSetupRollover
        //         jsr viewPort.updateBounds

        //         :assert_equal16 #$04ff+35:viewPort.bounds.top.left
        //         :assert_equal16 #$04ff+35+39:viewPort.bounds.top.right

        // :describe("when it barely rolls over")
        //     :it("bumps the msb")
        //         jsr initSetupAlmostRollover
        //         jsr viewPort.updateBounds

        //         :assert_equal16 #$04d9:viewPort.bounds.top.left
        //         :assert_equal16 #$0500:viewPort.bounds.top.right
    :finish_spec()

initSetup:
    setPtr vpDef:zp.tmpPtr1
    jsr viewPort.init
    rts

initSetupRollover:
    setPtr vpDefRollover:zp.tmpPtr1
    jsr viewPort.init
    rts
initSetupAlmostRollover:
    setPtr vpDefAmostRollover:zp.tmpPtr1
    jsr viewPort.init
    rts


.pc = * "Data"
// Data labels go here
vpDef:
    @ViewPortDef($0400,80,25,0,0)
vpDefRollover:
    @ViewPortDef($04ff,80,25,35,2)
vpDefAmostRollover:
    @ViewPortDef($04b6,80,25,35,2)