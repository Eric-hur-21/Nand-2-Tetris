# Nand-2-Tetris
Documenting my journey down to the lower levels. 

## [Project 01: Boolean Logic Gate](Project/Project01)
I dove straight into the project after reading the goal, learning Boolean algebra and HDL as I needed them rather than reading theory first. That made the learning active. For example, I picked up sum-of-products by working it out on `Xor`: identify the rows where the output is 1, write one minterm per row by chaining the inputs with ∧ and negating the ones that are 0, then combine the minterms with ∨. Grinding that out once made every subsequent gate faster.

Another key learning was the ordering of `sel` bits. Wiring `sel[0]` to the coarse split instead of `sel[1]` still produces a valid circuit — but it swaps outputs `b` and `c`, so it no longer matches the `DMux4Way` specification. Meaning comes from where you wire a bit, not from anything electrical about it.

Beyond the content, I started connecting this to my electronics background: data flows in series through stages, while control signals fan out in parallel to many gates at once. That framing also clarified where circuit depth turns into propagation delay.
