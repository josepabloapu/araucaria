module uP
(
		input wire clk,
		input wire Reset
);

//Declaracion de las lineas que unen los modulos separadas por etapa.

		//IF
		wire [9:0] 	wPC, wPC_New, wPC_Next;
		wire 		wPC_Sel;
		wire [15:0] wInstIF;

		//ID
		wire [15:0] wInstID;
		wire [1:0] 	wSelAID, wSelBID;
		wire 		wSelM1ID, wSelM2ID, wWrEnableID, wJmpEnableID, wBranchEnableID;
		wire [7:0] 	wInmID;
		wire [9:0] 	wMemDirID;
		wire [6:0] 	wBranchDirID;
		wire [9:0] 	wBranchDirID_Def;
		wire [9:0] 	wJmpDirID;
		wire [5:0] 	wOpCodeID;
		wire [2:0] 	wFlagA, wFlagB;
		wire [7:0] 	wIn1, wIn2;
		
		//EX
		wire [5:0] 	wOpCodeEX;
		wire 		wSelM1EX, wSelM2EX;
		wire [7:0] 	wInmEX; 
		wire [9:0] 	wMemDirEX;
		wire [1:0] 	wSelAEX, wSelBEX;
		wire [7:0] 	wA, wB;
		wire 		wWrEnableEX;
		wire [8:0] 	wAluEX;
		
		//MEM
		wire [8:0] wAluME;
		wire [9:0] wMemDirME;
		wire [1:0] 	wSelAME, wSelBME;
		
		//WB
		wire [8:0] wAluWB;
		wire [7:0] wMemWB;
		wire [1:0] wSelAWB, wSelBWB;		
		

//-----IF-----//
//PC: Contador de programa, le indica a la memoria de instruccciones que instrucción leer.
FFD # ( 10 ) PC 			
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wPC_New),
	.Q(wPC)
);

//PC_Next: Se incrementa PC para leer la proxima instrucción en el siguiente ciclo.
assign  wPC_Next = wPC +1;

//Selector de proxima direccion: Cambia dependiendo si se ejecuta un JMP, BRANCH o ninguna instruccion de salto.
MUX4 # (10) MX0				
(
	.Select({wJmpEnableID,wBranchEnableID}),
	.In1(wPC_Next),
	.In2(wBranchDirID_Def),
	.In3(wJmpDirID),
	.In4(10'b0),	
	.Out(wPC_New)
);


//-----ID-----//
//Memoria de instrucciones, leer la instruccion en la posicion de memoria wPC.
ROM	IM0
(
	.Clock(clk),
	.Ip(wPC),
	.Instr(wInstIF)
);

//Decodificador de instrucciones: Genera las señales de control para las siguientes etapas
DECODEC ID0 
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

//Extension de signo y suma para los saltos relativos.
assign	wBranchDirID_Def = {wBranchDirID[6],wBranchDirID[6],wBranchDirID[6],wBranchDirID[6:0]} + wPC;


//-----EX-----//
//Registro de proposito general 1 / acomulador A.
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

//Registro de proposito general 2 / acomulador B.
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

//Valor inmediato
FFD # ( 8 ) INM	
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInmID),
	.Q(wInmEX)
);

//Registro de pipe ID/EX para señales de control
FFD # ( 23 ) IDEX
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelM1ID,wSelM2ID,wWrEnableID,wMemDirID,wOpCodeID,wSelAID,wSelBID}),
	.Q({wSelM1EX,wSelM2EX,wWrEnableEX,wMemDirEX,wOpCodeEX,wSelAEX,wSelBEX})
);

//Mux de seleccion de entradas 1 a la ALU.
MUX # (8) MX1
(
	.Select(wSelM1EX),
	.In1(wA),
	.In2(wInmEX),
	.Out(wIn1)
);

//Mux de seleccion de entradas 2 a la ALU.
MUX # (8) MX2
(
	.Select(wSelM2EX),
	.In1(wInmEX),
	.In2(wB),
	.Out(wIn2)
);

//Unidad Logico-Aritmetica.
ALU ALU0 
(
	.opcode(wOpCodeEX),
	.in1(wIn1),
	.in2(wIn2),
	.out(wAluEX)
);

//-----ME-----//
//Registro de pipe EX/ME para señales de control.
FFD # ( 15 ) EXME
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wMemDirEX,wWrEnableEX,wSelAEX,wSelBEX}),
	.Q({wMemDirME,wWrEnableME,wSelAME,wSelBME})
);

//Registro de salida de la ALU. (Mantiene un valor estable en la salida de la ALU).
FFD # ( 9 ) oALU_ME
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wAluEX),
	.Q(wAluME)
);

//Memoria de datos. Tambien funciona como el registro de pipe ME/WB para la salida de la memoria
RAM DM0
(
	.Clock(         clk        ),
	.iWriteEnable(  wWrEnableME ),
	.iAddress( 		wMemDirME ),
	.iDataIn(       wAluME[7:0]      ),
	.oDataOut(      wMemWB )
);


//-----WB-----//
//Registro de pipe ME/WB para la salida de la ALU
FFD # ( 9 ) oALU_WB
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wAluME}),
	.Q({wAluWB})
);

//Registro de pipe ME/WB para señales de control
FFD # ( 4 ) MEWB1
(
	.Clock(clk),
	.Reset(Reset),
	.Enable(1'b1),
	.D({wSelAME,wSelBME}),
	.Q({wSelAWB,wSelBWB})
);

endmodule
