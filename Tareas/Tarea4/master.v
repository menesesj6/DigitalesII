module SPIMaster(
    input wire transaction_stb, clk, rst, CKP, CPH, MISO,
    output reg MOSI, CS, SCK
);

// Variables intermedias
reg [1:0] state;
reg [1:0] nextstate;

reg [3:0] bitCounter;
reg [3:0] nextbitCounter;

// Estados codificados One Hot
parameter IDLE = 2'b01;
parameter TRANSACTION = 2'b10;

/* 
----------------------
Valores de transaccion
----------------------

Carne: C14742

tercer digito = 4
cuarto digito = 7
*/
parameter sendData = 16'b00000100_00000111; // 0x407
reg [15:0] rcvdData;

// Divisor de frecuencia para SCK
reg [2:0] clockCounter;

///////////////////////////////////////////////////////////////

// Memoria de estados y salidas
always @(posedge clk) begin
    if (!rst) begin
        state <= IDLE;
        CS <= 1;
        bitCounter <= 0;
        clockCounter <= 0;
        MOSI <= 0;
        rcvdData <= 0;
        if (CKP) SCK = 1;
        else SCK = 0;
    end else begin
        state <= nextstate;
        // bitCounter <= nextbitCounter;
        if (state != IDLE) begin
            clockCounter <= clockCounter + 1;
            SCK <= clockCounter[2];
        end
    end
end

// CASOS MODO 
always @(posedge SCK) begin
    if(CPH) begin
        rcvdData[bitCounter] <= MISO;
        MOSI <= sendData[bitCounter];
        bitCounter <= bitCounter + 1;  
    end
end

always @(negedge SCK) begin
    if(!CPH) begin
        rcvdData[bitCounter] <= MISO;
        MOSI <= sendData[bitCounter];
        bitCounter <= bitCounter + 1;  
    end
end

// Logica combinacional
always @(*)begin
    nextstate = state;
    nextbitCounter = bitCounter;
    case (state)
        IDLE:
            begin
                CS = 1;
                bitCounter = 0;
                clockCounter = 0;
                MOSI = 0;
                rcvdData = 0;
                if (CKP) SCK = 1;
                else SCK = 0;
                if(transaction_stb) begin
                    CS = 0;
                    nextstate = TRANSACTION;
                end
            end
        TRANSACTION:
            begin
                CS = 0;
                if (bitCounter == 4'b1111) begin
                    nextstate = IDLE;
                    CS = 1;
                end
            end
    endcase
end

endmodule