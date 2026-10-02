`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 10:11:42 AM
// Design Name: 
// Module Name: my_xorr
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


module my_xorr(
    input  wire  A,
    input  wire  B,
    output wire result 
    );
    wire first_not;
    wire second_not;
    wire first_and;
    wire second_and;
    assign first_not = ~A;
    assign second_not = ~B;
    assign second_and= second_not & A;
    assign first_and = first_not & B;
    assign result = first_and | second_and; 
endmodule
