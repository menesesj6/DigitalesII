cond:
	iverilog -o out testbenchCond.v
	vvp out
	gtkwave waveforms.gtkw

RTLIL: testbench.v RTLIL_controller.ys
	yosys -s RTLIL_controller.ys
	iverilog -o out testbench.v
	vvp out
	gtkwave waveforms.gtkw

CMOS: testbench.v CMOS_controller.ys
	yosys -s CMOS_controller.ys
	iverilog -o out testbench.v
	vvp out
	gtkwave waveforms.gtkw

CMOSDelay: testbenchCMOSDel.v CMOSDelay_controller.ys
	yosys -s CMOSDelay_controller.ys
	iverilog -o out testbenchCMOSDel.v
	vvp out
	gtkwave waveforms.gtkw

clean:
	rm *.vcd
	rm out
	rm controller_synth.v