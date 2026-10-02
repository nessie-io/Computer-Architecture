`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 09:48:47 AM
// Design Name: 
// Module Name: alu_fsm
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

module alu_fsm (
    input  wire clk,
    input  wire rst,
    input  wire [15:0] switch_in,
    output wire [15:0] led_out
);

    //FSM States
    parameter READ_OP = 1'b0;
    parameter EXECUTE = 1'b1;

    reg state, next_state;
    reg [15:0] led_reg, next_led_reg;

    //fixed Operands 
    wire [31:0] A = 32'h10101010;
    wire [31:0] B = 32'h01010101;
    
    wire [31:0] ALUResult;
    wire Zero;

    //instantiating 32 bit alu
    ALU my_alu ( .A(A),.B(B),.ALUControl(switch_in[3:0]),.ALUResult(ALUResult), .Zero(Zero));  // Switches 3-0 select the operation

    //sequential Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= READ_OP;
            led_reg <= 16'd0;
        end else begin
            state   <= next_state;
            led_reg <= next_led_reg;
        end
    end

    //combinational Logic
    always @(*) begin
        next_state = state;
        next_led_reg = led_reg;

        case (state)
            READ_OP: begin
                //move to execute state to process the switches
                next_state = EXECUTE;
            end
            
            EXECUTE: begin
                //map Zero flag to LED[15] and the lowest 15 bits of ALUResult to LED[14:0]
                next_led_reg = {Zero, ALUResult[14:0]};
                //loop back to continuously read new switch inputs
                next_state = READ_OP;
            end
            
            default: begin
                next_state = READ_OP;
                next_led_reg = 16'd0;
            end
        endcase
    end
    //output Logic
    assign led_out = led_reg;

endmodule
