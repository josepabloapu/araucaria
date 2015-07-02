//`include "Defintions.v"


module ROM
(
	input wire		Clock,
	input  wire[9:0]	Ip,
	output reg [15:0]	Instr
);	
always @ ( posedge Clock )
begin
	case (Ip)
	
	//Prog 1: Suma al numero $1A el numero 2C de forma iterativa.
	0: Instr = {`NOP,  10'h0};
	1: Instr = {`LDCA, 2'b0, 8'h1A};	//Carga $1A al acomulador A
	2: Instr = {`NOP,  10'h0};
	3: Instr = {`NOP,  10'h0};
	4: Instr = {`NOP,  10'h0};
	5: Instr = {`LDCB, 2'b0, 8'h2C};	//Carga $2C al acomulador B
	6: Instr = {`NOP,  10'h0};
	7: Instr = {`NOP,  10'h0};
	8: Instr = {`NOP,  10'h0};
	9: Instr = {`ADDA, 10'h00};	//Suma A con B y el resultado lo guarda en A
	10: Instr = {`NOP,  10'h0};
	11: Instr = {`NOP,  10'h0};
	12: Instr = {`NOP,  10'h0};
	13: Instr = {`STA,  10'h100};	//Escribe el contenido del acomulador A en la posicion de memoria $100 (64).
	14: Instr = {`NOP,  10'h0};
	15: Instr = {`NOP,  10'h0};
	16: Instr = {`NOP,  10'h0};
	17: Instr = {`JMP,  4'b0, 6'd3};  //Salta ala cuerta instruccion y vuelve a sumar A con B.

	default:
		Instr = {`NOP,  10'h0};
	endcase	
end
	
endmodule
