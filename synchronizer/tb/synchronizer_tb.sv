

// Strategy:
// 1. Derive async_in at times NOT aligned to clk edges.
// 2. Run a reference model of the synchronizer in parallel with the DUT.

`timescale 1ns/1ps

module synchronizer_tb;

    logic clk;
    logic rst_n;
    logic async_in;
    logic sync_out;

    // Instantiate the DUT
    synchronizer dut (
        .clk(clk),
        .rst_n(rst_n),
        .async_in(async_in),
        .sync_out(sync_out)
    );

    // Clock generation
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Reference model for comparison
    logic ref_stage1, ref_sync_out;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ref_stage1 <= 1'b0;
            ref_sync_out <= 1'b0;
        end else begin
            ref_stage1 <= async_in;
            ref_sync_out <= ref_stage1;
        end
    end

    // Scoreboard / checker

    int unsigned checks = 0;
    int unsigned mismatch = 0;

    always @(posedge clk) begin
        #1; // Wait for a clock cycle to allow DUT to update
        checks++;
        if (sync_out !== ref_sync_out) begin
            mismatch++;
            $display("Mismatch at time %0t: DUT sync_out = %b, Reference sync_out = %b", $time, sync_out, ref_sync_out);
        end
    end

    // Directed check #1: sync_out must be a clean 0 right after reset, not X

    task automatic check_reset_value();
        if (sync_out !== 1'b0) begin
            mismatch++;
            $display("[%0t] Reset check failed: sync_out = %b, expected 0", $time, sync_out);
        end else begin
            $display("[%0t] Reset check passed: sync_out = %b", $time, sync_out);
        end
    endtask

    // Testbench stimulus
    initial begin
        // Initialize signals
        rst_n = 0;
        async_in = 0;

        // Hold reset for a few clock cycles
        repeat (3) @(negedge clk);
        rst_n = 1; // Release reset

        @(posedge clk); //  wait for one rising edge
        #2; // Wait a bit to ensure reset propagation
        check_reset_value(); // Check that sync_out is 0 after reset

        // clock domain crossing test

        repeat(60) begin
            #($urandom_range(1, 9)); // Random delay between 1 and 9 time units

            async_in = ~async_in; // flip the input
        end

        repeat(4) @(posedge clk);

        // Final report
        $display("--------------------------------------------------");
        if (mismatch == 0)
            $display("TEST PASSED: %0d checks, 0 mismatches", checks);
        else
            $display("TEST FAILED: %0d checks, %0d mismatches", checks, mismatch);
        $display("--------------------------------------------------");
 
        $finish; 
    end


    initial begin
        $dumpfile("synchronizer_tb.vcd");
        $dumpvars(0, synchronizer_tb);
    end
endmodule
