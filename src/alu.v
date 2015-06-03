`include "def.v"
`include "aux.v"

module alu
(
	//Entradas de control
	input wire 		clk,
	input wire		reset,
	input wire [5:0]	opcode,

	//Entradas de datos
	input wire [9:0] 	in1,
	input wire [9:0]	in2,

	//Salidas
	output wire [7:0]  	rWrData
);


always @ ( posedge clk )
begin
	case (opcode)
	//Oparaciones de transferencia de datos
	`LDCA:
	begin
		rWrData	<= 	8'b0;			
	end
	`LDCB:
	begin
		rWrData	<= 	8'b0;			
	end

	`LDA:
	begin
		rWrData	<= 	8'b0;			
	end
	`LDB:
	begin
		rWrData	<= 	8'b0;			
	end
	`STA:
	begin
		rWrData	<= 	in1[7:0];		
	end
	`STB:
	begin
		rWrData	<= 	in2[7:0];		
	end
	//-------------------------------------

	//Oparaciones aritmeticas
	`ADDA:
	begin
		rWrData	<= 	in1[7:0] + in2[7:0];	
	end
	`ADDB:
	begin
		rWrData	<= 	in1[7:0] + in2[7:0];
	end
	//-------------------------------------

	//Oparaciones logicas

	//-------------------------------------

	//Oparaciones de control de flujo

	//-------------------------------------

	//Otras
	`NOP:
	begin
		rWrData	<= 	8'b0;			
	end
	//-------------------------------------
	default:
	begin
		rWrData	<= 	8'b0;	
	end	
	endcase	
end
endmodule