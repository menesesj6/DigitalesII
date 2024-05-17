/* Controlador de ATM

Hecho por: Jorge Meneses Garro C14742
Fecha: 18 de Mayo de 2024

*/

module ATM(
    // Entradas
    input wire clock, reset, 
    input wire receivedCard, transType,
    input wire stbDigit, stbAmount, stbTransaction,
    input wire [3:0] digit,
    input wire [15:0]  pin,
    input wire [31:0] amount,
    
    // Salidas
    output reg balanceUpdated, giveMoney, incorrectPin, insufficientFunds, warning, block
);

// Registros para el comportamiento de los FF (memoria de salidas)
reg next_balanceUpdated, next_giveMoney, next_incorrectPin, next_insufficientFunds, next_warning, next_block;

// Registro de balance de 64 bits
reg [63:0] balance;
reg [63:0] next_balance;

// Registro con intentos de pin
reg [1:0] tries;
reg [1:0] next_tries;

// Registro de estados y proximo estado
reg [6:0] state;
reg [6:0] next_state;

// Registros de los digitos ingresados
reg [2:0] digitCount;
reg [3:0] firstDigit;
reg [3:0] secondDigit;
reg [3:0] thirdDigit;
reg [3:0] fourthDigit;

reg [2:0] next_digitCount;
reg [3:0] next_firstDigit;
reg [3:0] next_secondDigit;
reg [3:0] next_thirdDigit;
reg [3:0] next_fourthDigit;

// Estados con codificacion One Hot
parameter idle = 7'b0000_000; 
parameter cardDetected = 7'b0000_001;
parameter wrongPin = 7'b0000_010;
parameter blockedSystem = 7'b0000_100;
parameter correctPin = 7'b0001_000;
parameter deposit = 7'b0010_000;
parameter withdrawal = 7'b0100_000;
parameter finalized = 7'b1000_000;

// Memoria de estados y salidas con FFs
always @(posedge clock) begin
    if(~reset || ~receivedCard) begin
        state <= idle;
        tries <= 2'b00;
        digitCount <= 3'b000;
        balance <= 64'b0000_0000_0000_0000_0000_0000_0000_0000_0101_1010_1101_1011_0110_1101_1111_1101;
    end else begin
        // Pasar proximo estado
        state <= next_state;

        // Pasar salidas
        balanceUpdated <= next_balanceUpdated;
        giveMoney <= next_giveMoney;
        incorrectPin <= next_incorrectPin;
        insufficientFunds <= next_insufficientFunds;
        warning <= next_warning;
        block <= next_block;

        // Pasar cambios de registros
        tries <= next_tries;
        balance <= next_balance;
        digitCount <= next_digitCount;

        // Mantener los digitos
        firstDigit <=  next_firstDigit;
        secondDigit <= next_secondDigit;
        thirdDigit <= next_thirdDigit;
        fourthDigit <= next_fourthDigit;
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
    next_tries = tries;
    next_balance = balance;
    next_digitCount = digitCount;
    next_firstDigit = firstDigit;
    next_secondDigit = secondDigit;
    next_thirdDigit = thirdDigit;
    next_fourthDigit = fourthDigit;
    // ANalizar para cada estado
    case (state)
        // ESperando tarjeta
        idle: 
            begin
                // Establecer salidas en cero
                next_balanceUpdated = 0;
                next_giveMoney = 0;
                next_incorrectPin = 0;
                next_insufficientFunds = 0;
                next_warning = 0;
                next_block = 0;
                // Caso donde se detecta tarjeta
                if(receivedCard) begin
                    next_state = cardDetected;
                    next_digitCount = 3'b001;
                end
            end

        // Tarjeta detectada
        cardDetected:
            begin
                if(digitCount >= 3'b101)begin
                    next_digitCount = 3'b001;
                    if(pin[15:12] == firstDigit && pin[11:8] == secondDigit && pin[7:4] == thirdDigit && pin[3:0] == fourthDigit) begin
                        next_state = correctPin;
                        next_incorrectPin = 0;
                        next_warning = 0;
                        next_block = 0;
                    end else next_state = wrongPin; 
                end else begin
                    if (stbDigit && digitCount == 3'b001) begin
                        next_firstDigit = digit;
                        next_digitCount = digitCount + 3'b001;
                    end else if (stbDigit && digitCount == 3'b010) begin
                        next_secondDigit = digit;
                        next_digitCount = digitCount + 3'b001;
                    end else if (stbDigit && digitCount == 3'b011) begin
                        next_thirdDigit = digit;
                        next_digitCount = digitCount + 3'b001;
                    end else if (stbDigit && digitCount == 3'b100) begin
                        next_fourthDigit = digit;
                        next_digitCount = digitCount + 3'b001;
                    end
                end
            end

        // Pin erroneo
        wrongPin:
            begin
                next_tries = tries + 2'b01;
                if(tries == 2'b11) begin
                    next_block = 1;
                    next_state = blockedSystem;
                end else if (tries == 2'b10) begin
                    next_warning = 1;
                    next_state = cardDetected;
                end else if (tries == 2'b01) begin
                    next_incorrectPin = 1;
                    next_state = cardDetected;
                end
            end

        // Sistema bloqueado
        blockedSystem:
            begin
            end
            
        // Pin correcto
        correctPin:
            begin
                if(transType && stbTransaction) next_state = withdrawal;
                else if (~transType && stbTransaction) next_state = deposit;
            end

        // Deposito de dnero
        deposit:
            begin
                if(stbAmount) begin
                    next_balance = balance + amount;
                    next_balanceUpdated = 1;
                    next_state = finalized;
                end
            end
        // Retiro de dinero
        withdrawal:
            begin
                if(stbAmount)begin
                    if(balance < amount) begin
                        next_insufficientFunds = 1;
                        next_state = finalized;
                    end else begin
                        next_balance = balance - amount;
                        next_giveMoney = 1;
                        next_balanceUpdated = 1;
                        next_state = finalized;
                    end
                end 
            end

        // Transaccion finalizada
        finalized:
            begin
                next_balanceUpdated = 0;
                if(receivedCard) next_state = cardDetected;
                else next_state = idle;
            end
    endcase
end
endmodule