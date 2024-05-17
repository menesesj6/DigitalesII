`include "atm_synth.v"
`include "cmos_cells.v"
`include "tester.v"

module testbench;

initial begin
    $dumpfile("results.vcd");
    $dumpvars;
end

wire clk, rst, receivedCard, transType, stbDigit, stbAmount, stbTransaction;
wire balanceUpdated, giveMoney, incorrectPin, insufficientFunds, warning, block;
wire [3:0] digit;
wire [15:0] pin;
wire [31:0] amount;

Tester tester(
    .clk(clk),
    .rst(rst),
    .insertCard(receivedCard),
    .transaction(transType),
    .enterDigit(stbDigit),
    .enterAmount(stbAmount),
    .inputDigit(digit),
    .cardPin(pin),
    .inputAmount(amount),
    .enterTrans(stbTransaction),

    .bU(balanceUpdated),
    .gM(giveMoney),
    .iP(incorrectPin),
    .iF(insufficientFunds),
    .w(warning),
    .b(block)
);

ATM atm(
    .clock(clk),
    .reset(rst),
    .receivedCard(receivedCard),
    .transType(transType),
    .stbDigit(stbDigit),
    .stbAmount(stbAmount),
    .digit(digit),
    .pin(pin),
    .amount(amount),
    .stbTransaction(stbTransaction),

    .balanceUpdated(balanceUpdated),
    .giveMoney(giveMoney),
    .incorrectPin(incorrectPin),
    .insufficientFunds(insufficientFunds),
    .warning(warning),
    .block(block)
);

endmodule