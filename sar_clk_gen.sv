`timescale 1ns / 1ps

import parameters_pkg::*;

module sar_clk_gen
    #(
		parameter GHz_enable = 1
	)
    (
        input clk_external,
        input reset,
        input ready,
        input register_clk,
        output clk_sample,
        output clk_sar,
        //
        input clk_1GHz
    );

    localparam num_delay_ready = 4;
    localparam num_delay_clk_external = 2;
    localparam delay_unit = 0.416;

    wire clk_delay_xor;
    wire q_out;
    wire [num_delay_ready:0] ready_delay;
    wire clk_sample_mux1;
    wire [num_delay_clk_external:0] clk_external_delay;

    assign clk_external_delay[0] = clk_external;

    genvar i;
    generate;
    	if (GHz_enable == 0) begin
        	for (i=0; i<num_delay_clk_external; ++i) begin
            	time_delay  #(.delay (delay_unit))
	        	time_delay_inst (
                	.data_in		(clk_external_delay[i]),
                	.data_out		(clk_external_delay[i+1])
            	);
            end
        end else begin
            for (i=0; i<num_delay_clk_external+1; ++i) begin
            	sync_d_flip_flop sync_d_flip_flop_inst (
                	.data_in		(clk_external_delay[i]),
                    .clk            (clk_1GHz),
                	.data_out		(clk_external_delay[i+1])
            	);
            end
        end
    endgenerate

    xor_logic xor_logic_inst (
        .data1		(clk_external_delay[num_delay_clk_external]),
        .data2		(clk_external),
        .data_xor	(clk_delay_xor)
    );

    and_logic and_logic_inst (
        .data1		(clk_delay_xor),
        .data2		(clk_external),
        .data_and	(clk_sample)
    );

    d_flip_flop d_flip_flop_inst (
        .clk    (clk_sample),
        .d      (1'b1),
        .set    (ready_delay[4]),
        .reset  (ready_delay[2]),
        .q      (q_out)
    );

    assign ready_delay[0] = ready;
    genvar j;
    generate;
        for (j=0; j<num_delay_ready; ++j) begin
            time_delay  #(.delay (delay_unit))
	        time_delay_inst (
                .data_in		(ready_delay[j]),
                .data_out		(ready_delay[j+1])
            );
        end
    endgenerate

    mux_logic mux_logic_inst (
        .data1      (1'b0),
        .data2      (q_out),
        .sel        (clk_sample),
        .data_mux   (clk_sample_mux1)
    );

    mux_logic mux_logic_inst1 (
        .data1      (1'b0),
        .data2      (clk_sample_mux1),
        .sel        (register_clk),
        .data_mux   (clk_sar)
    );

endmodule
