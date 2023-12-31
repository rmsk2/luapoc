# Info

This repo contains a program which demonstrates that the [`6502profiler`](https://github.com/rmsk2/6502profiler) Lua bridge 
can be used for somewhat useful software.

Use `make run` to start a simple program which implements the "hangman" word guessing game. You will need the ACME macro assembler
to build and run this software. I have only tested this software on Linux (Ubuntu 22.04). The target `make test` executes some simple 
unit tests. 

The only part of the whole project which is dependent on the specifics of `6502profiler` is the file `hangmanio.asm`. If you replace 
its contens with routines that use the IO facilities of a real machine then this software should work on that machine. You may also 
have to adapt the charset which is used to draw the stick figure.