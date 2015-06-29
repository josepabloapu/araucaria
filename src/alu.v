`include "def.v"
`include "aux.v"

module alu
(
	//Entradas de control
	input wire [5:0]	opcode,

	//Entradas de datos
	input wire [7:0] 	in1,
	input wire [7:0]	in2,

	//Salidas
	output reg [8:0]  	out		//El octavo bit corresponde al acarreo
);


always @ ( * )
begin
	case (opcode)
	//Oparaciones de transferencia de datos
	`LDA:
	begin
		out	<= 	9'b0;			
	end
	`LDB:
	begin
		out	<= 	9'b0;			
	end

	`LDCA:
	begin
		out	<= 	9'b0;			
	end
	`LDCB:
	begin
		out	<= 	9'b0;			
	end


	`STA:
	begin
		out	<= 	{1'b0,in1};		
	end

	`STB:
	begin
		out	<= 	{1'b0,in2};		
	end
	//-------------------------------------

	//Oparaciones aritmeticas
	`ADDA:
	begin
		out	<= 	in1 + in2;	
	end
	`ADDB:
	begin
		out	<= 	in1 + in2;
	end

	`ADDCA:
	begin
		out	<= 	in1 + in2;	
	end
	`ADDCB:
	begin
		out	<= 	in1 + in2;
	end

	`SUBA:
	begin
		out	<= 	in1 - in2;	
	end
	`SUBB:
	begin
		out	<= 	in2 - in1;
	end

	`SUBCA:
	begin
		out	<= 	in1 - in2;	
	end
	`SUBCB:
	begin
		out	<= 	in2 - in1;
	end
	//-------------------------------------

	//Oparaciones logicas

	`ANDA:
	begin
		out	<= 	in1 & in2;	
	end
	`ANDB:
	begin
		out	<= 	in2 & in1;
	end

	`ANDCA:
	begin
		out	<= 	in1 & in2;	
	end
	`ANDCB:
	begin
		out	<= 	in2 & in1;
	end

	`ORA:
	begin
		out	<= 	in1 | in2;	
	end
	`ORB:
	begin
		out	<= 	in2 | in1;
	end

	`ORCA:
	begin
		out	<= 	in1 | in2;	
	end
	`ORCB:
	begin
		out	<= 	in2 | in1;
	end

	`ASLA:
	begin
		out	<= 	in1 << 1;	
	end
	`ASRA:
	begin
		out	<= 	in1 >> 1;
	end

	//-------------------------------------

	//Oparaciones de control de flujo
		//Ninguna de las operaciones de control de flujo requiere la ALU,
		//estas operaciones ejecutan el default.
	//-------------------------------------

	//Otras
	`NOP:
	begin
		out	<= 	9'b0;			
	end
	//-------------------------------------
	default:
	begin
		out	<= 	9'b0;	
	end	
	endcase	
end
endmodule