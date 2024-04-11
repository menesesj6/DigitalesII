/* 
MOdulos probadores para el control automatizado de compuerta

Hecho por: Jorge Meneses Garro
Fecha de entrega: 13 de Abril de 2024
*/

module Tester1(
    password,
    asensor,
    lsensor,
    p_alarm,
    b_alarm,
    gate_open,
    gate_close,
    gate_block);

output reg asensor, lsensor;
output reg [7:0] password;
input wire p_alarm, b_alarm, gate_open, gate_close, gate_block;


initial begin
    password = 8'b00101010;
    asensor = 0;
    lsensor = 0;
    #40 asensor = 1;
    #40 asensor = 0;
    #40 lsensor = 1;
    #40 lsensor = 0;
    #100 $finish;
end

endmodule
