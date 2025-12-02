`timescale 1ns / 1ps

module d_flip_flop
    (
        input clk,
        input d,
        input set,
        input reset,
        output bit q
    );

    always_ff @ (posedge clk or negedge set or negedge reset)
    begin
        if (!set)
            q <= 1'b1;
        else if (!reset)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule
