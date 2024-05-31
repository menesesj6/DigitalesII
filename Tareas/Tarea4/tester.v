/*
Contenido: Modulo tester para probar el protocolo SPI
Desarrollador: Jorge Meneses Garro
Tarea 4 - IE0523 Circuitos Digitales II

*/

module Tester(
    output reg CLOCK, RESET, CKP, CPH, START
);

always begin
    // Cambios del clock
    #1 CLOCK = ~CLOCK;
end

initial begin
    // Valores iniciales
    START = 0;
    CLOCK = 1;
    RESET = 0;

    /*
    ----------------------
    PRIMERA PRUEBA: MODO 0
    ----------------------
    */

    CKP = 0;
    CPH = 0;
    #3 RESET = 1;
    #10 START = 1;
    #5 START = 0;

    /*
    ----------------------
    SEGUNDA PRUEBA: MODO 1
    ----------------------
    */
    #300 CKP = 0;
    CPH = 1;
    #3 RESET = 1;
    #10 START = 1;
    #5 START = 0; 

    /*
    ----------------------
    TERCERA PRUEBA: MODO 2
    ----------------------
    */
    #300 CKP = 1;
    CPH = 0;
    #3 RESET = 1;
    #50 START = 1;
    #5 START = 0; 

    /*
    ----------------------
    CUARTA PRUEBA: MODO 3
    ----------------------
    */
    #300 CKP = 1;
    CPH = 1;
    #3 RESET = 1;
    #10 START = 1;
    #5 START = 0;

    /*
    --------------------------
    QUINTA PRUEBA: INTERRUMPIR
    --------------------------
    */
    #300 CKP = 0;
    CPH = 0;
    #3 RESET = 1;
    #10 START = 1;
    #5 START = 0;
    #100 RESET = 0;
    #10 RESET = 1;
    #50 $finish; 
end

endmodule