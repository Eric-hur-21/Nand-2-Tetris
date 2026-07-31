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