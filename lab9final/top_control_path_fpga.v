`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 10:46:30 AM
// Design Name: 
// Module Name: top_control_path_fpga
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

module top_control_path_fpga (
    input         clk,         // 100 MHz board clock (Basys 3: W5)
    input         rst_btn,     // Reset button (Center button btnC: U18)
    input         step_btn,    // Step button (Up button btnU: T18)
    input         sw_mode,     // Slide Switch SW0 (V17): 0 = State index, 1 = ALUControl
    output [15:0] led          // Onboard LEDs (U16 ... L1)
);

    wire step_pulse;
    wire rst_pulse;

    // Button debouncers
    Debouncer u_deb_step (
        .clk       (clk),
        .btn_in    (step_btn),
        .btn_pulse (step_pulse)
    );

    Debouncer u_deb_rst (
        .clk       (clk),
        .btn_in    (rst_btn),
        .btn_pulse (rst_pulse)
    );

    // 15-state instruction counter
    reg [3:0] state = 4'd0;

    always @(posedge clk) begin
        if (rst_pulse) begin
            state <= 4'd0;
        end else if (step_pulse) begin
            if (state == 4'd14)
                state <= 4'd0;
            else
                state <= state + 1'b1;
        end
    end

    // Instruction Lookup Table
    reg [6:0] cur_opcode;
    reg [2:0] cur_funct3;
    reg [6:0] cur_funct7;

    always @(*) begin
        case (state)
            4'd0:  begin cur_opcode = 7'b0110011; cur_funct3 = 3'b000; cur_funct7 = 7'b0000000; end // ADD
            4'd1:  begin cur_opcode = 7'b0110011; cur_funct3 = 3'b000; cur_funct7 = 7'b0100000; end // SUB
            4'd2:  begin cur_opcode = 7'b0110011; cur_funct3 = 3'b001; cur_funct7 = 7'b0000000; end // SLL
            4'd3:  begin cur_opcode = 7'b0110011; cur_funct3 = 3'b101; cur_funct7 = 7'b0000000; end // SRL
            4'd4:  begin cur_opcode = 7'b0110011; cur_funct3 = 3'b100; cur_funct7 = 7'b0000000; end // XOR
            4'd5:  begin cur_opcode = 7'b0110011; cur_funct3 = 3'b110; cur_funct7 = 7'b0000000; end // OR
            4'd6:  begin cur_opcode = 7'b0110011; cur_funct3 = 3'b111; cur_funct7 = 7'b0000000; end // AND
            4'd7:  begin cur_opcode = 7'b0010011; cur_funct3 = 3'b000; cur_funct7 = 7'b0000000; end // ADDI
            4'd8:  begin cur_opcode = 7'b0000011; cur_funct3 = 3'b010; cur_funct7 = 7'b0000000; end // LW
            4'd9:  begin cur_opcode = 7'b0000011; cur_funct3 = 3'b001; cur_funct7 = 7'b0000000; end // LH
            4'd10: begin cur_opcode = 7'b0000011; cur_funct3 = 3'b000; cur_funct7 = 7'b0000000; end // LB
            4'd11: begin cur_opcode = 7'b0100011; cur_funct3 = 3'b010; cur_funct7 = 7'b0000000; end // SW
            4'd12: begin cur_opcode = 7'b0100011; cur_funct3 = 3'b001; cur_funct7 = 7'b0000000; end // SH
            4'd13: begin cur_opcode = 7'b0100011; cur_funct3 = 3'b000; cur_funct7 = 7'b0000000; end // SB
            4'd14: begin cur_opcode = 7'b1100011; cur_funct3 = 3'b000; cur_funct7 = 7'b0000000; end // BEQ
            default: begin cur_opcode = 7'b0000000; cur_funct3 = 3'b000; cur_funct7 = 7'b0000000; end
        endcase
    end

    // Interconnect wires to control_path
    wire       RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControlOut;

    // Instantiation matching your verified control_path module
    control_path u_dut (
        .opcode        (cur_opcode),
        .funct3        (cur_funct3),
        .funct7        (cur_funct7),
        .RegWrite      (RegWrite),
        .ALUSrc        (ALUSrc),
        .MemRead       (MemRead),
        .MemWrite      (MemWrite),
        .MemtoReg      (MemtoReg),
        .Branch        (Branch),
        .ALUOp         (ALUOp),
        .ALUControlOut (ALUControlOut)
    );

    // Direct LED assignments
    assign led[0]     = RegWrite;
    assign led[1]     = ALUSrc;
    assign led[2]     = MemRead;
    assign led[3]     = MemWrite;
    assign led[4]     = MemtoReg;
    assign led[5]     = Branch;
    assign led[7:6]   = ALUOp;
    assign led[11:8]  = state;
    assign led[15:12] = sw_mode ? ALUControlOut : 4'b0000;

endmodule