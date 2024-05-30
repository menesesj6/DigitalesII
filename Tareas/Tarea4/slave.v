module SPISlave(
    input wire clk, rst, CKP, CPH, MOSI, SCK, SS,
    output reg MISO
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

quinto digito = 4
sexto digito = 2
*/
parameter sendData = 16'b00000100_00000010; // ox402
reg [15:0] rcvdData;

///////////////////////////////////////////////////////////////

// Memoria de estados y salidas
always @(posedge clk) begin
    if (!rst) begin
        state <= IDLE;
        bitCounter <= 0;
        MISO <= 0;
        rcvdData <= 0;
    end else begin
        state <= nextstate;
        // bitCounter <= nextbitCounter;
    end
end

// CASOS MODO 
always @(posedge SCK) begin
    if(CPH) begin
        rcvdData[bitCounter] <= MOSI;
        MISO <= sendData[bitCounter];
        bitCounter <= bitCounter + 1;    
    end
end

always @(negedge SCK) begin
    if(!CPH) begin
        rcvdData[bitCounter] <= MOSI;
        MISO <= sendData[bitCounter];
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
                bitCounter = 0;
                MISO = 0;
                rcvdData = 0;
                if (!SS) nextstate = TRANSACTION;
            end
        TRANSACTION:
            begin
                if (bitCounter >= 4'b1111 || SS) begin
                    nextstate = IDLE;
                end

            end
    endcase
end

endmodule