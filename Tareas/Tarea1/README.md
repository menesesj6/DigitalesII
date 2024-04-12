# Tarea #1: Controlador automatizado de un estacionamiento
## IE0523: Circuitos Digitales II

Este instructivo para la compilación y ejecución de los archivos en esta carpeta está enfocado hacia una terminal _bash_ de Linux.  A continuación se exponen las formas de compilar y ejecutar por medio de un Makefile al igual que de forma manual por medio de la terminal, desde la carpeta de nombre ***C14742***.

## Instrucciones de compilacion y ejecucion

### Makefile
```
$ make tarea1 # Compilacion y ejecucion
``` 

### Comandos
```
$ iverilog -o simulacion.vvp testbench.v
$ vvp simulacion.vvp
$ gtkwave simulacion.vcd
``` 
