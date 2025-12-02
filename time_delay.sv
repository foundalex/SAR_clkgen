`timescale 1ns / 1ps

module time_delay
    #(
		parameter delay = 1
	)
    (
        input data_in,
        output data_out
    );

    assign #delay data_out = data_in;

endmodule
