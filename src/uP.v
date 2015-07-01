`include "alu.v"
`include "decod.v"
`include "def.v"
`include "aux.v"
`include "rom.v"

module uP
(
input wire Clock
);


alu a0 
(
	.clk(Clock),
	.reset(Reset),
	.opcode(wOp),
	.in1(wIn1),
	.in2(wIn2),
	.out(wAlu)
);





endmodule