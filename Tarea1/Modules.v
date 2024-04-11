/* 
Modulos para controlador automatizado de compuerta

Hecho por: Jorge Meneses Garro
Fecha de entrega: 13 de Abril de 2024
*/

// Modulo de verificacion de contrasena
module passwordVer(
    password,
    arrivalSensor, 
    alarm, 
    validity
    ); 
input wire [7:0] password;

input arrivalSensor;
output alarm,  validity;

wire arrivalSensor;
reg alarm, validity;

// Contrasena esperada, carne: C14742
parameter rightPass = 8'b00101010; 
integer counter = 0; // Contador para saber cuantos fallos se han tenido

always @(*) begin// Funciona solo si hay un carro
    if (arrivalSensor == 0)begin
        validity = 0;
        alarm = 0;
    end
    if (password == rightPass) begin
        validity = 1; // Se envia que todo bien al controlador de la compuerta
        alarm = 0; // NO se activa la alarma de pin incorrecto
        counter = 0; // Se reinicia el contador
    end else if (password != rightPass) begin
        validity = 0;
        counter += 1; // Si se falla, sumar un intento fallido al contador
    end

    if (counter == 3'b100) begin
        validity = 0; // Senal en bajo al controlador de la compuerta
        alarm = 1; // Activa la alarma
        counter = 0; // Se reinicia el contador de intentos fallidos
    end 
end
endmodule

////////////////////////////////////////////////////////////////////////

module gateController(
    arrival_Sensor,
    enterSensor,
    passValid,
    gateOpen,
    gateClose, 
    block, 
    blockAlarm
    );

input arrival_Sensor, enterSensor, passValid;
output gateOpen, gateClose, block, blockAlarm;

wire arrival_Sensor, enterSensor, passValid;
reg gateOpen, gateClose, block, blockAlarm;

always @(*) begin
    if(passValid == 1) begin
        gateOpen = 1;
        gateClose = 0;
        if(arrival_Sensor == 1 && enterSensor == 1) begin
            block = 1;
            blockAlarm = 1;
        end else if(enterSensor == 1 && arrival_Sensor == 0) begin
            gateClose = 1;
            gateOpen = 0;
            block = 0;
            blockAlarm = 0;
        end
    end 
    else begin
        gateClose = 1;
        gateOpen = 0;
        block = 0;
        blockAlarm = 0;
    end

end
endmodule

////////////////////////////////////////////////////////////////////////

