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
	output wire [9:0] 	rReDir,
	output wire [9:0] 	rWrDir,
	output wire [7:0]  	rWrData
);


always @ ( posedge clk )
begin
	case (opcode)
	//Oparaciones de transferencia de datos
	`LDCA:
	begin
		rReDir	<= 	10'b0;
		rWrDir	<= 	10'b0;
		rWrData	<= 	8'b0;			
	end
	`LDCB:
	begin
		rReDir	<= 	10'b0;
		rWrDir	<= 	10'b0;
		rWrData	<= 	8'b0;			
	end

	`LDA:
	begin
		rReDir	<= 	in1[7:0];
		rWrDir	<= 	10'b0;
		rWrData	<= 	8'b0;			
	end
	`LDB:
	begin
		rReDir	<= 	in1[7:0];
		rWrDir	<= 	10'b0;
		rWrData	<= 	8'b0;			
	end
	`STA:
	begin
		rReDir	<= 	10'b0;
		rWrDir	<= 	in1;
		rWrData	<= 	in2[7:0];		
	end
	`STB:
	begin
		rReDir	<= 	10'b0;
		rWrDir	<= 	in2;
		rWrData	<= 	in1[7:0];		
	end
	//-------------------------------------

	//Oparaciones aritmeticas
	`ADDA:
	begin
		rReDir	<= 	10'b0;
		rWrDir	<= 	10'b0;
		rWrData	<= 	in1[7:0] + in2[7:0];	
	end
	`ADDB:
	begin
		rReDir	<= 	10'b0;
		rWrDir	<= 	10'b0;
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
		rReDir	<= 	1'b0;
		rWrDir	<= 	1'b0;
		rWrData	<= 	1'b0;			
	end
	//-------------------------------------
	
	default:
	begin
		rReDir	<= 	1'b0;
		rWrDir	<= 	1'b0;
		rWrData	<= 	1'b0;	
	end	
	endcase	
end
endmodule
