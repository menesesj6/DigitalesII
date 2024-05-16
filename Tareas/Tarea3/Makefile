# Compilador
CC = iverilog

# Sources
SOURCE = testbench.v

# Ejecutable
TARGET = salida

# Script de sintesis
YSFILE = atm.ys

# Regla de compilacion y ejecucion
$(TARGET): $(SOURCE) $(YSFILE)
	yosys -s $(YSFILE)
	$(CC) -o $@ $(SOURCE)
	vvp $@
	gtkwave resultados.vcd
