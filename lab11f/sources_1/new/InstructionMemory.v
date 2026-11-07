`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 11:07:48 AM
// Design Name: 
// Module Name: instructionMemory
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
// Description: Lab 10 Byte-Addressable Instruction Memory with NOP fallback
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input      [OPERAND_LENGTH:0] instAddress,
    output reg [31:0]             instruction
);

    reg [7:0] memory [0:255];
    integer i;

    initial begin
        // Initialize memory with standard RISC-V NOP (addi x0, x0, 0 = 32'h00000013)
        // Little-endian byte order: 13, 00, 00, 00
        for (i = 0; i < 256; i = i + 4) begin
            memory[i]   = 8'h13;
            memory[i+1] = 8'h00;
            memory[i+2] = 8'h00;
            memory[i+3] = 8'h00;
        end

        // Load assembled machine code from file
       $readmemh("instructionsMem.mem", memory);
    end

    // Little-endian combinational instruction read
    always @(*) begin
        if (instAddress <= 252) begin
            instruction = {memory[instAddress + 3],
                           memory[instAddress + 2],
                           memory[instAddress + 1],
                           memory[instAddress]};
        end else begin
            instruction = 32'h00000013; // Return NOP if address out of range
        end
    end

endmodule
