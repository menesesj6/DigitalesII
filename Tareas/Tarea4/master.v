/*
Contenido: Modulo master para protocolo SPI
Desarrollador: Jorge Meneses Garro
Tarea 4 - IE0523 Circuitos Digitales II

*/

module SPIMaster(
    // Inputs
    input wire transaction_stb, clk, rst, CKP, CPH, MISO,
    // Outputs
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

Tercer digito = 4 = 00000100 = 0x04
Cuarto digito = 7 = 00000111 = 0x07
*/
parameter sendData = 16'b00000100_00000111; // 0x0407

// Registro de datos recibidos
reg [15:0] rcvdData;

// Contador para generar SCK
reg [2:0] clockCounter;


// Memoria de estados y salidas
always @(posedge clk) begin
    if (!rst) begin
        state        <= IDLE;      // Resetear estado
        CS           <= 1;         // Apagar chip select
        bitCounter   <= 0;         // Resetear el contador de indices
        clockCounter <= 0;         // Resetear contador de SCK
        MOSI         <= 0;         // Salida en 0
        rcvdData     <= 0;         // Resetear registro de datos
        
        // Valor de SCK en IDLE
        if (CKP) SCK = 1;
        else SCK = 0;
    end else begin
        state      <= nextstate;        // Actualizar estado
        bitCounter <= nextbitCounter;   // Actualizar contador de indices
        
        // Generar SCK solo si no se esta en IDLE
        if (state != IDLE) begin
            clockCounter <= clockCounter + 1;
            SCK <= clockCounter[2];
        end
    end
end

// CASOS MODE1 Y MODE3
always @(posedge SCK) begin
    if(CPH) begin
        rcvdData[bitCounter] <= MISO;       // Guardar datos enviados del slave por MISO
        MOSI <= sendData[bitCounter+1];     // Escribir en MOSI
        bitCounter <= bitCounter + 1;       // Aumentar contador de indices
    end
end

// CASOS MODE0 Y MODE2
always @(negedge SCK) begin
    if(!CPH) begin
        rcvdData[bitCounter] <= MISO;       // Guardar datos enviados del slave por MISO
        MOSI <= sendData[bitCounter+1];     // Escribir en MOSI
        bitCounter <= bitCounter + 1;       // Aumentar contador de indices
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
                CS = 1;                         // Chip select desactivado si master en IDLE
                bitCounter = 0;                 // Reestablecer contador de indices en 0
                clockCounter = 0;               // Reestablecer contador para SCK
                MOSI = 0;                       // MOSI inicial de 0
                rcvdData = 0;                   // Reestablecer registro de datos en 0

                // Fijar SCK segun CKP
                if (CKP) SCK = 1;
                else SCK = 0;
                if(transaction_stb) begin
                    CS = 0;                     // Activar la comunicacion por chip select
                    nextstate = TRANSACTION;    // Cambiar estado
                    MOSI = sendData[0];         // Pre-cargar el primer bit a comunicar para que sea detectable en el primer flanco
                end
            end
        TRANSACTION:
            begin
                CS = 0;                         // Mantener slaves activos

                // Acabar transaccion cuando se comunicaron todos los indices de los datos a comunicar
                if (bitCounter == 4'b1111) begin
                    nextstate = IDLE;
                    CS = 1;
                end
            end
    endcase
end

endmodule