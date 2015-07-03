PROG = tb

all: compile

compile:
	./assembler.py test.s test.bin	
	iverilog -o $(PROG).out $(PROG).v
	vvp $(PROG).out

view:
	gtkwave *.vcd

clean:
	rm -f *.vcd *.out
