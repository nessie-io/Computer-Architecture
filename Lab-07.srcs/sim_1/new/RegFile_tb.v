`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 09:29:05 AM
// Design Name: 
// Module Name: RegFile_tb
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


module RegFile_tb;
    reg         clk, reset, WriteEnable;
    reg  [4:0]  readReg1, readReg2, writeReg;
    reg  [31:0] writeData;
    wire [31:0] readData1, readData2;

    integer pass_count = 0, fail_count = 0, k;

    RegFile uut (
        .clk(clk), .reset(reset), .WriteEnable(WriteEnable),
        .readReg1(readReg1), .readReg2(readReg2), .writeReg(writeReg),
        .writeData(writeData), .readData1(readData1), .readData2(readData2)
    );

    // Clock: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Prints PASS or FAIL
    task check(input [31:0] actual, input [31:0] expected, input [255:0] name);
    begin
        if (actual === expected) begin
            $display("PASS: %0s (got %h)", name, actual);
            pass_count = pass_count + 1;
        end 
        else begin
            $display("FAIL: %0s (expected %h, got %h)", name, expected, actual);
            fail_count = fail_count + 1;
        end
    end
    endtask

    initial begin
        // Initial reset so registers are not X
        reset = 1; WriteEnable = 0;
        readReg1 = 0; readReg2 = 0; writeReg = 0; writeData = 0;
        #20 reset = 0;

        // Test i: Write 0xDEADBEEF to x5, read it back
        @(negedge clk) WriteEnable = 1; writeReg = 5; writeData = 32'hDEADBEEF;
        @(negedge clk) WriteEnable = 0; readReg1 = 5;
        #1 check(readData1, 32'hDEADBEEF, "i. write/read x5");

        // Test ii: Write to x0, must stay 0
        @(negedge clk) WriteEnable = 1; writeReg = 0; writeData = 32'hCAFE1234;
        @(negedge clk) WriteEnable = 0; readReg1 = 0;
        #1 check(readData1, 32'h0, "ii. x0 write ignored");

        // Test iii: Two reads at the same time (x5 and x6)
        @(negedge clk) WriteEnable = 1; writeReg = 6; writeData = 32'h12345678;
        @(negedge clk) WriteEnable = 0; readReg1 = 5; readReg2 = 6;
        #1 check(readData1, 32'hDEADBEEF, "iii. read port 1 (x5)");
        check(readData2, 32'h12345678, "iii. read port 2 (x6)");

        // Test iv: Overwrite x5
        @(negedge clk) WriteEnable = 1; writeReg = 5; writeData = 32'hCAFEF00D;
        @(negedge clk) WriteEnable = 0; readReg1 = 5;
        #1 check(readData1, 32'hCAFEF00D, "iv. x5 overwritten");

        // Extra: no write when WriteEnable = 0
        @(negedge clk) writeReg = 7; writeData = 32'hAAAAAAAA; WriteEnable = 0;
        @(negedge clk) readReg1 = 7;
        #1 check(readData1, 32'h0, "extra. no write when WriteEnable=0");

        // Test v: Reset clears all registers
        @(negedge clk) reset = 1;
        @(negedge clk) reset = 0;
        for (k = 0; k < 32; k = k + 1) begin
            readReg1 = k; #1;
            check(readData1, 32'h0, "v. register cleared after reset");
        end

        $display("-----------------------------");
        $display("Passed: %0d   Failed: %0d", pass_count, fail_count);
        if (fail_count == 0) $display("ALL TESTS PASSED");
        $finish;
    end
endmodule