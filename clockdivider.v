`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 09:56:36 PM
// Design Name: 
// Module Name: clockdivider
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



module clockdivider #(parameter n = 50000000)
(
    input clk,
    input reset,
    output reg clk_out
);
    
parameter WIDTH = $clog2(n);
reg [WIDTH-1:0] count;

always @ (posedge clk, posedge reset) begin
if (reset == 1'b1)
count <= 32'b0; 
else if (count == n-1)
 count <= 32'b0;
else
 count <= count + 1;
end

always @(posedge clk, posedge reset) begin
    if (reset) 
        clk_out <= 0;
    else if (count == n-1)
        clk_out <= ~clk_out;
end

endmodule
