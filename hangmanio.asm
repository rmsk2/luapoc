
TRAP_ADDRESS = $FF00
TRAP_INPUT = 0
TRAP_OUTPUT = 1
TRAP_CLEAR = 2

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

; --------------------------------
; This subroutine causes a Trap and thereby calls into Lua code. The function
; executed is read_string(). The function expects that the buffer to store the
; entered string is given in STR_BASE/STR_BASE+1. The buffer size is expected in
; the x register. Upon return the x register is seet to the number if bytes used
; in the input buffer.
; --------------------------------
callGetString
    ; load trap code
    lda #TRAP_INPUT
    ; cause trap
    sta TRAP_ADDRESS
    rts

; --------------------------------
; This subroutine causes a Trap and thereby calls into Lua code. The function
; executed is clear_screen().
; --------------------------------
clearScreen
    ; load trap code
    lda #TRAP_CLEAR
    ; cause trap
    sta TRAP_ADDRESS
    rts

; --------------------------------
; This subroutine causes a Trap and thereby calls into Lua code. The function
; executed is write_string(). The function expects that the buffer containing
; the string to print is given in STR_BASE/STR_BASE+1. The string size is expected
; in the x register.
; --------------------------------
callPrintString
    ; load trap code
    lda #TRAP_OUTPUT
    ; cause trap
    sta TRAP_ADDRESS
    rts
