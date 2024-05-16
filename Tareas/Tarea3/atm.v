module ATM(
    // Entradas
    input wire clock, reset, 
    input wire receivedCard, transType,
    input wire stdDigit, stbAmount,
    input wire [3:0] digit,
    input wire [15:0]  pin,
    input wire [31:0] amount,
    
    // Salidas
    output reg balanceUpdated, giveMoney, incorrectPin, insufficientFunds, warning, block,
);

// Registros para el comportamiento de los FF (memoria de salidas)
reg next_balanceUpdated, next_giveMoney, next_incorrectPin, next_insufficientFunds, next_warning, next_block;

// Registro de balance de 64 bits
reg [63:0] balance = 64'b1001_0001_0111_1111_1001_1011_1110_1101_0101_1010_1101_1011_0110_1101_1111_1101 ;
// Registro con intentos de pin
reg [1:0] tries = 1'b11;

// Registro de estados y proximo estado
reg [7:0] state;
reg [7:0] next_state;

// Estados con codificacion One Hot
parameter idle = 8'b0000_0000; 
parameter cardDetected = 8'b0000_0001;
parameter gettingDigits = 8'b0000_0010;
parameter wrongPin = 8'b0000_0100;
parameter blockedSystem = 8'b0000_1000;
parameter correctPin = 8'b0001_0000;
parameter deposit = 8'b0010_0000;
parameter withdrawal = 8'b0100_0000;
parameter finalized = 8'b1000_0000;

// Memoria de estados y salidas con FFs
always @(posedge clock) begin
    if(reset) state <= idle;
    else begin
        state <= next_state;
        balanceUpdated <= next_balanceUpdated;
        giveMoney <= next_giveMoney;
        incorrectPin <= next_incorrectPin;
        insufficientFunds <= next_insufficientFunds;
        warning <= next_warning;
        block <= next_block;
    end
end

// Calculo de estados y salidas
always @(*) begin
    // Completar comportameinto de los FFs
    next_state = state;
    next_balanceUpdated = balanceUpdated;
    next_giveMoney = giveMoney;
    next_incorrectPin = incorrectPin;
    next_insufficientFunds = insufficientFunds;
    next_warning = warning;
    next_block = block;
    // ANalizar para cada estado
    case (state)
        idle:
        cardDetected:
        gettingDigits:
        wrongPin:
        blockedSystem:
        correctPin:
        deposit:
        withdrawal:
        finalized:
    endcase
end
endmodule