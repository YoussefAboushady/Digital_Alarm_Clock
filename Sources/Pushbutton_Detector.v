`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 03:18:00 PM
// Design Name: 
// Module Name: Pushbutton_Detector
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


module Pushbutton_Detector(input X,input clk , input reset, output Z);

wire debounce;
wire signal1;
wire new_clk;

//clockdivider #(250000) d (.clk(clk), .reset(reset), .clk_out(new_clk)); 
debouncer b( .clk(clk), .rst(reset), .in(X),  .out(debounce));
Q2 q2(.signal(debounce), .clock(clk), .signal1(signal1));
rising_edge re(  .clk(clk), .rst(reset),.w(signal1), .z(Z));

endmodule
