`timescale 1ns / 1ps
`include "alu.v"
`include "def.v"

module testbench;

//Inputs

reg [7:0] wIn1;
reg [7:0] wIn2;

reg [5:0] wOp;

//Outputs
wire [7:0] wAlu;


reg Clock;
reg Reset;

always 
begin
	#5 Clock = ! Clock;
end

alu a0 
(
	.clk(Clock),
	.reset(Reset),
	.opcode(wOp),
	.in1(wIn1),
	.in2(wIn2),
	.out(wAlu)
);


initial 
begin
	Clock = 0;
	#05 	Reset=1; #05 Reset=0;

	#5	wOp = `ADDA; 	wIn1 = 8'd21; 	wIn2 = 8'd5;
	#10 	wOp = `ADDB; 	wIn1 = 8'd21; 	wIn2 = 8'd4;
	#10 	wOp = `ADDCA; 	wIn1 = 8'd21; 	wIn2 = 8'd5;	
	#10	wOp = `ADDCB; 	wIn1 = 8'd21; 	wIn2 = 8'd4;

	#10	wOp = `SUBA; 	wIn1 = 8'd21; 	wIn2 = 8'd5;
	#10 	wOp = `SUBB; 	wIn1 = 8'd21; 	wIn2 = 8'd4;
	#10 	wOp = `SUBCA; 	wIn1 = 8'd21; 	wIn2 = 8'd5;	
	#10	wOp = `SUBCB; 	wIn1 = 8'd21; 	wIn2 = 8'd4;

	#10	wOp = `ANDA; 	wIn1 = 8'd13; 	wIn2 = 8'd5;
	#10 	wOp = `ANDB; 	wIn1 = 8'd13; 	wIn2 = 8'd4;
	#10 	wOp = `ANDCA; 	wIn1 = 8'd13; 	wIn2 = 8'd5;	
	#10	wOp = `ANDCB; 	wIn1 = 8'd13; 	wIn2 = 8'd4;

	#10	wOp = `ORA; 	wIn1 = 8'd13; 	wIn2 = 8'd5;
	#10 	wOp = `ORB; 	wIn1 = 8'd13; 	wIn2 = 8'd4;
	#10 	wOp = `ORCA; 	wIn1 = 8'd13; 	wIn2 = 8'd5;	
	#10	wOp = `ORCB; 	wIn1 = 8'd13; 	wIn2 = 8'd4;

	#10 	wOp = `ASLA; 	wIn1 = 8'd4; 	wIn2 = 8'd5;	
	#10	wOp = `ASRA; 	wIn1 = 8'd4; 	wIn2 = 8'd5;

	#10
	$finish;
end

initial 
begin
	$dumpfile("sim1.vcd");
	$dumpvars;
end


endmodule 
