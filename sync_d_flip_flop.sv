`timescale 1ns / 1ps

module sync_d_flip_flop
    (
        input clk,
        input data_in,
        output bit data_out
    );

    always_ff @(posedge clk)
    begin
        data_out <= data_in;
    end
    
endmodule
