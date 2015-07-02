/*--Auxiliary Modules-----------------------------//
Modules:
		1)UPCOUNTER_POSEDGE
		2)FFD_POSEDGE
		3)FULL_ADDER
		4)RAM

//------------------------------------------------*/

module UPCOUNTER_POSEDGE # (parameter SIZE=16)
(
input wire Clock, Reset,
input wire [SIZE-1:0] Initial,
input wire Enable,
output reg [SIZE-1:0] Q
);

  always @(posedge Clock )
  begin
      if (Reset)
        Q = Initial;
      else
		begin
		if (Enable)
			Q = Q + 1;
			
		end			
  end

endmodule

//------------------------------------------------//

module FFD # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	output reg [SIZE-1:0]	Q
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

module FFD_PL # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	input wire [SIZE-1:0]	ResetD,
	output reg [SIZE-1:0]	Q
);
	
always @ (posedge Clock) 
begin
	if ( Reset )
		Q <= ResetD;
	else
	begin	
		if (Enable) 
			Q <= D; 
	end	
 
end
endmodule

//------------------------------------------------//

module FULL_ADDER # (parameter SIZE=8) 
(
	input  wire [SIZE-1:0] 	In1,
	input  wire [SIZE-1:0] 	In2,
	input  wire		Ci,
	output wire [SIZE-1:0] 	Out,
	output wire [SIZE-1:0]	Co
);

assign {Co,Out} = In1 + In2 + Ci;
endmodule

//------------------------------------------------//

module RAM # ( parameter DATA_WIDTH= 8, parameter ADDR_WIDTH=10, parameter MEM_SIZE=1024 )
(
	input wire					Clock,
	input wire					iWriteEnable,
	input wire[ADDR_WIDTH-1:0]	iAddress,
	input wire[DATA_WIDTH-1:0]	iDataIn,
	output reg [DATA_WIDTH-1:0] oDataOut
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
			oFlags 	<= {~&iInm,1'b0,iInm[DATA_WIDTH-1]};
		end
		2: 
		begin
			oRPG 	<= iAlu[DATA_WIDTH-1:0];
			oFlags 	<= {~&iAlu[DATA_WIDTH:0],iAlu[DATA_WIDTH],iAlu[DATA_WIDTH-1]};
		end

		3: 
		begin
			oRPG 	<= iMem;
			oFlags 	<= {~&iMem,1'b0,iMem[DATA_WIDTH-1]};
		end

	endcase
end
endmodule

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
