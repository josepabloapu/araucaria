`timescale 1ns / 1ps
`include "decodec.v"
`include "def.v"

module waka;

//Inputs

reg [15:0] data;
reg [2:0] flaga;
reg [2:0] flagb;

reg [5:0] wOp;

//Outputs
wire [7:0] inm,
wire [9:0] memdir,
wire [5:0] branchdir,
wire [9:0] jmpdir,
wire [5:0] opcode,

wire [1:0]  sela
wire [1:0]  selb
wire  		selm1
wire  		selm2
wire  		wrenable
wire  		jmpenable
wire  		branchenable


reg Clock;
reg Reset;

always 
begin
	#5 Clock = ! Clock;
end

decodec d0 
(
	.clk(Clock),
	.reset(Reset),

	.selA(sela),
	.selB(selb),
	.selM1(selm1),
	.selM2(selm2),
	.wrEnable(wrenable),
	.jmpEnable(jmpenable),
	.branchEnable(branchenable),

	.inm(inm),
	.memDir(memdir),
	.branchDir(branchdir),
	.jmpDir(jmpdir),
	.opCode(opcode),

	.in(data),
	.flagA(flaga),
	.flagB(flagb)
);


initial 
begin
	Clock = 0;
	#05 	Reset=1; #05 Reset=0;

	#5	data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0 	flaga = 3'b000; 	flagb = 3'b000;	
	#10	data = 16'b0 	flaga = 3'b000; 	flagb = 3'b000;
	#10	data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0 	flaga = 3'b000; 	flagb = 3'b000;	
	#10	data = 16'b0 	flaga = 3'b000; 	flagb = 3'b000;
	#10	data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0 	flaga = 3'b000; 	flagb = 3'b000;	
	#10	data = 16'b0 	flaga = 3'b000; 	flagb = 3'b000;
	#10	data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;	
	#10	data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;
	#10 data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;	
	#10	data = 16'b0	flaga = 3'b000; 	flagb = 3'b000;

	#10
	$finish;
end

initial 
begin
	$dumpfile("simDECODEC.vcd");
	$dumpvars;
end


endmodule 
