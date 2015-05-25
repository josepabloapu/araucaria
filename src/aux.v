/*--Auxiliary Modules-----------------------------//
Modules:
		1)UPCOUNTER_POSEDGE
		2)FFD_POSEDGE
		3)FULL_ADDER
		4)DUAL_READ_RAM

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

module FFD_POSEDGE_SYNCRONOUS_RESET # ( parameter SIZE=8 )
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

module RAM_DUAL_READ_PORT # ( parameter DATA_WIDTH= 8, parameter ADDR_WIDTH=10, parameter MEM_SIZE=10 )
(
	input wire			Clock,
	input wire			iWriteEnable,
	input wire[ADDR_WIDTH-1:0]	iReadAddress0,
	input wire[ADDR_WIDTH-1:0]	iReadAddress1,
	input wire[ADDR_WIDTH-1:0]	iWriteAddress,
	input wire[DATA_WIDTH-1:0]	iDataIn,
	output reg [DATA_WIDTH-1:0] 	oDataOut0,
	output reg [DATA_WIDTH-1:0] 	oDataOut1

);

reg [DATA_WIDTH-1:0] Ram [MEM_SIZE:0];		



always @(posedge Clock) 
begin 
	
		if (iWriteEnable) 
			Ram[iWriteAddress] <= iDataIn; 
			
			oDataOut0 <=(( iWriteAddress == iReadAddress0 ) && iWriteEnable ) ? iDataIn : Ram[iReadAddress0 ] ;
			oDataOut1 <= (( iWriteAddress == iReadAddress1 ) && iWriteEnable ) ? iDataIn : Ram[iReadAddress1 ] ;

end 
endmodule

//------------------------------------------------//