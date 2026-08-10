// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// This program only needs to handle arguments that satisfy
// R0 >= 0, R1 >= 0, and R0*R1 < 32768.


// Version1.0 - uses mult variable holder in RAM[16] 
//            - There is no conditional to chose R0 or R1 as the multiplier. 
// Lesson leanring: Memory usage and cycle time is not optimal for version1.0


// Initialize sum hold
@sum
M=0 
@R2
M=0 // Initialize the result in RAM[2] to 0

// start the loop for if the multiplier is not less than 0 
(LOOP) 
    @R0
    D=M 
    @STOP 
    D;JLE

    @sum
    D=M
    @R1
    D=D+M
    @sum
    M=D

    // update the multiplier by decrementing it by 1
    @R0
    M=M-1

    @LOOP
    0;JMP

(STOP)
    @sum
    D=M
    @R2
    M=D

(END)
    @END
    0;JMP
