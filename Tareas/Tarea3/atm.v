module ATM(
    // Entradas
    input wire clock, reset, 
    input wire receivedCard, transType,
    input wire stbDigit, stbAmount,
    input wire [3:0] digit,
    input wire [15:0]  pin,
    input wire [31:0] amount,
    
    // Salidas
    output reg balanceUpdated, giveMoney, incorrectPin, insufficientFunds, warning, block,
);

// Registros para el comportamiento de los FF (memoria de salidas)
reg next_balanceUpdated, next_giveMoney, next_incorrectPin, next_insufficientFunds, next_warning, next_block;

// Registro de balance de 64 bits
reg [63:0] balance = 64'b1001_0001_0111_1111_1001_1011_1110_1101_0101_1010_1101_1011_0110_1101_1111_1101;
reg [63:0] next_balance;

// Registro con intentos de pin
reg [1:0] tries = 2'b11;
reg [1:0] next_tries;

// Registro de estados y proximo estado
reg [7:0] state;
reg [7:0] next_state;

// Registros de los digitos ingresados
reg [2:0] digitCount = 3'b001;
reg [2:0] next_digitCount;
reg [3:0] firstDigit;
reg [3:0] secondDigit;
reg [3:0] thirdDigit;
reg [3:0] fourthDigit;

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
    if(~reset) begin
        state <= idle;
        tries <= 2'b11;
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
                if(receivedCard) next_state = cardDetected;
            end

        // Tarjeta detectada
        cardDetected:
            begin
                if(digitCount >= 3'b101)begin
                    digitCount = 3'b001;
                    if(pin[15:12] == firstDigit && pin[11:8] == secondDigit && pin[7:4] == thirdDigit && pin[3:0] == fourthDigit)
                        next_state = correctPin;
                    else next_state = wrongPin; 
                end else begin
                    if (stbDigit && digitCount == 3'b001) begin
                        firstDigit = digit;
                        next_digitCount = digitCount + 3'b001;
                    end else if (stbDigit && digitCount == 3'b010) begin
                        secondDigit = digit;
                        next_digitCount = digitCount + 3'b001;
                    end else if (stbDigit && digitCount == 3'b011) begin
                        thirdDigit = digit;
                        next_digitCount = digitCount + 3'b001;
                    end else if (stbDigit && digitCount == 3'b100) begin
                        fourthDigit = digit;
                        next_digitCount = digitCount + 3'b001;
                    end
                end
            end

        // Pin erroneo
        wrongPin:
            begin
                next_tries = tries - 2'b01;
                if(tries == 2'b00) begin
                    next_block = 1;
                    next_state = blockedSystem;
                end else if (tries == 2'b01) begin
                    next_incorrectPin = 1;
                    next_state = cardDetected;
                end else if (tries == 2'b10) begin
                    next_warning = 1;
                    next_state = cardDetected;
                end
            end

        // Sistema bloqueado
        blockedSystem:

        // Pin correcto
        correctPin:
            if(transType) next_state = withdrawal;
            else next_state = deposit;

        // Deposito de dnero
        deposit:
            begin
                if(stbAmount) begin
                    next_balancebalance = balance + amount;
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
                if(receivedCard) next_state = correctPin;
                else next_state = idle;
            end
    endcase
end
endmodule