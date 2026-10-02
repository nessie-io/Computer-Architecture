`timescale 1ns / 1ps

module ALU_tb;
    reg clk;
    reg rst;
    reg [15:0] switch_in;
    wire [15:0] led_out;

    //instantiate the ALU FSM
    alu_fsm uut (.clk(clk),.rst(rst),.switch_in(switch_in),.led_out(led_out));

    //100MHz clock (10ns period)
    always #5 clk = ~clk;
    initial begin
        //inputs and hold reset
        clk = 0;
        rst = 1;
        switch_in = 16'h0000;
        //release reset after 20ns
        #20 rst = 0;
        switch_in = 16'h0002; #20; // ADD
        switch_in = 16'h0006; #20; // SUB
        switch_in = 16'h0000; #20; // AND
        switch_in = 16'h0001; #20; // OR
        switch_in = 16'h0004; #20; // XOR
        switch_in = 16'h0003; #20; // SLL
        switch_in = 16'h0005; #20; // SRL
        #20 $finish;
    end
endmodule