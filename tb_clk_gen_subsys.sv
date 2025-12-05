`timescale 1ns / 1ps

import parameters_pkg::*;

module tb_clk_gen_subsys();

bit clk_external = 1'b0;
bit clk_external1 = 1'b0;
bit clk_ready = 1'b0;
bit clk_1GHz = 1'b0;
wire clk_sample;
bit ready = 1'b1;
bit register_clk = 1'b1;
bit reset = 1'b1;

bit [2:0] counter = 0; 

always #(CLK_PERIOD/2) clk_external = ~clk_external;
always clk_external1 =  #(CLK_PERIOD/2) ~clk_external1;

initial begin
    // #0.412;
    forever begin
        #(CLK_PERIOD1/2) clk_ready <= ~clk_ready;
    //    always clk_ready =  #(CLK_PERIOD1/2) ~clk_ready;
    end    
end

//wire clk6;
//assign clk6 = #2ns clk_ready;

always #(CLK_PERIOD2/2) clk_1GHz = ~clk_1GHz;

typedef enum reg [1:0] {IDLE, COMPARE} statetype;
statetype state, next_state;

initial begin
    #4.165 reset = 1'b0;
end

// FSM processing
always_comb 
    if (reset) state = IDLE;
    else state = next_state;


always_comb begin
	case (state)
	    IDLE 	    :   if (clk_external & !clk_sample)
                            next_state = COMPARE;
	    		        else
                            next_state = IDLE;
        // COMPARE     :   //if (clk_ready)
        //                     next_state = COMPARE1;
		COMPARE		:	if (counter == num_bits)
                            next_state = IDLE;
	endcase
end

always_comb begin
	case (state)
	    IDLE	: begin
            ready = 1'b1;
            if (clk_external & clk_sample)
                register_clk = 1'b0;
            else
                register_clk = 1'b1;
	    end
        // COMPARE     : begin
        //     ready = 1'b0;
        //     if (clk_ready)
        //         #CLK_PERIOD1;
        // end
	    COMPARE	: begin
            register_clk = 1'b0;
            ready = clk_ready;
        end 
	endcase
end

always_ff @(posedge clk_ready) begin
    if (state == COMPARE)
        counter = counter + 1;
    else if (state == IDLE) begin
        counter = 0;
    end
    
end


sar_clk_gen  #(.GHz_enable(0))
sar_clk_gen_inst (
    .clk_external   (clk_external),
    .clk_1GHz       (clk_1GHz),
    .clk_sample     (clk_sample),
    .register_clk   (register_clk),
    .ready          (ready)
);


endmodule
