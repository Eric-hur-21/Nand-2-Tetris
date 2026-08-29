# Nand-2-Tetris
Documenting my journey down to the lower levels. 

## [Project 01: Boolean Logic Gate](Project/Project01)
I dove straight into the project after reading the goal, learning Boolean algebra and HDL as I needed them rather than reading theory first. That made the learning active. For example, I picked up sum-of-products by working it out on `Xor`: identify the rows where the output is 1, write one minterm per row by chaining the inputs with ∧ and negating the ones that are 0, then combine the minterms with ∨. Grinding that out once made every subsequent gate faster.

Another key learning was the ordering of `sel` bits. Wiring `sel[0]` to the coarse split instead of `sel[1]` still produces a valid circuit — but it swaps outputs `b` and `c`, so it no longer matches the `DMux4Way` specification. Meaning comes from where you wire a bit, not from anything electrical about it.

Beyond the content, I started connecting this to my electronics background: data flows in series through stages, while control signals fan out in parallel to many gates at once. That framing also clarified where circuit depth turns into propagation delay.


## [Project 02: Arithmetic Logic Unit](Project/Project02)
The ALU provides the minimal set of arithmetic and logic operations that everything else — including multiply, divide, and eventually the whole OS — can be built up from.

Two takeaways: (1) the beauty of two's complement (the radix complement), and (2) the control bit `f` routing to either the arithmetic or the logic world.

Before building the ALU, I was fascinated by how seemingly orthogonal columns, chained together, produce a function — especially the combinations involving the NOT gate, which is nothing arithmetic on its own. The beauty lies in the binary base.

The binary base speaks two languages: arithmetic (quantity) and logic (truth values, T/F). And because negative numbers are defined through two's complement, negation follows directly from bitwise NOT. For example, in a 3-bit system, $(001)_2 = (1)_{10}$. Negating it bitwise gives $!(001)_2 = (110)_2 = (-2)_{10}$, which matches the identity $!a = -a - 1$ (here $-1 - 1 = -2$). So it is two's complement, together with negation, that couples the two worlds.

Finally, it is the control bit `f` that routes into one world or the other: if `f`, then `out = x + y`, else `out = x & y`. Every output from `f = 1` is arithmetic, and every output from `f = 0` is logic.


## [Project 03: Memory](Project/Project03)

The new primitive in this chapter that allows logical functions to use data processed previously is the Data Flip-Flop. Like the two previous chapters, it built on top of the primitive circuits. I started with the bit-DFF, extending it to registers that are 16-bit width. Then the recursive method kicked into place as I built RAM8, RAM64, RAM512, RAM4K, and RAM16K.

Finally, from the program counter (PC), I really learned how to build conditionals in HDL. The number of conditions equals the number of Muxes required, and in HDL, conditionals have to work backwards, where the first condition programmatically becomes the last Mux. Moreover, I learned how to leverage the fan-out output method for feedback. This is where you have the same output pin but two different variable names.


## [Project 04: Machine Language](Project/Project04)
A key learning from this chapter was how compartmentalized registers build up into a functional system. At its core, a computing system is built purely from logic gates; chapter 3 introduced registers, which added memory. Because memory and logic are coupled so tightly at this level, it becomes crucial to specify exactly which memory location you are accessing and where each value currently lives.

The main challenge in Mult and Fill was the logic, because I had to think about memory first. Conditional logic in assembly is also inverted: since instructions run sequentially from address 0 onward, you jump over the branch you don't want rather than into the one you do. Symbolic labels are simply instructions to send the tape back to line x — much like a mechanical reader pulling paper tape backward.

For Fill.asm, the breakthrough was understanding `A=M`. That single line reads the value stored at the address currently in A, then loads that value into A — so A stops pointing at the variable and starts pointing at the screen. The next line, `M=D`, then writes to the new location. I only understood this because I was stuck trying to find a way to advance to the next screen index.


## [Project 05: HACK Computer](Project/Project05)

Although there were many takeaways conceptually, these were some of the noticeable parts of the learning process as I went back and forth from implementation to concept. I hope this will be a helpful reminder for my future self.

Note that the HACK computer captures the von-Neuman architecture. Therefore, although it's in its simplest form, the core pillars holds. 

Firstly, these were the three steps:

1. Memory
2. CPU
3. Computer

The "computer" step is extremely straightforward because it's just connecting three core components. Once HDL "wiring" becomes familiar, Computer.hdl becomes plug-in writing.

* ROM32K (stores pre-instructions)
* CPU
* Memory

Before I dive into the following concepts, it's helpful to understand that HDL isn't a sequential script, and yet the reasoning required for implementation is highly inverse to typical programming reasoning. Therefore, the takeaways below might seem reversed in order.

The key implementation skill in memory was what I will call "load-broadcasting". Within the memory, there are (1) the actual 16K memory, (2) the 8K screen pixel memory, and (3) the 1-word keyboard memory. The first memory had to be read-and-write, the second memory had to be write-only, and lastly the keyboard would be read-only. Load is the information that switches a specific register on and off, so that it either holds new data or stays put with the previous data. Before the load information could reach the register, we would need to "broadcast" it correctly. In HDL, broadcasting is done using DMux with the selector `sel` to route to either memory (1), (2), or (3).

With the load-broadcasting concept in mind, the next key skill honed during memory selection was "bit-sel". I'm still thinking of a catchier term for this. Bit-sel is a repeating concept; it appears in the CPU as well. The highest three bits of the selector, `address[13..15]`, will offer 4 possible broadcasting paths: 00, 01, 10, and 11. 00 and 01 are used for the 16K memory, and the subsequent two are used for (2) and (3). Why two paths for the 16K memory? This is where the bit-sel concept goes into detail. The number of memories for 16K ranges from 00 to 01, highest-bit-wise. The analogy using decimal would be how the 16K memory uses decimal 010 to 100, having the full range of 0 to 99.

Once we load-broadcast to all three of these channels, we hold four output pins which can be inserted into their respective memory registers. After going through their own "island" of registers, the outputs will converge using a Mux to give the final output.

For the CPU, there were two key learnings: (1) data routing and (2) data path. I noticed that for conceptual understanding, the cognitive effort goes into the actual data path for each time tick. During implementation, this has to sum up into a clear pin-to-pin HDL script, where the data routing `sel` or `load` concept becomes essential. I came to appreciate how 16 bits can be used as an A or C instruction, and as data or as instruction. For 16 bits to be used as an instruction, it meant that within those 16 bits, the bits were categorized accordingly:

```
1 1 1  a c1c2c3c4c5c6   d1d2d3   j1j2j3
       └── comp ──┘     └dest┘
       right of =       left of =
       bits 12-6        bits 5-3
```

These are the loads and selector switches for the registers, Mux, ALU, and PC in the CPU. The details can be analyzed through HDL, so I aim to articulate the core skill in implementing it. It comes down to really understanding the data flow conceptually.

1. Each time step ticks. When an instruction runs, the information is available on that next tick.
2. First, the ALU chooses between the instruction and the ALU output. This requires the A/C bit.
3. There is an A register before the next Mux. The A register holds a load, which is controlled by the d1 bit together with the A/C bit.
4. The following step is a Mux, which routes whether to use the A value or the memory value pulled from Memory.
5. That, together with D (if loaded), is fed into the ALU. The ALU uses a 6-bit instruction.

I didn't go into the PC jump portion, but the high-level understanding here is how switch information is stored in the 16 bits.

![HACK_CPU_schematic](image.png)
*Figure 1 — Proposed Hack CPU implementation*