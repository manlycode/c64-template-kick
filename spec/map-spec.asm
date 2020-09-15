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
            :assert_equal viewPort.pos.x:#40
            :assert_equal viewPort.pos.y:#2
    :finish_spec()

initSetup:
    setPtr vpDef:zp.tmpPtr1
    jsr viewPort.init
    rts

.pc = * "Data"
// Data labels go here
vpDef:
    @ViewPortDef($0400,80,25,40,2)