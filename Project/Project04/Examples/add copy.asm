// Program: Add.asm
// Computes: RAM[2] = RAM[0] + RAM[1] + 17
// Usage: put values in RAM[0] and in RAM[1] 
    // D = RAM[0]
    @R0 
    D=M 
    @R1
    D=D+M 
         

    @17 
    D=D+A 

    @R2 
    M=D 

    (END) 
        @END 
        0;JMP

