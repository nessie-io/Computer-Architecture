`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 08:54:29 AM
// Design Name: 
// Module Name: main_control
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
module main_control (
    input  [6:0] opcode,
    output reg   RegWrite,
    output reg   ALUSrc,
    output reg   MemRead,
    output reg   MemWrite,
    output reg   MemtoReg,
    output reg   Branch,
    output reg [1:0] ALUOp
);

    always @(*) begin
        // Safe default assignments to resolve "don't cares" (X -> 0)
        RegWrite = 1'b0;
        ALUSrc   = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;
        Branch   = 1'b0;
        ALUOp    = 2'b00;

        case (opcode)
            7'b0110011: begin // R-type
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end
            7'b0010011: begin // I-type ALU (ADDI)
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 2'b00;
            end
            7'b0000011: begin // Load (LW, LH, LB)
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                MemtoReg = 1'b1;
                ALUOp    = 2'b00;
            end
            7'b0100011: begin // Store (SW, SH, SB)
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = 2'b00;
            end
            7'b1100011: begin // Branch (BEQ)
                Branch   = 1'b1;
                ALUOp    = 2'b01;
            end
            default: begin
                // Retains safe default zeros
            end
        endcase
    end

endmodule
