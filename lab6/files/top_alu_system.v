`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 10:32:33 AM
// Design Name: 
// Module Name: top_alu_system
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

`timescale 1ns / 1ps

module top_alu_system (
    input  wire clk,
    input  wire pbin,
    input  wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire slow_clk;
    wire [31:0] switch_data; 
    wire [31:0] led_write_data; 

    //pad the top 16 bits of the LED data to prevent multi-driver synthesis errors
    assign led_write_data[31:16] = 16'd0;

    //debouncer for the physical reset button
    debouncer rst_db (.clk(clk),.pbin(pbin),.pbout(rst_clean));
   
    clock_divider ticker (.clk_in(clk),.rst(rst_clean),.clk_out(slow_clk));

    //Switch Reader
    leds switch_reader (
        .clk(clk), 
        .rst(rst_clean),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(switch_data)
    );


    switches led_writer (.clk(clk), .rst(rst_clean),.writeData(led_write_data),.writeEnable(1'b1),.readEnable(1'b0),
    .memAddress(30'd0),.readData(), .leds(physical_leds));

    //The ALU FSM Controller
    alu_fsm my_alu_controller (
        .clk(slow_clk),
        .rst(rst_clean),
        .switch_in(switch_data[15:0]),
        .led_out(led_write_data[15:0])
    );

endmodule
