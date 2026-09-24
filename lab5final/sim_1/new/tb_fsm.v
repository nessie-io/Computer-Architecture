`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 09:45:30 AM
// Design Name: 
// Module Name: tb_fsm
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
module tb_fsm;

    reg clk;
    reg rst;
    reg [15:0] sw_in;
    wire [15:0] leds;

   
    fsm dut (
        .clk(clk),
        .rst(rst),
        .sw_in(sw_in),
        .leds(leds)
    );

    
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        sw_in = 16'd0; 
        #20;
        rst = 0;
        #20;
        sw_in = 16'd5;
        #10;
        sw_in = 16'd12;
        #20;
        sw_in = 16'd0;
        #60; 
        sw_in = 16'd10; 
        #10;
        sw_in = 16'd0;  
        #30;           
        
        rst = 1;        
        #10;
        rst = 0;        
        
        #40;

        $display("Simulation complete.");
        $finish;
    end

endmodule 