`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2025 12:01:37
// Design Name: 
// Module Name: mux_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_logic
    (
        input data1,
        input data2,
        input sel,
        output bit data_mux
    );

    always_comb begin
        if (sel)
            data_mux = data1;
        else
            data_mux = data2;
    end



endmodule
