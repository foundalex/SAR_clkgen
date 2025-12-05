`timescale 1ns / 1ps

module time_delay
    #(
		parameter delay = 1
	)
    (
        input data_in,
        output reg data_out
    );

    // reg qwerty;
    always_comb data_out <= #delay data_in;

// initial 
// 	begin
//         forever begin
// 		    qwerty = data_in;
// 		    # delay;
//             data_out = qwerty;
//         end
// 	end

endmodule
