`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 08:59:17 AM
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input clk, reset, WriteEnable,
    input [4:0] readReg1, readReg2, writeReg,
    input [31:0] writeData,
    output [31:0] readData1, readData2
    );
    
    reg [31:0] regs [31:0];
    integer i;

    assign readData1 = (readReg1 == 0) ? 32'b0 : regs[readReg1];
    assign readData2 = (readReg2 == 0) ? 32'b0 : regs[readReg2];

    always @(posedge clk) begin
        if (reset)
            for (i = 0; i < 32; i = i + 1) 
                regs[i] <= 32'b0;
        else if ((WriteEnable) && (writeReg !=0))
            regs[writeReg] <= writeData;
    end
endmodule
