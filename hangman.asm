MAX_WORD_LEN = 100
MAX_WRONG_GUESSES = 8

WORD_LEN
!byte 0
WORD_TO_GUESS
!skip MAX_WORD_LEN
GUESSED_WORD
!skip MAX_WORD_LEN

NUMBER_OF_WRONG_GUESSES
!byte 0

GUESSED_CHAR
!byte 0

NUM_CHARS_CORRECT
!byte 0

; --------------------------------
; This subroutine fills the guessed word with
; WORD_LEN underscores
; --------------------------------
initGuessedWord
    ldy #0
    lda #95
.initNext
    sta GUESSED_WORD, y
    iny
    cpy WORD_LEN
    bne .initNext
    rts

; --------------------------------
; This subroutine checks whether the last entered char
; appears in the WORD_TO_GUESS. It modifies the GUESSED_WORD
; at the correct positions. Upon return the x register  contains
; the number of correct positions.
; --------------------------------
evalGuess
    ldy #0
    ldx #0
    lda GUESSED_CHAR
.checkNext
    cmp WORD_TO_GUESS,y
    bne .notFound
    inx
    sta GUESSED_WORD, y
.notFound
    iny
    cpy WORD_LEN
    bne .checkNext
    rts

; --------------------------------
; This subroutine checks whether the game was won by the player. This
; is done by comapring WORD_TO_GUESS and GUESSED_WORD. Upon return the
; y register contians the postion where the first difference was found.
; I.e. if y == WORD_LEN everything has been guessed correctly.
; --------------------------------
isGameWon
    ldy #0
.checkNextWon
    lda GUESSED_WORD, y
    cmp WORD_TO_GUESS, y
    bne .notWon
    iny
    cpy WORD_LEN
    bne .checkNextWon
.notWon
    rts

