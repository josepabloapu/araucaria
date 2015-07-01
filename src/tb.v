`timescale 1ns / 1ps
`include "def.v"
`include "alu.v"
`include "decodec.v"
`include "aux.v"
`include "rom.v"
`include "uP.v"

module testbench;

//Inputs

//Outputs

reg Clock;
reg Reset;

always 
begin
	#5 Clock = ! Clock;
end

uP araucaria
(
	.Clock(Clock),
	.Reset(Reset)
);


initial 
begin
	Clock = 0;
	#05 	Reset=1; #05 Reset=0;
	#200
	$finish;
end

initial 
begin
	$dumpfile("uP_TEST.vcd");
	$dumpvars;
end


endmodule 
