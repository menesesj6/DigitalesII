/*
Contenido: Modulo slave para protocolo SPI
Desarrollador: Jorge Meneses Garro
Tarea 4 - IE0523 Circuitos Digitales II

*/

module SPISlave(
    input wire clk, CKP, CPH, MOSI, SCK, SS,
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

Quinto digito = 4 = 00000100 = 0x04
Sexto digito = 2 = 00000010 = 0x02
*/
parameter sendData = 16'b00000100_00000010; // 0x0402
reg [15:0] rcvdData;

// Memoria de estados y salidas
always @(posedge clk) begin
    if (SS) begin
        state       <= IDLE;            // Resetear estado
        bitCounter  <= 0;               // Resetear el contador de indices
        MISO        <= 0;               // Salida en 0
        rcvdData    <= 0;               // Resetear registro de datos
    end else begin
        state <= nextstate;             // Actualizar estado
        bitCounter <= nextbitCounter;   // Actualizar contador de indices
    end
end

// CASOS MODE1 Y MODE3
always @(posedge SCK) begin
    if(CPH) begin
        rcvdData[bitCounter] <= MOSI;   // Guardar datos enviados del master por MOSI
        MISO <= sendData[bitCounter+1]; // Escribir en MISO
        bitCounter <= bitCounter + 1;   // Aumentar contador de indices  
    end 
end

// CASOS MODE0 Y MODE2
always @(negedge SCK) begin
    if(!CPH) begin
        rcvdData[bitCounter] <= MOSI;   // Guardar datos enviados del master por MOSI
        MISO <= sendData[bitCounter+1]; // Escribir en MISO
        bitCounter <= bitCounter + 1;   // Aumentar contador de indices  
    end
end

// Logica combinacional
always @(*)begin
    // Completar comportamiento FFs
    nextstate = state;
    nextbitCounter = bitCounter;
    case (state)
        IDLE:
            begin
                bitCounter = 0;                 // Reestablecer contador de indices en 0
                MISO = 0;                       // MISO inicial de 0
                rcvdData = 0;                   // Reestablecer registro de datos en 0

                // Iniciar 
                if (!SS) begin
                    nextstate = TRANSACTION;    // Cambiar estado
                    MISO = sendData[0];         // Pre-cargar el primer bit a comunicar para que sea detectable en el primer flanco
                end
            end
        TRANSACTION:
            begin
                // Cancelar transaccion si se apaga Chip Select
                if (SS) begin
                    nextstate = IDLE;           // Cambiar estado
                end

            end
    endcase
end

endmodule