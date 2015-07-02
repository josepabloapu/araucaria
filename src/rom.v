module ROM
(
	input wire Clock,
	input wire [9:0] Ip,
	output reg [15:0] Instr
);

reg [15:0] data [0:1023];

initial $readmemb("../test/sum.arau", data);

integer i;
always @( posedge Clock)
begin
    i=Ip;
	Instr = data[Ip];
end
	
endmodule 
