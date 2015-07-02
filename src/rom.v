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
	1: Instr = {`LDCA, 2'b0, 8'h9A};	//Carga $1A al acomulador A
	2: Instr = {`NOP,  10'h0};
	3: Instr = {`NOP,  10'h0};
	4: Instr = {`LDCB, 2'b0, 8'h7C};	//Carga $2C al acomulador B
	5: Instr = {`NOP,  10'h0};
	6: Instr = {`NOP,  10'h0};
	7: Instr = {`ADDA, 10'h00};	//Suma A con B y el resultado lo guarda en A
	8: Instr = {`NOP,  10'h0};
	9: Instr = {`NOP,  10'h0};
	10: Instr = {`STA,  10'h100};	//Escribe el contenido del acomulador A en la posicion de memoria $100 (64).
	11: Instr = {`NOP,  10'h0};
	12: Instr = {`NOP,  10'h0};
	13: Instr = {`LDB,  10'h100};
	14: Instr = {`NOP,  10'h0};
	15: Instr = {`NOP,  10'h0};
	16: Instr = {`BBNE, 3'b0, 7'h7D};  //Salta ala cuerta instruccion y vuelve a sumar A con B.
	17: Instr = {`NOP,  10'h0};
	18: Instr = {`NOP,  10'h0};
	
	default:
		Instr = {`NOP,  10'h0};
	endcase	
end
	
endmodule
