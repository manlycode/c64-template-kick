.import source "../../../vendor/64spec/lib/64spec.asm"
.import source "../../../src/map.asm"
.import source "../../../src/util.asm"

sfspec: :init_spec()
    :describe("renderColLeft")
        :it("renders the leftmost column to the screen")
            jsr setup

            setPtr screen:zp.tmpPtr1
            jsr viewPort.renderColLeft

            .print "testMap="+toHexString(testMap)
            .watch zp.tmpPtr1+1
            .watch zp.tmpPtr1
            
            .watch zp.tmpPtr2+1
            .watch zp.tmpPtr2
            
            
            .watch screen+40
            :assert_equal screen:#$03
            :assert_equal screen+40:#$04

    :finish_spec()

setup:
    @viewPort_init(testMap,screen,80,25,3,0)
    rts
    
.pc = * "Data"
screen:
    .fill 1000, $0
    
*=$8000
testMap:
    .for (var row=0; row<28; row++) {
        .for (var col=0; col<40; col++) {
            .byte row+col
        }
    }
    