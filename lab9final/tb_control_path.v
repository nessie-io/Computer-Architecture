`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 09:10:59 AM
// Design Name: 
// Module Name: tb_control_path
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
module tb_control_path;

    reg  [6:0] opcode;
    reg  [2:0] funct3;
    reg  [6:0] funct7;

    wire       RegWrite;
    wire       ALUSrc;
    wire       MemRead;
    wire       MemWrite;
    wire       MemtoReg;
    wire       Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControlOut;

    integer pass_count = 0;
    integer fail_count = 0;

    control_path dut (
        .opcode        (opcode),
        .funct3        (funct3),
        .funct7        (funct7),
        .RegWrite      (RegWrite),
        .ALUSrc        (ALUSrc),
        .MemRead       (MemRead),
        .MemWrite      (MemWrite),
        .MemtoReg      (MemtoReg),
        .Branch        (Branch),
        .ALUOp         (ALUOp),
        .ALUControlOut (ALUControlOut)
    );

    task check_inst(
        input [8*6:1] name,
        input [6:0]   in_op,
        input [2:0]   in_f3,
        input [6:0]   in_f7,
        input         exp_regwrite,
        input         exp_alusrc,
        input         exp_memread,
        input         exp_memwrite,
        input         exp_memtoreg,
        input         exp_branch,
        input [1:0]   exp_aluop,
        input [3:0]   exp_alucontrol
    );
        begin
            opcode = in_op; funct3 = in_f3; funct7 = in_f7;
            #10;
            if ({RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp, ALUControlOut} ===
                {exp_regwrite, exp_alusrc, exp_memread, exp_memwrite, exp_memtoreg, exp_branch, exp_aluop, exp_alucontrol}) begin
                $display("[PASS] %s | ALUControl: %b | ALUOp: %b", name, ALUControlOut, ALUOp);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %s | Expected {RW,AS,MR,MW,M2R,BR,ALUOp,Ctrl}: %b_%b_%b_%b_%b_%b_%b_%b | Got: %b_%b_%b_%b_%b_%b_%b_%b",
                         name, exp_regwrite, exp_alusrc, exp_memread, exp_memwrite, exp_memtoreg, exp_branch, exp_aluop, exp_alucontrol,
                         RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp, ALUControlOut);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("control_path.vcd");
        $dumpvars(0, tb_control_path);

        //          Name     Opcode       f3         f7    RW AS MR MW M2R BR ALUOp  ALUCtrl
        check_inst("ADD ",  7'b0110011, 3'b000, 7'b0000000, 1, 0, 0, 0, 0,  0, 2'b10, 4'b0010);
        check_inst("SUB ",  7'b0110011, 3'b000, 7'b0100000, 1, 0, 0, 0, 0,  0, 2'b10, 4'b0110);
        check_inst("SLL ",  7'b0110011, 3'b001, 7'b0000000, 1, 0, 0, 0, 0,  0, 2'b10, 4'b0011);
        check_inst("SRL ",  7'b0110011, 3'b101, 7'b0000000, 1, 0, 0, 0, 0,  0, 2'b10, 4'b0100);
        check_inst("XOR ",  7'b0110011, 3'b100, 7'b0000000, 1, 0, 0, 0, 0,  0, 2'b10, 4'b0101);
        check_inst("OR  ",  7'b0110011, 3'b110, 7'b0000000, 1, 0, 0, 0, 0,  0, 2'b10, 4'b0001);
        check_inst("AND ",  7'b0110011, 3'b111, 7'b0000000, 1, 0, 0, 0, 0,  0, 2'b10, 4'b0000);
        check_inst("ADDI",  7'b0010011, 3'b000, 7'b0000000, 1, 1, 0, 0, 0,  0, 2'b00, 4'b0010);
        check_inst("LW  ",  7'b0000011, 3'b010, 7'b0000000, 1, 1, 1, 0, 1,  0, 2'b00, 4'b0010);
        check_inst("LH  ",  7'b0000011, 3'b001, 7'b0000000, 1, 1, 1, 0, 1,  0, 2'b00, 4'b0010);
        check_inst("LB  ",  7'b0000011, 3'b000, 7'b0000000, 1, 1, 1, 0, 1,  0, 2'b00, 4'b0010);
        check_inst("SW  ",  7'b0100011, 3'b010, 7'b0000000, 0, 1, 0, 1, 0,  0, 2'b00, 4'b0010);
        check_inst("SH  ",  7'b0100011, 3'b001, 7'b0000000, 0, 1, 0, 1, 0,  0, 2'b00, 4'b0010);
        check_inst("SB  ",  7'b0100011, 3'b000, 7'b0000000, 0, 1, 0, 1, 0,  0, 2'b00, 4'b0010);
        check_inst("BEQ ",  7'b1100011, 3'b000, 7'b0000000, 0, 0, 0, 0, 0,  1, 2'b01, 4'b0110);

        #10;
        $display("-------------------------------------------");
        $display("TEST RESULTS: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("-------------------------------------------");
        $finish;
    end

endmodule