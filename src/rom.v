//`include "Defintions.v"


module ROM
(
	input wire		clk,
	input  wire[9:0]	pc,
	output reg [15:0]	instr
);	
always @ ( posedge clk )
begin
	case (pc)
	
	//Prog 1: Suma al numero $1A el numero 2C de forma iterativa.
	0: instr = {`NOP,  10'h0};
	1: instr = {`LDCA, 2'b0, 8'h1A};	//Carga $1A al acomulador A
	2: instr = {`NOP,  10'h0};
	3: instr = {`NOP,  10'h0};
	4: instr = {`NOP,  10'h0};
	5: instr = {`LDCB, 2'b0, 8'h2C};	//Carga $2C al acomulador B
	6: instr = {`NOP,  10'h0};
	7: instr = {`NOP,  10'h0};
	8: instr = {`NOP,  10'h0};
	9: instr = {`ADDA, 10'h00};	//Suma A con B y el resultado lo guarda en A
	10: instr = {`NOP,  10'h0};
	11: instr = {`NOP,  10'h0};
	12: instr = {`NOP,  10'h0};
	13: instr = {`STA,  10'h100};	//Escribe el contenido del acomulador A en la posicion de memoria $100 (64).
	14: instr = {`NOP,  10'h0};
	15: instr = {`NOP,  10'h0};
	16: instr = {`NOP,  10'h0};
	17: instr = {`JMP,  4'b0, 6'd3};  //Salta ala cuerta instruccion y vuelve a sumar A con B.

	default:
		instr = {`NOP,  10'h0};
	endcase	
end
	
endmodule
