// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// This program only needs to handle arguments that satisfy
// R0 >= 0, R1 >= 0, and R0*R1 < 32768.


// Version 2.0: accumulate in R2, 
//            - use a proper variable as the counter
//            - branch on which of R0/R1 is smaller.


// Initialzing proper vairables as counter
// - counter (the smaller of R0 and R1) is stored in RAM[16]
// - addend (the larger of R0 and R1) is stored in RAM[17]
@counter
M=0 
@addend 
M=0
@R2
M=0 // Initialize the result in RAM[2] to 0

// Conditional check for variables 
@R0
D=M
@R1
D=D-M // Outcomes: D<0, D=0, D>0

// Jump to R0 if R0 is smaller than R1
@R0_IS_SMALLER
D;JLT

// Jump to R1 if R1 is smaller than R0
@R1_IS_SMALLER
D;JGT

(R0_IS_SMALLER)
    @R0
    D=M 
    @counter 
    M=D // store the smaller of R0 and R1 in RAM[16] as counter

    @R1
    D=M 
    @addend 
    M=D // store the larger of R0 and R1 in RAM[17] as addend

    @LOOP 
    0;JMP

(R1_IS_SMALLER)
    @R1
    D=M 
    @counter 
    M=D // store the smaller of R0 and R1 in RAM[16] as counter

    @R0
    D=M 
    @addend 
    M=D // store the larger of R0 and R1 in RAM[17] as addend

    @LOOP 
    0;JMP

// start the loop for if the multiplier is not less than 0 
(LOOP) 
    @counter
    D=M 
    @END 
    D;JLE

    @R2
    D=M
    @addend
    D=D+M
    @R2
    M=D

    // update the multiplier by decrementing it by 1
    @counter
    M=M-1

    @LOOP
    0;JMP

(END)
    @END
    0;JMP
