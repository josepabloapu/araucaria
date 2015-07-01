//~ `include "def.v"
//~ `include "alu.v"
//~ `include "decodec.v"
//~ `include "aux.v"
//~ `include "rom.v"

module uP
(
input wire Clock,
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
		wire [1:0] 	wSelAWB;
		wire [1:0]	wSelBWB;		
		

//IF
FFD_POSEDGE_SYNCRONOUS_RESET # ( 10 ) PC 
(
	.Clock(Clock),
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

ROM	ROM0
(
	.clk(Clock),
	.pc(wPC),
	.instr(wInstIF)
);

//ID

FFD_POSEDGE_SYNCRONOUS_RESET # ( 16 ) IFID0 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstIF),
	.Q(wInstID)
);


decodec ID0 
(
	.clk(Clock),
	.reset(Reset),

	.in(wInstID),

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
	.Clock(Clock),
	.Select(wSelAWB),
	.iInm(wAluWB[7:0]),
	.iAlu(wAluWB),
	.iMem(wMemWB),
	.oRPG(wA),
	.oFlags(wFlagA)
);

RPG # (8) B
(
	.Clock(Clock),
	.Select(wSelBWB),
	.iInm(wAluWB[7:0]),
	.iAlu(wAluWB),
	.iMem(wMemWB),
	.oRPG(wB),
	.oFlags(wFlagB)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) IDEX0	//Valor inmediato
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInmID),
	.Q(wInmEX)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 2 ) IDEX1	//Lineas de seleccion de mux 1 y 2 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelM1ID,wSelM2ID}),
	.Q({wSelM1EX,wSelM2EX})
);


FFD_POSEDGE_SYNCRONOUS_RESET # ( 3 ) IDEX2 // Write enable de la memoria, Jump enable y branch enable
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wWrEnableID,wJmpEnableID,wBranchEnableID}),
	.Q({wWrEnableEX,wJmpEnableEX,wBranchEnableEX})
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 26 ) IDEX3 // Direcciones de salto incondicional y condicional
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wJmpDirID,wBranchDirID,wMemDirID}),
	.Q({wJmpDirEX,wBranchDirEX,wMemDirEX})
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 6 ) IDEX4 // Direcciones de salto incondicional y condicional
(
	.Clock(Clock),
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


alu A0 
(
	.opcode(wOpCodeEX),
	.in1(wIn1),
	.in2(wIn2),
	.out(wAluEX)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) IDEX5 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelAID,wSelBID}),
	.Q({wSelAEX,wSelBEX})
);

//ME

FFD_POSEDGE_SYNCRONOUS_RESET # ( 10 ) EXME0 // Direcciones de salto incondicional y condicional
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wMemDirEX}),
	.Q({wMemDirME})
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 9 ) EXME1 // Direcciones de salto incondicional y condicional
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wAluEX}),
	.Q({wAluME})
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) EXME2 // Direcciones de salto incondicional y condicional
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wWritEnableEX}),
	.Q({wWritEnableME})
);

RAM_SINGLE_READ_PORT RAM0
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iAddress( 		wMemDirME ),
	.iDataIn(       wAluME[7:0]      ),
	.oDataOut(      wMemWB )
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) EXME3 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelAEX,wSelBEX}),
	.Q({wSelAME,wSelBME})
);


//WB

FFD_POSEDGE_SYNCRONOUS_RESET # ( 9 ) MEMWB0 // Direcciones de salto incondicional y condicional
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wAluME}),
	.Q({wAluWB})
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) MEWB1 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelAME,wSelBME}),
	.Q({wSelAWB,wSelBWB})
);

endmodule
