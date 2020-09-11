#importonce

.pseudocommand setBits target:bits {
    .if (bits.getType()==AT_IMMEDIATE) {
        lda target
        ora #bits.getValue()
        sta target
    } else {
        lda target
        ora bits.getValue()
        sta target
    }
}

.macro incPtr(PtrAddr) {
    incWord(PtrAddr)
}

.macro decPtr(Ptr) {
    decWord(Ptr)
}

.macro incWord(Word) {
    clv
    inc Word
    bne !+
    inc Word+1
!:
}

.macro decWord(Word) {
    clc
    dec Word
    bpl !+
    dec Word+1
!:
}

.macro addWord(Word, amount) {
        lda Word
    clc
    clv
    adc #amount
    bcc !+
    inc Word+1
!:  sta Word
}