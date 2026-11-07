`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 08:59:17 AM
// Design Name: 
// Module Name: top_rf_alu
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

module top_rf_alu (
    input wire clk,
    input wire rst,
    input wire step_btn,
    input wire [15:0] sw_in,
    output reg [15:0] leds
);

    reg [19:0] debounce_count = 0;
    reg step_sync_0 = 0, 
        step_sync_1 = 0, 
        clean_step = 0, 
        last_clean_step = 0;

    always @(posedge clk) begin
        step_sync_0 <= step_btn;
        step_sync_1 <= step_sync_0;

        if (step_sync_1 ^ clean_step) begin
            debounce_count <= debounce_count + 1;
            if (&debounce_count) clean_step <= step_sync_1;
        end else begin
            debounce_count <= 0;
        end
        last_clean_step <= clean_step;
    end

    wire step_pulse = clean_step & ~last_clean_step;

    wire [31:0] readData1, readData2, ALUResult;
    wire        Zero;

    reg WriteEnable;
    reg [4:0] readReg1, readReg2, writeReg;
    reg [31:0] writeData;
    reg [3:0]  ALUControl;
    reg [31:0] display_val;

    RegFile rf (
        .clk(clk), .reset(rst), .WriteEnable(WriteEnable),
        .readReg1(readReg1), .readReg2(readReg2), .writeReg(writeReg),
        .writeData(writeData), .readData1(readData1), .readData2(readData2)
    );

    ALU alu (
        .A(readData1), .B(readData2), .ALUControl(ALUControl),
        .Result(ALUResult), .Zero(Zero)
    );

    localparam S_IDLE = 3'd0;
    localparam S_BOOT_1 = 3'd1;
    localparam S_BOOT_2 = 3'd2;
    localparam S_EXEC = 3'd3;
    localparam S_HOLD = 3'd4;

    reg [2:0] state_reg, state_next;
    wire mode_auto = sw_in[15];

    always @(posedge clk or posedge rst) begin
        if (rst) state_reg <= S_IDLE;
        else state_reg <= state_next;
    end

    always @(*) begin
        state_next = state_reg;
        WriteEnable = 1'b0;
        writeReg = 5'b0;
        writeData = 32'b0;
        readReg1 = 5'b0;
        readReg2 = 5'b0;
        ALUControl = 4'b0;
        display_val = 32'b0;
        leds = 16'b0;

        if (mode_auto) begin
            case (state_reg)
                S_IDLE: begin
                    WriteEnable = 1'b0;
                    if (step_pulse) state_next = S_BOOT_1;
                end

                S_BOOT_1: begin
                    WriteEnable = 1'b1; 
                    writeReg = 5'd1; 
                    writeData = 32'h10101010;
                    
                    if (step_pulse) state_next = S_BOOT_2;
                end

                S_BOOT_2: begin
                    WriteEnable = 1'b1; 
                    writeReg = 5'd2; 
                    writeData = 32'h01010101;
                    
                    if (step_pulse) state_next = S_EXEC;
                end

                S_EXEC: begin
                    readReg1 = 5'd1; 
                    readReg2 = 5'd2; 
                    ALUControl = sw_in[3:0];
                    
                    WriteEnable = 1'b1; 
                    writeReg = sw_in[13:9];
                    writeData = ALUResult;
                    
                    if (step_pulse) state_next = S_HOLD;
                end

                S_HOLD: begin
                    WriteEnable = 1'b0; 
                    readReg1 = sw_in[13:9];
                    display_val = readData1;   
                    
                    if (step_pulse) state_next = S_IDLE; 
                end
            endcase

            leds[7:0] = display_val[7:0];
            leds[8] = Zero;
            leds[11:10] = state_reg[1:0];
            leds[15] = 1'b1;

        end else begin
            WriteEnable = sw_in[14] & step_pulse;  
            writeReg = sw_in[13:9];
            readReg1 = 5'd2;                    
            readReg2 = sw_in[8:4];              
            ALUControl = sw_in[3:0];              
            writeData = ALUResult;

            leds[14:0] = ALUResult[14:0];
            leds[15] = Zero;                     
        end
    end

endmodule