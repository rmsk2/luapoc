all: hangman

hangman: main.asm hangman.asm hangmanio.asm iomacros.asm
	acme main.asm

run: hangman
	6502profiler run -c config.json -trapaddr 0xFF00 -prg hangman -lua hangman.lua

test:
	6502profiler verifyall -c config.json -trapaddr 0xFF00 

clean:
	rm hangman
	rm tests/bin/*.bin