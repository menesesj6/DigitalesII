`include "tester.v" 
`include "master.v"
`include "slave.v"

module tb;

wire CLK, RST, TRANS_STB, MISO, MOSI, MOSISlave, MOSISlave2, CS, SCK, CKP, CPH;

initial begin
    // Arhivo vcd para GTKWave
    $dumpfile("SPI_results.vcd");
    // Definir variables a mostrar en GTKWave
    $dumpvars(0, tb);
end

Tester tester(
    // Estimulos al SPI
    .CLOCK(CLK),
    .RESET(RST),
    .CKP(CKP),
    .CPH(CPH),
    .START(TRANS_STB) // ENTER: Banderazo de salida de transaccion
);

SPIMaster transmisor(
    // Inputs
    .clk(CLK),
    .rst(RST),
    .transaction_stb(TRANS_STB),
    .CKP(CKP),
    .CPH(CPH),
    .MISO(MISO),
    // Outputs
    .MOSI(MOSI),
    .CS(CS),
    .SCK(SCK)
);

SPISlave receptor1(
    // Inputs
    .clk(CLK),
    .CKP(CKP),
    .CPH(CPH),
    .MOSI(MOSI),
    .SCK(SCK),
    .SS(CS),
    // Outputs
    .MISO(MOSISlave)
);

SPISlave receptor2(
    // Inputs
    .clk(CLK),
    .CKP(CKP),
    .CPH(CPH),
    .MOSI(MOSISlave),
    .SCK(SCK),
    .SS(CS),
    // Outputs
    .MISO(MOSISlave2)
);

SPISlave receptor3(
    // Inputs
    .clk(CLK),
    .CKP(CKP),
    .CPH(CPH),
    .MOSI(MOSISlave2),
    .SCK(SCK),
    .SS(CS),
    // Outputs
    .MISO(MISO)
);

endmodule
