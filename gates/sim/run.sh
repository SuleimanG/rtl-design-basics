iverilog -o sim.vvp ../rtl/nand.v ../tb/nand_tb.v
vvp sim.vvp
gtkwave nand.vcd
