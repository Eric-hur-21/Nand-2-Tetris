// Program: nSum.asm
// Computes: 1+2+3+...+n, where n is stored in RAM[0] and the result is stored in RAM[1]
// Usage: Put a value >= 1 in RAM[0] 

    // i = 1. Store free slot from 16 upward 
    @i
    M=1 // Store value 1 in RAM[16] - starting value 
    @sum // Store in RAM[17] 
    M=0 

    (LOOP)
        // if i > R0, goto STOP - this captures the lowest value 1.
        // Iteration goes from negative to positive  
        @i 
        D=M // Store value i in D 
        @R0 // point to RAM[0] - the input 
        D=D-M // Same as D = i - R0
        @STOP 
        D;JGT // If D > 0, jump to STOP 

        // sum = sum + i 
        @sum // point to RAM[17] we are holding sum in RAM[17]
        D=M // Store value sum in D 
        @i // point to RAM[16] 
        D=D+M // add value of i to sum  
        @sum // point back to RAM[17]
        M=D // store the new value of sum in RAM[17]

        // i = i + 1 update i to the next value 
        @i // point to RAM[16]
        M = M+1 // increment the value stored in RAM[16] by 1
        @LOOP 
        0;JMP 

    (STOP) 
    @sum 
    D=M 
    @R1 
    M=D // Store the final value of sum in RAM[1]

    (END) 
        @END 
        0;JMP 