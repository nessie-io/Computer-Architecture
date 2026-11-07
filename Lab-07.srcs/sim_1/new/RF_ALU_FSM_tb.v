`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 09:59:41 AM
// Design Name: 
// Module Name: RF_ALU_FSM_tb
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

module RF_ALU_FSM_tb;
    reg clk;
    reg rst;
    reg step_btn;
    reg [15:0] sw_in;

    wire [15:0] leds;

    top_rf_alu uut (
        .clk(clk),
        .rst(rst),
        .step_btn(step_btn),
        .sw_in(sw_in),
        .leds(leds)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task press_step;
        begin
            #20;
            step_btn = 1'b1;
            #100;
            step_btn = 1'b0;
            #100;
        end
    endtask

    initial begin
        rst = 1;
        step_btn = 0;
        sw_in = 16'b0;
        
        #40;
        rst = 0;
        #40;

        sw_in = {1'b1, 2'b00, 5'd3, 4'b0010};

        $display("Starting Top Module FSM Simulation...");

        press_step();
        $display("Advanced to S_BOOT_1: x1 written.");

        press_step();
        $display("Advanced to S_BOOT_2: x2 written.");

        press_step();
        $display("Advanced to S_EXEC: ALU executed, result written to register x3 via sw_in[13:9].");

        press_step();
        $display("Advanced to S_HOLD: Displaying register x3 contents.");

        #100;

        $display(" Register Contents Check");
        if (uut.rf.regs[1] === 32'h10101010) 
            $display("PASS: x1 constant (got %h)", uut.rf.regs[1]);
        else 
            $display("FAIL: x1 constant (expected 10101010, got %h)", uut.rf.regs[1]);

        if (uut.rf.regs[2] === 32'h01010101) 
            $display("PASS: x2 constant (got %h)", uut.rf.regs[2]);
        else 
            $display("FAIL: x2 constant (expected 01010101, got %h)", uut.rf.regs[2]);

        if (uut.rf.regs[3] === 32'h11111111) 
            $display("PASS: x3 result of ADD (got %h)", uut.rf.regs[3]);
        else 
            $display("FAIL: x3 result of ADD (expected 11111111, got %h)", uut.rf.regs[3]);

        $display("Simulation Finished.");
        $finish;
    end

endmodule