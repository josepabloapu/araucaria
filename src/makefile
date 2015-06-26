PROG = waka

all: compile

compile:
	iverilog -o $(PROG).out $(PROG).v
	vvp $(PROG).out

view:
	gtkwave *.vcd

clean:
	rm -f *.vcd *.out
