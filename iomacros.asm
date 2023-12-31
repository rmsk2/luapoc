STR_BASE = $90

; --------------------------------
; This macro sets up STR_BASE and STR_BASE+1 with the buffer address given in .addr
; and sets the x register to .maxLen before calling callGetString.
; -------------------------------- 
!macro getString .addr, .maxLen {
    lda #<.addr
    sta STR_BASE
    lda #>.addr
    sta STR_BASE+1
    ldx #.maxLen
    jsr callGetString
}

; --------------------------------
; This macro sets up STR_BASE and STR_BASE+1 with the buffer address given in .addr
; and sets the x register to .txtLen  before calling callPrintString.
; -------------------------------- 
!macro printString .addr, .txtLen {
    lda #<.addr
    sta STR_BASE
    lda #>.addr
    sta STR_BASE+1
    ldx #.txtLen
    jsr callPrintString
}

; --------------------------------
; This macro sets up STR_BASE and STR_BASE+1 with the buffer address given in .addr
; and sets the x register to the value stored at .addrLen before calling callPrintString.
; -------------------------------- 
!macro printStringAddr .addr, .addrLen {
    lda #<.addr
    sta STR_BASE
    lda #>.addr
    sta STR_BASE+1
    ldx .addrLen
    jsr callPrintString
}

; --------------------------------
; This macro sets up STR_BASE and STR_BASE+1 with the buffer address given in .addr
; and sets the x register to the value stored at .addrLen before calling callPrintString.
; -------------------------------- 
!macro logStringAddr .addr, .addrLen {
    lda #<.addr
    sta STR_BASE
    lda #>.addr
    sta STR_BASE+1
    ldx .addrLen
    jsr callLogString
}

; --------------------------------
; This macro sets up STR_BASE and STR_BASE+1 with the buffer address given in .addr.
; The x register is not changed. It therefore has to be set by the caller.
; -------------------------------- 
!macro printStringImpl .addr {
    lda #<.addr
    sta STR_BASE
    lda #>.addr
    sta STR_BASE+1
    jsr callPrintString
}