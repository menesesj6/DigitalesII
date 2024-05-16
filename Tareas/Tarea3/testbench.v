`include "atm.v"
`include "tester.v"

module testbench;

initial begin
    $dumpfile("resultados.vcd");
    $dumpvars;
end

wire clk, rst, card, trans, digitstb, amountstb, transactionstb;
wire [3:0] digit;
wire [15:0] pin;
wire [31:0] amount;

Tester tester(
    .clk(clk),
    .rst(rst),
    .insertCard(card),
    .transaction(trans),
    .enterDigit(digitstb),
    .enterAmount(amountstb),
    .inputDigit(digit),
    .cardPin(pin),
    .inputAmount(amount),
    .enterTrans(transactionstb)
);

ATM atm(
    .clock(clk),
    .reset(rst),
    .receivedCard(card),
    .transType(trans),
    .stbDigit(digitstb),
    .stbAmount(amountstb),
    .digit(digit),
    .pin(pin),
    .amount(amount),
    .stbTransaction(transactionstb)
);

endmodule