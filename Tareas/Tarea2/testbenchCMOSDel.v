`timescale 1s/1ps
`include "controller_synth.v"
`include "cmos_delay_cells.v"
`include "tester.v"
// Definir el testbench
module testbench1;

// Cables de conexion entre modulos
wire arrive_sensor, leave_sensor, 
    pinAlarm, blockAlarm, gate_open, 
    gate_close, gate_block, enter, clk,
    rst;

// Net de 8 bits para la contrasena
wire [7:0] password;

// Dumps para el GTKWave
initial begin
    $dumpfile("sim.vcd");
    $dumpvars;
end

// Instanciar el probador
Tester t (
    .password (password),
    .asensor (arrive_sensor),
    .lsensor (leave_sensor),
    .p_alarm (pinAlarm),
    .b_alarm (blockAlarm),
    .gate_open (gate_open),
    .gate_close (gate_close),
    .gate_block (gate_block),
    .enter (enter),
    .clock (clk),
    .reset (rst)
);

// Instanciar el modulo de verificacion de contrasena 
controller C1 (
    .clock (clk),
    .reset (rst),
    .password (password),
    .arrSensor (arrive_sensor),
    .entSensor (leave_sensor),
    .enter (enter),
    .pinAlarm (pinAlarm),
    .blockAlarm (blockAlarm),
    .gateOpen (gate_open),
    .gateClose (gate_close),
    .gateBlock (gate_block)
);


endmodule