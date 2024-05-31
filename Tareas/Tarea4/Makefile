# Compilador
CC = iverilog

# Sources
SOURCE = testbench.v

# Ejecutable
TARGET = out

# Regla de compilacion y ejecucion
all: $(SOURCE)
	$(CC) -o $(TARGET) $(SOURCE)
	vvp $(TARGET)
	gtkwave waveforms.gtkw

clean:
	rm out SPI_results.vcd

