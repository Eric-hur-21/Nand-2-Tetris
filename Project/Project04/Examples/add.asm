// Program: Add.asm
// Computes: RAM[2] = RAM[0] + RAM[1] + 17
// Usage: put values in RAM[0] and in RAM[1] 
    // D = RAM[0]
    @R0 
    D=M // With the address pointing at RAM[0], we store memory value in D
    // D = D + RAM[1] 
    @R1
    D=D+M // With the address pointing in RAM[1], 
          // we add the value in memory to D with the summed value 

    @17 // This is the actual data 17 
    D=D+A // We are adding the latest value in D to the value in address A

    @R2 // We are now pointing to RAM[2] 
    M=D // The M is the storage that is in RAM[2] 
        // and we store the value in D to M. 


    (END) 
        @END // The inifnite loop is stopping the CPU 
        0;JMP

