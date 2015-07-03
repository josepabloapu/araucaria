/*--Modulos Auxiliares-----------------------------//
Lista de modulos dentro de este archivo:
		
		1)FFD 		(Disparado por flanco, con reset sincrónico)
		2)RAM		(Memoria parametrizada con linea de Lectura / Escritura)
		3)RPG 		(Registro de proposito general / Acomulador)
		4)MUX 		(Multiplexor de tamaño de entrada/salida varible, 2 entradas)
		5)MUX4 		(Multiplexor de tamaño de entrada/salida varible, 4 entradas)
		6)ALU		(Unidad Logico-Aritmetica, no realiza calculos de direccion efectiva)
		7)DECODEC	(Decodificador de instrucciones, genera las señales de control y los datos en ID)

//------------------------------------------------*/
module FFD # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]			D,
	output reg [SIZE-1:0]			Q
);	
always @ (posedge Clock) 
begin
	if ( Reset )
		Q <= 0;
	else
	begin	
		if (Enable) 
			Q <= D; 
	end	
 
end
endmodule
//------------------------------------------------//
module RAM # ( parameter DATA_WIDTH= 8, parameter ADDR_WIDTH=10, parameter MEM_SIZE=1024 )
(
	input wire					Clock,
	input wire					iWriteEnable,
	input wire[ADDR_WIDTH-1:0]			iAddress,
	input wire[DATA_WIDTH-1:0]			iDataIn,
	output reg [DATA_WIDTH-1:0]			 oDataOut
);
reg [DATA_WIDTH-1:0] Data [MEM_SIZE:0];		
always @(posedge Clock) 
begin 
		
		oDataOut <= Data[iAddress];		
	
		if (iWriteEnable) 
			Data[iAddress] <= iDataIn; 
			
end 
endmodule
//------------------------------------------------//
module RPG # (parameter DATA_WIDTH= 8)			//Acomulador
(
	input wire 					Clock,
	input wire[1:0]				Select,
	input wire[DATA_WIDTH-1:0]	iInm,
	input wire[DATA_WIDTH:0]	iAlu,			//Esta entrada incluye el acarreo
	input wire[DATA_WIDTH-1:0]	iMem,
	output reg[DATA_WIDTH-1:0]	oRPG,
	output reg[2:0]				oFlags
);
always @(posedge Clock)
begin
	case(Select)
		0: 
		begin
			oRPG 	<= oRPG;
			oFlags 	<= oFlags;
		end
		1: 
		begin
			oRPG 	<= iInm;
			oFlags 	<= {&(!iInm),1'b0,iInm[DATA_WIDTH-1]};
		end
		2: 
		begin
			oRPG 	<= iAlu[DATA_WIDTH-1:0];
			oFlags 	<= {&(!iAlu[DATA_WIDTH:0]),iAlu[DATA_WIDTH],iAlu[DATA_WIDTH-1]};
		end

		3: 
		begin
			oRPG 	<= iMem;
			oFlags 	<= {&(!iMem),1'b0,iMem[DATA_WIDTH-1]};
		end
	endcase
end
endmodule
//------------------------------------------------//
module MUX # (parameter DATA_WIDTH= 8)
(
	input wire 			Select,
	input wire[DATA_WIDTH-1:0]	In1,		
	input wire[DATA_WIDTH-1:0]	In2,
	output reg[DATA_WIDTH-1:0]	Out		 
);
always @ (*)
begin
	case(Select)
		0: 
		begin
			Out 	<= In1;
		end
		1: 
		begin
			Out 	<= In2;
		end
	endcase
end
endmodule
//------------------------------------------------//
module MUX4 # (parameter DATA_WIDTH= 8)
(
	input wire[1:0] 			Select,
	input wire[DATA_WIDTH-1:0]	In1,		
	input wire[DATA_WIDTH-1:0]	In2,
	input wire[DATA_WIDTH-1:0]	In3,		
	input wire[DATA_WIDTH-1:0]	In4,
	output reg[DATA_WIDTH-1:0]	Out		 
);
always @ (*)
begin
	case(Select)
		0: 
		begin
			Out 	<= In1;
		end
		1: 
		begin
			Out 	<= In2;
		end
		2: 
		begin
			Out 	<= In3;
		end
		3: 
		begin
			Out 	<= In4;
		end		
	endcase
end
endmodule
//------------------------------------------------//
module ALU
(
	//Entradas de control
	input wire [5:0]	opcode,

	//Entradas de datos
	input wire [7:0] 	in1,
	input wire [7:0]	in2,

	//Salidas
	output reg [8:0]  	out		//El noveno bit corresponde al acarreo
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
		out	<= 	{1'b0,in1};			
	end
	`LDCB:
	begin
		out	<= 	{1'b0,in2};		
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
		out	<= 	{1'b0,in1 & in2};	
	end
	`ANDB:
	begin
		out	<= 	{1'b0,in2 & in1};
	end

	`ANDCA:
	begin
		out	<= 	{1'b0,in1 & in2};	
	end
	`ANDCB:
	begin
		out	<= 	{1'b0,in2 & in1};
	end

	`ORA:
	begin
		out	<= 	{1'b0,in1 | in2};	
	end
	`ORB:
	begin
		out	<= 	{1'b0,in2 | in1};
	end

	`ORCA:
	begin
		out	<= 	{1'b0,in1 | in2};	
	end
	`ORCB:
	begin
		out	<= 	{1'b0,in2 | in1};
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

module DECODEC
(
	//Entradas de control
	input wire [2:0]	flagA,	//{z,c,n}
	input wire [2:0]	flagB,	//{z,c,n}
	//Entradas de datos
	input wire [15:0] 	in,
	//Salidas de control
	output reg [1:0]  	selA,
	output reg [1:0]  	selB,
	output reg  		selM1,
	output reg  		selM2,
	output reg  		wrEnable,
	output reg  		jmpEnable,
	output reg  		branchEnable,
	//Salidas de datos
	output wire [7:0]  	inm,
	output wire [9:0]  	memDir,
	output wire [6:0]  	branchDir,
	output wire [9:0]  	jmpDir,
	output wire [5:0]  	opCode
);
assign inm 		= in[7:0];
assign memDir 		= in[9:0];
assign branchDir 	= in[6:0];
assign jmpDir 		= in[9:0];
assign opCode 		= in[15:10];
always @ ( * )
begin
	case (opCode)
	//Oparaciones de transferencia de datos
	`LDA:
	begin
		selA		<= 	2'b11;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;			
	end
	`LDB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b11;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;			
	end

	`LDCA:
	begin
		selA		<= 	2'b01;
		selB		<= 	2'b00;
		selM1		<= 	1'b1;
		selM2		<= 	1'b0;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;			
	end
	`LDCB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b01;
		selM1		<= 	1'b1;
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
		selM1		<= 	1'b1;
		selM2		<= 	1'b1;
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
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ADDB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
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
		selM1		<= 	1'b1;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end
	`SUBA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`SUBB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
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
		selM1		<= 	1'b1;
		selM2		<= 	1'b1;
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
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ANDB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
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
		selM1		<= 	1'b1;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end
	`ORA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ORB:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b10;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
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
		selM1		<= 	1'b1;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;
	end
	`ASLA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end
	`ASRA:
	begin
		selA		<= 	2'b10;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
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
		selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
			selM2		<= 	1'b1;
			wrEnable	<= 	1'b0;
			jmpEnable	 <= 1'b0;
			branchEnable <= 1'b1;	
    	end
  		else
    	begin
      		selA		<= 	2'b00;
			selB		<= 	2'b00;
			selM1		<= 	1'b0;
			selM2		<= 	1'b1;
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
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;			
	end
	//-------------------------------------
	default:
	begin
		selA		<= 	2'b00;
		selB		<= 	2'b00;
		selM1		<= 	1'b0;
		selM2		<= 	1'b1;
		wrEnable	<= 	1'b0;
		jmpEnable	 <= 1'b0;
		branchEnable <= 1'b0;	
	end	
	endcase	
end
endmodule
