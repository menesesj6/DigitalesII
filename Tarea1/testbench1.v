module testbench1;

wire a_sensor, e_sensor, validation, 
    p_alarm, b_alarm, gate_open, 
    gate_close, gate_block;
wire [7:0] password;

initial begin
    $dumpfile("test1.vcd");
    $dumpvars;
    $monitor ("password = %b, sensorA = %b, sensorB = %b, open = %b, close = %b", password, a_sensor, e_sensor, gate_open, gate_close);
end

Tester1 tester1 (
    .password (password),
    .asensor (a_sensor),
    .lsensor (e_sensor),
    .p_alarm (p_alarm),
    .b_alarm (b_alarm),
    .gate_open (gate_open),
    .gate_close (gate_close),
    .gate_block (gate_block)
);

passwordVer P1 (
    .password (password),
    .arrivalSensor (a_sensor),
    .validity (validation),
    .alarm (p_alarm)
);

gateController G1 (
    .arrival_Sensor (a_sensor),
    .enterSensor (e_sensor),
    .passValid (validation),
    .block (gate_block),
    .blockAlarm (b_alarm),
    .gateOpen (gate_open),
    .gateClose (gate_close)
);

endmodule