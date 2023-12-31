
TRAP_ADDRESS = $FF00
TRAP_INPUT = 0
TRAP_OUTPUT = 1
TRAP_CLEAR = 2
TRAP_LOG = 3

; --------------------------------
; This subroutine causes a Trap and thereby calls into Lua code. The function
; executed is read_string(). The function expects that the buffer to store the
; entered string is given in STR_BASE/STR_BASE+1. The buffer size is expected in
; the x register. Upon return the x register is seet to the number if bytes used
; in the input buffer.
; --------------------------------
callGetString    
    lda #TRAP_INPUT                                             ; load trap code    
    sta TRAP_ADDRESS                                            ; cause trap
    rts

; --------------------------------
; This subroutine causes a Trap and thereby calls into Lua code. The function
; executed is clear_screen().
; --------------------------------
clearScreen    
    lda #TRAP_CLEAR                                             ; load trap code    
    sta TRAP_ADDRESS                                            ; cause trap
    rts

; --------------------------------
; This subroutine causes a Trap and thereby calls into Lua code. The function
; executed is write_string(). The function expects that the buffer containing
; the string to print is given in STR_BASE/STR_BASE+1. The string size is expected
; in the x register.
; --------------------------------
callPrintString    
    lda #TRAP_OUTPUT                                            ; load trap code    
    sta TRAP_ADDRESS                                            ; cause trap
    rts

; --------------------------------
; This subroutine causes a Trap and thereby calls into Lua code. The function
; executed is log_string(). The function expects that the buffer containing
; the string to log is given in STR_BASE/STR_BASE+1. The string size is expected
; in the x register.
; --------------------------------
callLogString    
    lda #TRAP_LOG                                               ; load trap code    
    sta TRAP_ADDRESS                                            ; cause trap
    rts