# Tarea #2: Sintesis de controlador automatizado de un estacionamiento
## IE0523: Circuitos Digitales II

Este instructivo para la compilación y ejecución de los archivos en esta carpeta está enfocado hacia una terminal _bash_ de Linux.  A continuación se exponen las formas de compilar y ejecutar por medio de un Makefile al igual que de forma manual por medio de la terminal, desde la carpeta de nombre ***C14742***. 

## Instrucciones de compilacion y ejecucion por Makefile

### Sintesis y simulacion RTLIL
```
$ make RTLIL 
```
### Sintesis y simulacion CMOS
```
$ make CMOS
``` 

### Sintesis y simulacion CMOS con delays
```
$ make CMOSDelay
``` 
### Limpieza de archivos compilados y sintetizados
```
$ make clean
```
## Instrucciones de compilacion y ejecucion por comandos
### Sintesis y simulacion RTLIL
```
$ yosys -s RTLIL_controller.ys
$ iverilog -o out testbench.v
$ vvp out
$ gtkwave waveforms.gtkw
``` 

### Sintesis y simulacion CMOS
```
$ yosys -s CMOS_controller.ys
$ iverilog -o out testbench.v
$ vvp out
$ gtkwave waveforms.gtkw
``` 

### Sintesis y simulacion CMOS con delays
```
$ yosys -s CMOSDelay_controller.ys
$ iverilog -o out testbenchCMOSDel.v
$ vvp out
$ gtkwave waveforms.gtkw
``` 
### Limpieza de archivos compilados y sintetizados
```
$ rm *.vcd
$ rm out
$ rm controller_synth.v
```