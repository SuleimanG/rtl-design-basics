`timescale 1ns/1ps

module nand_tb;

reg a, b;
wire y;

nand_gate uut (.y(y), .a(a), .b(b));

initial begin
    $dumpfile("nand.vcd");
    $dumpvars(0, nand_tb);

    a = 0; b = 0;
    #10 a = 0; b = 1;
    #10 a = 1; b = 0;
    #10 a = 1; b = 1;
    #10 $finish;
end

endmodule
