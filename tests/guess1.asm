!cpu 65C02

* = $0800

jmp main

VEC_WORD_LEN
!byte <WORD_LEN, >WORD_LEN
VEC_GUESSED_WORD
!byte <GUESSED_WORD, >GUESSED_WORD
VEC_GUESSED_CHAR
!byte <GUESSED_CHAR, >GUESSED_CHAR

!source "hangmanio.asm"
!source "hangman.asm"

main
    jsr initGuessedWord
    jsr evalGuess
    brk