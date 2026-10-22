`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 09:08:37 AM
// Design Name: 
// Module Name: control_path
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

module control_path(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output       RegWrite,
    output       ALUSrc,
    output       MemRead,
    output       MemWrite,
    output       MemtoReg,
    output       Branch,
    output [1:0] ALUOp,
    output [3:0] ALUControlOut
);

    wire [1:0] alu_op_internal;
    assign ALUOp = alu_op_internal;

    main_control u_main_ctrl (
        .opcode   (opcode),
        .RegWrite (RegWrite),
        .ALUSrc   (ALUSrc),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .MemtoReg (MemtoReg),
        .Branch   (Branch),
        .ALUOp    (alu_op_internal)
    );

    AluControl u_alu_ctrl (
        .ALUOp      (alu_op_internal),
        .funct3     (funct3),
        .funct7     (funct7),
        .ALUControl (ALUControlOut)
    );

endmodule