	//Prog 1: Suma al numero $1A el numero 2C de forma iterativa.
	0: instr = {`NOP,  10'h0}
	1: instr = {`LDCA, 2'b0, 8'h1A}	//Carga $1A al acomulador A
	2: instr = {`LDCB, 2'b0, 8'h2C}	//Carga $2C al acomulador B

	3: instr = {`ADDA, 10'h00}	//Suma A con B y el resultado lo guarda en A
	4: instr = {`STA,  10'h100}	//Escribe el contenido del acomulador A en la posicion de memoria $100 (64).
	5: instr = {`JMP,  4'b0, 6'd3}  //Salta ala cuerta instruccion y vuelve a sumar A con B.