`include "def.v"

module decodec
(
	//Entradas de control
	input wire 		clk,
	input wire		reset,

	//Entradas de datos
	input wire [15:0] 	in,
	input wire [2:0]	flagA,	//{z,c,n}
	input wire [2:0]	flagB,	//{z,c,n}

	//Salidas de control
	output reg [1:0]  	selA,
	output reg [1:0]  	selB,
	output reg  		selM1,
	output reg  		selM2,
	output reg  		wrEnable,
	output reg  		jmpEnable,
	output reg  		branchEnable,

	//Salidas de datos
	output reg [7:0]  	inm,
	output reg [9:0]  	memDir,
	output reg [5:0]  	branchDir,
	output reg [9:0]  	jmpDir,
	output reg [5:0]  	opCode,
);

assign inm = {in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
assign memDir = {in[9],in[8],in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
assign branchDir = {in[5],in[4],in[3],in[2],in[1],in[0]};
assign jmpDir = {in[9],in[8],in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
assign opCode = {in[15],in[14],in[13],in[12],in[11],in[10]};

always @ ( posedge clk )
begin
	case (opcode)
	//Oparaciones de transferencia de datos
	`LDA:
	begin
		selA		<= 	2'b11;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;			
	end
	`LDB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b11;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;			
	end

	`LDCA:
	begin
		selA		<= 	2'b01;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;			
	end
	`LDCB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b01;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;			
	end

	`STA:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b1;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;		
	end

	`STB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b1;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;		
	end
	//-------------------------------------

	//Oparaciones aritmeticas
	`ADDA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ADDB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end

	`ADDCA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ADDCB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end

	`SUBA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`SUBB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end

	`SUBCA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`SUBCB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end
	//-------------------------------------

	//Oparaciones logicas

	`ANDA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ANDB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end

	`ANDCA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ANDCB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end

	`ORA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ORB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end

	`ORCA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ORCB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end

	`ASLA:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ASRA:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end
	//-------------------------------------

	// Operaciones de control de flujo

	`JMP:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b1;
		branchEnable <= 1'b0;
	end
	`BAEQ:
	begin
		if (flagA[2] == 1)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BANE:
	begin
		if (flagA[2] == 0)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BACS:
	begin
		if (flagA[1] == 1)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BACC:
	begin
		if (flagA[1] == 0)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BAMI:
	begin
		if (flagA[0] == 1)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BAPL:
	begin
		if (flagA[0] == 0)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end

	//-------------------------------------

	`BBEQ:
	begin
		if (flagB[2] == 1)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BBNE:
	begin
		if (flagB[2] == 0)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BBCS:
	begin
		if (flagB[1] == 1)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BBCC:
	begin
		if (flagB[1] == 0)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BBMI:
	begin
		if (flagB[0] == 1)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	`BBPL:
	begin
		if (flagB[0] == 0)
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b0;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b0;	
      	end	
	end
	//-------------------------------------

	//Otras
	`NOP:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;			
	end
	//-------------------------------------
	default:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;	
	end	
	endcase	
end
endmodule
