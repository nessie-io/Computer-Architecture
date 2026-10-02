`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 09:52:01 AM
// Design Name: 
// Module Name: FA
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


module FA(
    input  wire A,
    input  wire B,
    input  wire Cin,
    output wire result,
    output wire Cout    
);
    wire first_xor;
    wire andd;
    wire second_xor;
    wire second_and; 
    wire final_or;
    
    my_xorr xorr(.A(A), .B(B), .result(first_xor));
    my_xorr xorrr(.A(first_xor), .B(Cin), .result(second_xor));
    
    assign andd = A & B;
    assign second_and = Cin & first_xor;  
    assign final_or = second_and | andd; 
    assign Cout = final_or; 
    assign result = second_xor;
endmodule