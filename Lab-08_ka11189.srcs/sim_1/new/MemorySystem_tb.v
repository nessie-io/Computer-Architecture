`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2026 09:35:35 AM
// Design Name: 
// Module Name: MemorySystem_tb
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

module MemorySystem_tb;

    reg clk;
    reg rst;
    reg [31:0] address;
    reg readEnable;
    reg writeEnable;
    reg [31:0] writeData;
    reg [15:0] switches;

    wire [31:0] readData;
    wire [15:0] leds;

    addressDecoderTop uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches(switches),
        .readData(readData),
        .leds(leds)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        address = 32'h0;
        readEnable = 0;
        writeEnable = 0;
        writeData = 32'h0;
        switches = 16'hABCD;
        #20;
        
        rst = 0;
        #20;

        address = 32'h00000010;
        writeData = 32'h12345678;
        writeEnable = 1'b1;
        readEnable = 0;
        #10;
        writeEnable = 1'b0;
        #10;

        address = 32'h00000010;
        readEnable = 1'b1;
        #10;
        readEnable = 0;
        #10;

        address = 32'h00000100;
        writeData = 32'h000000AA;
        writeEnable = 1'b1;
        #10;
        writeEnable = 1'b0;
        #10;

        address = 32'h00000300;
        switches = 16'h5A5A;
        readEnable = 1'b1;
        #10;
        readEnable = 0;
        #10;

        $finish;
    end

endmodule

