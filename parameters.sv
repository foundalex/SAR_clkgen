
package parameters_pkg;
    parameter CLK_PERIOD = 8.33ns; 
    parameter CLK_PERIOD1 = CLK_PERIOD/5; // 8.33 / (4 бита + 1 clk_sample)
    parameter CLK_PERIOD2 = 1ns;
    parameter num_bits = 4;
endpackage