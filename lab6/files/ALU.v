`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 08:37:16 AM
// Design Name: 
// Module Name: ALU
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

module ALU (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUControl,
    output wire [31:0] ALUResult, // Changed to 'wire' because it is driven by sub-modules
    output wire        Zero
);

    wire [32:0] c; // Carry wires linking the 32 slices
    
    // For subtraction (0110), the initial Carry-In (c[0]) must be 1 for Two's Complement.
    // For addition (0010), the initial Carry-In is 0.
    assign c[0] = (ALUControl == 4'b0110) ? 1'b1 : 1'b0;

    // Pre-compute shifts at the 32-bit level to feed into the 1-bit slices
    wire [31:0] sll_res = A << B[4:0];
    wire [31:0] srl_res = A >> B[4:0];

    // Manual Instantiation of 32 1-bit ALUs
    alu_1bit bit0  (.a(A[0]),  .b(B[0]),  .cin(c[0]),  .sll_val(sll_res[0]),  .srl_val(srl_res[0]),  .alu_ctrl(ALUControl), .result(ALUResult[0]),  .cout(c[1]));
    alu_1bit bit1  (.a(A[1]),  .b(B[1]),  .cin(c[1]),  .sll_val(sll_res[1]),  .srl_val(srl_res[1]),  .alu_ctrl(ALUControl), .result(ALUResult[1]),  .cout(c[2]));
    alu_1bit bit2  (.a(A[2]),  .b(B[2]),  .cin(c[2]),  .sll_val(sll_res[2]),  .srl_val(srl_res[2]),  .alu_ctrl(ALUControl), .result(ALUResult[2]),  .cout(c[3]));
    alu_1bit bit3  (.a(A[3]),  .b(B[3]),  .cin(c[3]),  .sll_val(sll_res[3]),  .srl_val(srl_res[3]),  .alu_ctrl(ALUControl), .result(ALUResult[3]),  .cout(c[4]));
    
    alu_1bit bit4  (.a(A[4]),  .b(B[4]),  .cin(c[4]),  .sll_val(sll_res[4]),  .srl_val(srl_res[4]),  .alu_ctrl(ALUControl), .result(ALUResult[4]),  .cout(c[5]));
    alu_1bit bit5  (.a(A[5]),  .b(B[5]),  .cin(c[5]),  .sll_val(sll_res[5]),  .srl_val(srl_res[5]),  .alu_ctrl(ALUControl), .result(ALUResult[5]),  .cout(c[6]));
    alu_1bit bit6  (.a(A[6]),  .b(B[6]),  .cin(c[6]),  .sll_val(sll_res[6]),  .srl_val(srl_res[6]),  .alu_ctrl(ALUControl), .result(ALUResult[6]),  .cout(c[7]));
    alu_1bit bit7  (.a(A[7]),  .b(B[7]),  .cin(c[7]),  .sll_val(sll_res[7]),  .srl_val(srl_res[7]),  .alu_ctrl(ALUControl), .result(ALUResult[7]),  .cout(c[8]));
    
    alu_1bit bit8  (.a(A[8]),  .b(B[8]),  .cin(c[8]),  .sll_val(sll_res[8]),  .srl_val(srl_res[8]),  .alu_ctrl(ALUControl), .result(ALUResult[8]),  .cout(c[9]));
    alu_1bit bit9  (.a(A[9]),  .b(B[9]),  .cin(c[9]),  .sll_val(sll_res[9]),  .srl_val(srl_res[9]),  .alu_ctrl(ALUControl), .result(ALUResult[9]),  .cout(c[10]));
    alu_1bit bit10 (.a(A[10]), .b(B[10]), .cin(c[10]), .sll_val(sll_res[10]), .srl_val(srl_res[10]), .alu_ctrl(ALUControl), .result(ALUResult[10]), .cout(c[11]));
    alu_1bit bit11 (.a(A[11]), .b(B[11]), .cin(c[11]), .sll_val(sll_res[11]), .srl_val(srl_res[11]), .alu_ctrl(ALUControl), .result(ALUResult[11]), .cout(c[12]));
    
    alu_1bit bit12 (.a(A[12]), .b(B[12]), .cin(c[12]), .sll_val(sll_res[12]), .srl_val(srl_res[12]), .alu_ctrl(ALUControl), .result(ALUResult[12]), .cout(c[13]));
    alu_1bit bit13 (.a(A[13]), .b(B[13]), .cin(c[13]), .sll_val(sll_res[13]), .srl_val(srl_res[13]), .alu_ctrl(ALUControl), .result(ALUResult[13]), .cout(c[14]));
    alu_1bit bit14 (.a(A[14]), .b(B[14]), .cin(c[14]), .sll_val(sll_res[14]), .srl_val(srl_res[14]), .alu_ctrl(ALUControl), .result(ALUResult[14]), .cout(c[15]));
    alu_1bit bit15 (.a(A[15]), .b(B[15]), .cin(c[15]), .sll_val(sll_res[15]), .srl_val(srl_res[15]), .alu_ctrl(ALUControl), .result(ALUResult[15]), .cout(c[16]));
    
    alu_1bit bit16 (.a(A[16]), .b(B[16]), .cin(c[16]), .sll_val(sll_res[16]), .srl_val(srl_res[16]), .alu_ctrl(ALUControl), .result(ALUResult[16]), .cout(c[17]));
    alu_1bit bit17 (.a(A[17]), .b(B[17]), .cin(c[17]), .sll_val(sll_res[17]), .srl_val(srl_res[17]), .alu_ctrl(ALUControl), .result(ALUResult[17]), .cout(c[18]));
    alu_1bit bit18 (.a(A[18]), .b(B[18]), .cin(c[18]), .sll_val(sll_res[18]), .srl_val(srl_res[18]), .alu_ctrl(ALUControl), .result(ALUResult[18]), .cout(c[19]));
    alu_1bit bit19 (.a(A[19]), .b(B[19]), .cin(c[19]), .sll_val(sll_res[19]), .srl_val(srl_res[19]), .alu_ctrl(ALUControl), .result(ALUResult[19]), .cout(c[20]));
    
    alu_1bit bit20 (.a(A[20]), .b(B[20]), .cin(c[20]), .sll_val(sll_res[20]), .srl_val(srl_res[20]), .alu_ctrl(ALUControl), .result(ALUResult[20]), .cout(c[21]));
    alu_1bit bit21 (.a(A[21]), .b(B[21]), .cin(c[21]), .sll_val(sll_res[21]), .srl_val(srl_res[21]), .alu_ctrl(ALUControl), .result(ALUResult[21]), .cout(c[22]));
    alu_1bit bit22 (.a(A[22]), .b(B[22]), .cin(c[22]), .sll_val(sll_res[22]), .srl_val(srl_res[22]), .alu_ctrl(ALUControl), .result(ALUResult[22]), .cout(c[23]));
    alu_1bit bit23 (.a(A[23]), .b(B[23]), .cin(c[23]), .sll_val(sll_res[23]), .srl_val(srl_res[23]), .alu_ctrl(ALUControl), .result(ALUResult[23]), .cout(c[24]));
    
    alu_1bit bit24 (.a(A[24]), .b(B[24]), .cin(c[24]), .sll_val(sll_res[24]), .srl_val(srl_res[24]), .alu_ctrl(ALUControl), .result(ALUResult[24]), .cout(c[25]));
    alu_1bit bit25 (.a(A[25]), .b(B[25]), .cin(c[25]), .sll_val(sll_res[25]), .srl_val(srl_res[25]), .alu_ctrl(ALUControl), .result(ALUResult[25]), .cout(c[26]));
    alu_1bit bit26 (.a(A[26]), .b(B[26]), .cin(c[26]), .sll_val(sll_res[26]), .srl_val(srl_res[26]), .alu_ctrl(ALUControl), .result(ALUResult[26]), .cout(c[27]));
    alu_1bit bit27 (.a(A[27]), .b(B[27]), .cin(c[27]), .sll_val(sll_res[27]), .srl_val(srl_res[27]), .alu_ctrl(ALUControl), .result(ALUResult[27]), .cout(c[28]));
    
    alu_1bit bit28 (.a(A[28]), .b(B[28]), .cin(c[28]), .sll_val(sll_res[28]), .srl_val(srl_res[28]), .alu_ctrl(ALUControl), .result(ALUResult[28]), .cout(c[29]));
    alu_1bit bit29 (.a(A[29]), .b(B[29]), .cin(c[29]), .sll_val(sll_res[29]), .srl_val(srl_res[29]), .alu_ctrl(ALUControl), .result(ALUResult[29]), .cout(c[30]));
    alu_1bit bit30 (.a(A[30]), .b(B[30]), .cin(c[30]), .sll_val(sll_res[30]), .srl_val(srl_res[30]), .alu_ctrl(ALUControl), .result(ALUResult[30]), .cout(c[31]));
    alu_1bit bit31 (.a(A[31]), .b(B[31]), .cin(c[31]), .sll_val(sll_res[31]), .srl_val(srl_res[31]), .alu_ctrl(ALUControl), .result(ALUResult[31]), .cout(c[32]));

    // Evaluate Zero Flag for BEQ operations
    assign Zero = (ALUResult == 32'd0) ? 1'b1 : 1'b0;

endmodule
