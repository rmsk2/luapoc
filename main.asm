!to "hangman",cbm
!cpu 65C02

* = $0300
    jmp main


!source "iomacros.asm"

!zone io
!source "hangmanio.asm"

!zone tools
!source "hangman.asm"

!zone main

PROMPT
!tx "Enter word to guess: "

PROMPT_GUESS
!tx "Your next guess: "

YOU_WIN
!tx "You win!!"

YOU_LOOSE
!tx "You loose!!"

CORRECT_WORD_TXT
!tx "The word was: "

CURRENT_RESULT
!tx "Your guesses: "

main
    ; initialize state
    stz NUMBER_OF_WRONG_GUESSES
    stz WORD_LEN
    jsr printCrLf
    +printString PROMPT, 21
    +getString WORD_TO_GUESS, MAX_WORD_LEN                      ; Ask for word to guess
    stx WORD_LEN    
    jsr initGuessedWord                                         ; initialize state of guessed word
    +logStringAddr WORD_TO_GUESS, WORD_LEN
    jsr clearScreen    
mainLoop
    jsr printCrLf
    jsr drawHangman                                             ; draw hangman
    jsr printCrLf    
    +printString CURRENT_RESULT, 14
    +printStringAddr GUESSED_WORD, WORD_LEN                     ; show the current state of the guessed word
    +printString CRLF, 2    
    +printString PROMPT_GUESS, 17
    +getString GUESSED_CHAR, 1                                  ; get the next guess    
    jsr evalGuess                                               ; mark correct positions    
    stx NUM_CHARS_CORRECT                                       ; store how often the guessed char appears in the word to guess
    jsr isGameWon
    cpy WORD_LEN                                                ; check whether all chars have been guessed correctly     
    beq .gameWon                                                ; no difference found => game was won by player
    ; We are not done yet    
    ldx NUM_CHARS_CORRECT                                       ; load number of correct guesses    
    bne mainLoop                                                ; if nonzero, the user guessed correctly => let user guess again    
    inc NUMBER_OF_WRONG_GUESSES                                 ; guess was incorrect        
    lda NUMBER_OF_WRONG_GUESSES
    cmp #MAX_WRONG_GUESSES                                      ; check number of guesses    
    bcs .gameLost                                               ; too many wrong guesses?    
    bra mainLoop                                                ; no => next guess
.gameLost
    ; maximum number of wrong guesses was reached => user has lost
    jsr printCrLf
    jsr drawHangman
    jsr printCrLf
    +printString YOU_LOOSE, 11
    jsr printCrLf    
    +printString CORRECT_WORD_TXT, 14
    +printStringAddr WORD_TO_GUESS, WORD_LEN                    ; tell user the correct word
    jsr printCrLf
    bra .gameEnd
.gameWon
    ; User has won
    +printString CORRECT_WORD_TXT, 14
    +printStringAddr GUESSED_WORD, WORD_LEN
    jsr printCrLf
    +printString YOU_WIN, 9
.gameEnd
    jsr printCrLf
    brk


CRLF
!byte $0a
!byte $0a

; --------------------------------
; This subroutine sets the cursor to the next line
; --------------------------------
printCrLf
    +printString CRLF, 1
    rts

; --------------------------------
; This table stores the addresses of the routines that know how to draw
; a stick figure after 1, 2, 3, 4, ...., 8 wrong guesses.
; --------------------------------
DRAW_TABLE
!byte   <draw1, >draw1
!byte   <draw2, >draw2
!byte   <draw3, >draw3
!byte   <draw4, >draw4
!byte   <draw5, >draw5
!byte   <draw6, >draw6
!byte   <draw7, >draw7
!byte   <draw8, >draw8

; --------------------------------
; This subroutine draws the hangman stick figure. Depending
; on the number of wrong guesses the figure is drawn in a fashion
; which is more and more complete
; --------------------------------
drawHangman
    lda NUMBER_OF_WRONG_GUESSES
    cmp #0
    beq .nothingToDraw
    ; calculate index in jump table    
    dec                                                         ; make index start at 0    
    asl                                                         ; multiply index by two
    tax                                                         ; transfer index to x register
    jmp (DRAW_TABLE,x)                                          ; draw the stick figure
.nothingToDraw
    rts


VERT
!tx "|"
!byte $0a

HORIZONTAL
!tx "------------"
!byte $0a

ROPE
!tx "|          |"
!byte $0a

HEAD
!tx "|          O"
!byte $0a

RUMP
!tx "|          |"
!byte $0a

ARMS
!tx "|         /|\\"
!byte $0a

FEET
!tx "|         / \\"
!byte $0a


; --------------------------------
; This subroutine draws the stick figure after one wrong guess.
; --------------------------------
draw1
    ldy #7
    jmp drawVert

; --------------------------------
; This subroutine draws the stick figure after two wrong guesses.
; --------------------------------
draw2
    +printString HORIZONTAL, 13
    jsr draw1
    rts

; --------------------------------
; This subroutine draws the stick figure after three wrong guesses.
; --------------------------------
draw3
    +printString HORIZONTAL, 13
    +printString ROPE, 13
    ldy #6
    jmp drawVert

; --------------------------------
; This subroutine draws the stick figure after four wrong guesses.
; --------------------------------
draw4
    +printString HORIZONTAL, 13
    +printString ROPE, 13
    +printString HEAD, 13
    ldy #5
    jmp drawVert

; --------------------------------
; This subroutine draws the stick figure after five wrong guesses.
; --------------------------------
draw5
    +printString HORIZONTAL, 13
    +printString ROPE, 13
    +printString HEAD, 13
    +printString RUMP, 13
    ldy #4
    jmp drawVert

; --------------------------------
; This subroutine draws the stick figure after six wrong guesses.
; --------------------------------
draw6
    +printString HORIZONTAL, 13
    +printString ROPE, 13
    +printString HEAD, 13
    +printString ARMS, 14
    ldy #4
    jmp drawVert    

; --------------------------------
; This subroutine draws the stick figure after seven wrong guesses.
; --------------------------------
draw7
    +printString HORIZONTAL, 13
    +printString ROPE, 13
    +printString HEAD, 13
    +printString ARMS, 14
    +printString RUMP, 13
    ldy #3
    jmp drawVert

; --------------------------------
; This subroutine draws the stick figure after eight wrong guesses.
; --------------------------------
draw8
    +printString HORIZONTAL, 13
    +printString ROPE, 13
    +printString HEAD, 13
    +printString ARMS, 14
    +printString RUMP, 13
    +printString FEET, 14
    ldy #2
    jmp drawVert

; --------------------------------
; This subroutine draws a number of vertical bars on the
; left side of the screen. The number of vertical bars has to be
; specified through the y register.
; --------------------------------
drawVert
    +printString VERT,2
    dey
    bpl drawVert
    rts