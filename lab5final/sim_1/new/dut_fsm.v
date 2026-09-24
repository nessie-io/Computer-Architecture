`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 09:40:45 AM
// Design Name: 
// Module Name: fsm
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




module fsm (
    input wire clk,                  // FPGA System Clock
    input wire rst,                  // Reset Button (Active-High)
    input wire [15:0] sw_in,         // 16 Switch Inputs
    output reg [15:0] leds           // 16 LED Outputs
);

    // State Encoding using localparam
    localparam S_WAIT  = 1'b0;       // Input Waiting State (IDLE)
    localparam S_COUNT = 1'b1;       // Countdown State

    reg state_reg, state_next;
    reg [15:0] count_reg, count_next;

   
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_reg <= S_WAIT;
            count_reg <= 16'd0;
        end else begin
            state_reg <= state_next;
            count_reg <= count_next;
        end
    end

   
    always @(*) begin
        // Default assignments to prevent unintended latches
        state_next = state_reg;
        count_next = count_reg;
        leds       = 16'd0;

        case (state_reg)
            S_WAIT: begin
                leds = 16'd0;
                
                if (sw_in > 0) begin
                    count_next = sw_in;
                    state_next = S_COUNT;
                end
            end

            S_COUNT: begin
                leds = count_reg; // Display current counter value on LEDs
                
                // Decrement logic
                if (count_reg == 16'd1) begin
                    count_next = 16'd0;
                    state_next = S_WAIT; 
                end else begin
                    count_next = count_reg - 1'b1;
                end
            end

            default: begin
                state_next = S_WAIT;
                count_next = 16'd0;
            end
        endcase
    end

endmodule
