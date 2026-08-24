
//  if an async signal changes right at the flip-flop's clock edge, the flip-flop's output can go metastable.
//  to prevent this from happening, we can stack two flip-flops in series to give it time to resolve before anything downstream uses the signal.
//  the first FF might go metastable, but by the time the second FF samples it (one full clock period later), the first FF has almost certainly resolved to a stable 0 or 1 value.
//  This is called a synchronizer, and it is a common technique used in digital design to safely transfer signals between different clock domains.

module synchronizer(
    input  logic clk,
    input  logic rst_n,        //  active-low reset
    input  logic async_in,
    output logic sync_out   
);

    logic N1;   //  intermediate stage -- the "metastability catcher"

always_ff @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            begin
                N1 <= 1'b0;
            end
        else
            begin
                N1 <= async_in;
            end
    end

always_ff @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            begin
                sync_out <= 1'b0;
            end
        else
            begin
                sync_out <= N1;
            end
    end


endmodule
