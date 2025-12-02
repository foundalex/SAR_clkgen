`timescale 1ns / 1ps


module tb_clk_gen_subsys(
    );


localparam CLK_PERIOD = 24ns; 
localparam CLK_PERIOD1 = 4ns;
localparam num_bits = 4;

bit clk_external = 1'b0;
bit clk_ready = 1'b1;
wire clk_sample;
bit ready = 1'b1;
bit register_clk = 1'b1;
bit reset = 1'b1;

bit [2:0] counter = 0; 

always #(CLK_PERIOD/2) clk_external = ~clk_external;

always #(CLK_PERIOD1/2) clk_ready = ~clk_ready;


typedef enum reg [1:0] {IDLE, COMPARE} statetype;
statetype state;

initial begin
    #12 reset = 1'b0;
end

// FSM processing
always_comb if (reset) state = IDLE;


always_comb begin
	case (state)
	    IDLE 	    :   if (clk_external & !clk_sample)
                            state = COMPARE;
	    		        else
                            state = IDLE;
		COMPARE		:	if (counter == num_bits)
                            state = IDLE;
	endcase
end

always_comb begin
	case (state)
	    IDLE	: begin
            ready = 1'b1;
            counter = 0;

            if (clk_external & clk_sample)
                register_clk = 1'b0;
            else
                register_clk = 1'b1;
	    end
	    COMPARE	: begin
            if (clk_ready) begin
    	        counter = counter + 1;
            end
            register_clk = 1'b0;
            ready = clk_ready;
        end 
	endcase
end

clk_gen clk_gen_inst (
    .clk_external    (clk_external),
    .clk_sample     (clk_sample),
    .register_clk   (register_clk),
    .ready          (ready)
);


endmodule
