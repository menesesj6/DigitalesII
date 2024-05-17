module Tester(
    // Salidas (Entradas ATM)
    output reg clk, rst,
    output reg insertCard, transaction,
    output reg enterDigit, enterAmount, enterTrans,
    output reg [3:0] inputDigit,
    output reg [15:0] cardPin,
    output reg [31:0] inputAmount,

    input wire bU, gM, iP, iF, w, b 
);

always begin
    // Cambios del clock
    #0.5 clk = ~clk;
end

initial begin
    /*
    ----------------------------- 
    Valor fijo
    -----------------------------
    */
    cardPin = 16'b1010_1010_0110_1001;

    /*
    ----------------------------- 
    Valores iniciales
    -----------------------------
    */
    inputAmount = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    clk = 0;
    insertCard = 0;
    transaction = 0;
    enterTrans = 0;
    enterAmount = 0;
    inputDigit = 4'b0000;
    enterDigit = 0;
    rst = 1;

    // Pulso en reset para estado inicial
    #0.5 rst = 0;
    #2 rst = 1;
    

    /*
    ----------------------------- 
    Primera prueba: Deposito
    -----------------------------
    */
    // Ingresar tarjeta
    insertCard = 1;

    // Primer digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito
    #10 inputDigit = 4'b0110;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito
    #10 inputDigit = 4'b1001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Establecer tipo de transaccion (deposito)
    #1 transaction = 0;
    enterTrans = 1;
    #3 enterTrans = 0;

    // Ingresar monto a depositar 
    #5 inputAmount = 32'b0001_0111_1111_1001_1011_1110_1101_0101;
    enterAmount = 1;
    #2 enterAmount = 0;

    // Sacar tarjeta
    #5 insertCard = 0;

    /*
    ----------------------------- 
    Segunda prueba: Retiro exitoso
    -----------------------------
    */
    // Ingresar tarjeta
    #20 insertCard = 1;

    // Primer digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito
    #10 inputDigit = 4'b0110;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito
    #10 inputDigit = 4'b1001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Establecer tipo de transaccion (retiro)
    #1 transaction = 1;
    enterTrans = 1;
    #3 enterTrans = 0;

    // Ingresar monto a depositar 
    #5 inputAmount = 32'b0001_0111_1111_1001_1011_1110_1101_0101;
    enterAmount = 1;
    #2 enterAmount = 0;

    // Sacar tarjeta
    #5 insertCard = 0;

    /*
    ----------------------------- 
    Tercera prueba: Retiro fallido
    -----------------------------
    */
    // Ingresar tarjeta
    #20 insertCard = 1;

    // Primer digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito
    #10 inputDigit = 4'b0110;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito
    #10 inputDigit = 4'b1001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Establecer tipo de transaccion (retiro)
    #1 transaction = 1;
    enterTrans = 1;
    #3 enterTrans = 0;

    // Ingresar monto a depositar 
    #5 inputAmount = 32'b1001_0111_1111_1001_1011_1110_1101_0101;
    enterAmount = 1;
    #2 enterAmount = 0;

    // Sacar tarjeta
    #5 insertCard = 0;

    /*
    ----------------------------- 
    Cuarta prueba: Pin incorrecto 2 veces
    -----------------------------
    */
    // Ingresar tarjeta
    #20 insertCard = 1;

    // Primer digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito
    #10 inputDigit = 4'b0110;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito
    #10 inputDigit = 4'b1011;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Primer digito segundo intento
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito segundo intento
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito segundo intento
    #10 inputDigit = 4'b0100;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito segundo intento
    #10 inputDigit = 4'b0001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Primer digito tercer intento
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito tercer intento
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito tercer intento
    #10 inputDigit = 4'b0110;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito tercer intento
    #10 inputDigit = 4'b1001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Establecer tipo de transaccion (deposito)
    #1 transaction = 0;
    enterTrans = 1;
    #3 enterTrans = 0;

    // Ingresar monto a depositar 
    #5 inputAmount = 32'b0001_0111_1111_1001_1011_1110_1101_0101;
    enterAmount = 1;
    #2 enterAmount = 0;

    // Sacar tarjeta
    #5 insertCard = 0;

    /*
    ----------------------------- 
    Quinta prueba: Pin incorrecto 3 veces
    -----------------------------
    */
    // Ingresar tarjeta
    #20 insertCard = 1;

    // Primer digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito
    #10 inputDigit = 4'b0110;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito
    #10 inputDigit = 4'b1011;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Primer digito segundo intento
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito segundo intento
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito segundo intento
    #10 inputDigit = 4'b0100;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito segundo intento
    #10 inputDigit = 4'b1001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Primer digito tercer intento
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito tercer intento
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito tercer intento
    #10 inputDigit = 4'b0100;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito tercer intento
    #10 inputDigit = 4'b1001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Establecer tipo de transaccion (deposito)
    #1 transaction = 0;
    enterTrans = 1;
    #3 enterTrans = 0;

    // Ingresar monto a depositar 
    #5 inputAmount = 32'b0001_0111_1111_1001_1011_1110_1101_0101;
    enterAmount = 1;
    #2 enterAmount = 0;

    // Primer digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito
    #10 inputDigit = 4'b0110;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito
    #10 inputDigit = 4'b1001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Resetear maquina
    #5 rst = 0;
    #5 rst = 1;

    // Primer digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Segundo digito
    #10 inputDigit = 4'b1010;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Tercer digito
    #10 inputDigit = 4'b0110;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Cuarto digito
    #10 inputDigit = 4'b1001;
    enterDigit = 1;
    #2 enterDigit = 0;

    // Establecer tipo de transaccion (deposito)
    #1 transaction = 0;
    enterTrans = 1;
    #3 enterTrans = 0;

    // Ingresar monto a depositar 
    #5 inputAmount = 32'b0001_0111_1111_1001_1011_1110_1101_0101;
    enterAmount = 1;
    #2 enterAmount = 0;

    // Sacar tarjeta
    #5 insertCard = 0;

    #50 $finish;

end

endmodule