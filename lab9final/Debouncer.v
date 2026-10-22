`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 10:44:57 AM
// Design Name: 
// Module Name: Debouncer
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

module Debouncer (
    input  clk,
    input  btn_in,
    output btn_pulse
);
    reg [19:0] counter = 20'd0;
    reg btn_state = 1'b0;
    reg btn_sync_0 = 1'b0;
    reg btn_sync_1 = 1'b0;
    reg btn_state_prev = 1'b0;

    // 2-stage synchronizer to prevent metastability
    always @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;

        // 10ms debounce filter at 100 MHz clock rate
        if (btn_sync_1 != btn_state) begin
            counter <= counter + 1'b1;
            if (counter == 20'd1_000_000) begin
                btn_state <= btn_sync_1;
                counter   <= 20'd0;
            end
        end else begin
            counter <= 20'd0;
        end

        btn_state_prev <= btn_state;
    end

    // Emit a single-cycle pulse on rising edge of stable press
    assign btn_pulse = btn_state & ~btn_state_prev;

endmodule
