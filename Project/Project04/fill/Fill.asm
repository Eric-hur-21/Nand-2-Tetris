// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// Infinite loop in two layers

// Fill.asm
// Blackens the screen while a key is held; clears it otherwise.


// My method: I will be using 8192 countdown counter 

@color 
M=0     // Set default color to black (0)

(LOOP) 

    @SCREEN 
    D=A 
    @ptr   // pointer is for current pixel address
    M=D    // Saves the value of the screen memory address in ptr 

    @8192 
    D=A 
    @end   // stop iteration when counter reaches 0
    M=D 

    @KBD // Pressing Keyboard
    D=M  // Saves the value of the keyboard memory address in D

    @BLACK // starting condition: key pressed equals D != 0  
    D;JGT   

    @color
    M=0
    @PAINT
    0;JMP

    (BLACK)
        @color
        M=-1

    (PAINT)
        @color
        D=M
        
        // Which memory address to paint
        @ptr 
        A=M // Get the current pixel address first 
        M=D // Paint the pixel with the color in D 

        // Move the pointer to the next pixel
        @ptr
        M=M+1 
        
        // Decrement the counter
        @end
        M=M-1
        D=M
        @PAINT
        D;JGT
        
@LOOP
0;JMP 



    
