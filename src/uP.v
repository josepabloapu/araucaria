//~ `include "def.v"
//~ `include "alu.v"
//~ `include "decodec.v"
//~ `include "aux.v"
//~ `include "rom.v"

module uP
(
input wire clk,
input wire Reset
);

//Wires
		//IF
		wire [9:0] 	wPC;
		wire [9:0] 	wPC_New;
		wire [9:0] 	wPC_Next;
		wire 		wPC_Sel;
		wire [15:0] wInstIF;
		wire [9:0]  wPC_BranchDir;

		//ID
		wire [15:0] wInstID;
		wire [1:0] 	wSelAID;
		wire [1:0]	wSelBID;
		wire wSelM1ID, wSelM2ID;
		wire wWrEnableID;
		wire wJmpEnableID;
		wire wBranchEnableID;
		wire [7:0] wInmID;
		wire [9:0] wMemDirID;
		wire [5:0] wBranchDirID;
		wire [9:0] wJmpDirID;
		wire [5:0] wOpCodeID;
		wire [2:0] wFlagA;
		wire [2:0] wFlagB;
		
		wire [7:0] wIn1;
		wire [7:0] wIn2;
		
		//EX
		wire [5:0] wOpCodeEX;
		wire wSelM1EX, wSelM2EX;
		wire [7:0] wInmEX; 
		wire [9:0] wMemDirEX;
		wire [5:0] wBranchDirEX;	
		wire [9:0] wJmpDirEX;	
		wire [1:0] wSelAEX;
		wire [1:0] wSelBEX;
		wire [7:0] wA;
		wire [7:0] wB;
		wire wWrEnableEX;
		wire wJmpEnableEX;
		wire wBranchEnableEX;
		wire [8:0] wAluEX;
		

		//MEM
		
		wire [8:0] wAluME;
		wire [9:0] wMemDirME;
		wire [1:0] 	wSelAME;
		wire [1:0]	wSelBME;
		
		//WB
		
		wire [8:0] wAluWB;
		wire [7:0] wMemWB;
		wire [1:0] wSelAWB;
		wire [1:0] wSelBWB;		
		

//IF
FFD # ( 10 ) PC 
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
		//~ .D(wPC_New),
	.D(wPC_Next),
	.Q(wPC)
);

assign  wPC_Next = wPC +1;

//~ MUX # (10) MX0
//~ (
	//~ .Select(wPC_Sel),
	//~ .In1(wPC_Next),
	//~ .In2(wPC_BranchDir),
	//~ .Out(wPC_New)
//~ );


//ID

ROM	ROM0
(
	.Clock(clk),
	.Ip(wPC),
	.Instr(wInstIF)
);


decodec ID0 
(
	.in(wInstIF),

	.selA(wSelAID),
	.selB(wSelBID),
	.selM1(wSelM1ID),
	.selM2(wSelM2ID),
	.wrEnable(wWrEnableID),
	.jmpEnable(wJmpEnableID),
	.branchEnable(wBranchEnableID),

	.inm(wInmID),
	.memDir(wMemDirID),
	.branchDir(wBranchDirID),
	.jmpDir(wJmpDirID),
	.opCode(wOpCodeID),

	.flagA(wFlagA),
	.flagB(wFlagB)
);

//EX

RPG # (8) A
(
	.Clock(clk),
	.Select(wSelAWB),
	.iInm(wAluWB[7:0]),
	.iAlu(wAluWB),
	.iMem(wMemWB),
	.oRPG(wA),
	.oFlags(wFlagA)
);

RPG # (8) B
(
	.Clock(clk),
	.Select(wSelBWB),
	.iInm(wAluWB[7:0]),
	.iAlu(wAluWB),
	.iMem(wMemWB),
	.oRPG(wB),
	.oFlags(wFlagB)
);

FFD # ( 8 ) IDEX0	//Valor inmediato
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInmID),
	.Q(wInmEX)
);

FFD # ( 1 ) IDEX10	//Lineas de seleccion de mux 1 y 2 
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelM1ID}),
	.Q({wSelM1EX})
);

FFD # ( 1 ) IDEX20	//Lineas de seleccion de mux 1 y 2 
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelM2ID}),
	.Q({wSelM2EX})
);


FFD # ( 3 ) IDEX2 // Write enable de la memoria, Jump enable y branch enable
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wWrEnableID,wJmpEnableID,wBranchEnableID}),
	.Q({wWrEnableEX,wJmpEnableEX,wBranchEnableEX})
);

FFD # ( 26 ) IDEX3 // Direcciones de salto incondicional y condicional
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wJmpDirID,wBranchDirID,wMemDirID}),
	.Q({wJmpDirEX,wBranchDirEX,wMemDirEX})
);

FFD # ( 6 ) IDEX4 // Direcciones de salto incondicional y condicional
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wOpCodeID),
	.Q(wOpCodeEX)
);


MUX # (8) MX1
(
	.Select(wSelM1EX),
	.In1(wA),
	.In2(wInmEX),
	.Out(wIn1)
);


MUX # (8) MX2
(
	.Select(wSelM2EX),
	.In1(wInmEX),
	.In2(wB),
	.Out(wIn2)
);


alu ALU0 
(
	.opcode(wOpCodeEX),
	.in1(wIn1),
	.in2(wIn2),
	.out(wAluEX)
);

FFD # ( 4 ) IDEX5 
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelAID,wSelBID}),
	.Q({wSelAEX,wSelBEX})
);


//ME

FFD # ( 10 ) EXME0 // Direcciones de salto incondicional y condicional
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wMemDirEX}),
	.Q({wMemDirME})
);

FFD # ( 9 ) EXME1 // Direcciones de salto incondicional y condicional
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wAluEX}),
	.Q({wAluME})
);

FFD # ( 1 ) EXME2 // Direcciones de salto incondicional y condicional
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wWrEnableEX}),
	.Q({wWrEnableME})
);

RAM RAM0
(
	.Clock(         clk        ),
	.iWriteEnable(  wWrEnableME ),
	.iAddress( 		wMemDirME ),
	.iDataIn(       wAluME[7:0]      ),
	.oDataOut(      wMemWB )
);

FFD # ( 4 ) EXME3 
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelAEX,wSelBEX}),
	.Q({wSelAME,wSelBME})
);


//WB

FFD # ( 9 ) MEMWB0 // Direcciones de salto incondicional y condicional
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wAluME}),
	.Q({wAluWB})
);

FFD # ( 4 ) MEWB1 
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelAME,wSelBME}),
	.Q({wSelAWB,wSelBWB})
);

endmodule
