# Compilador
CC = iverilog

# Sources
SOURCE = testbench.v
SOURCE_SYNTH = testbench_synth.v

# Ejecutable
TARGET = salida

# Comandos Yosys
YSFILE = atm.ys

# Regla de compilacion y ejecucion
conductual: $(SOURCE) $(YSFILE)
	$(CC) -o $(TARGET) $(SOURCE)
	vvp $(TARGET)
	gtkwave waveforms.gtkw

structural: $(SOURCE) $(YSFILE)
	yosys -s $(YSFILE)
	$(CC) -o $(TARGET) $(SOURCE_SYNTH)
	vvp $(TARGET)
	gtkwave waveforms.gtkw

clean:
	rm atm_synth.v results.vcd salida

