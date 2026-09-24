`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 10:27:19 AM
// Design Name: 
// Module Name: helper_mod
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

module helper_mod (
    input wire clk,
    input wire rst,
    input wire [15:0] sw_in,
    output wire [15:0] leds_out
);

    top_count system_inst (
        .clk(clk),
        .resetbtn(rst),
        .sw(sw_in),
        .led(leds_out)
    );

endmodule

module top_count (
    input wire clk,
    input wire resetbtn,
    input wire [15:0] sw,
    output wire [15:0] led  
);

    wire clean_rst;
    debouncer all (
        .clk(clk),
        .pbin(resetbtn),
        .pbout(clean_rst)
    );
    countdown_fsm myfsm (
        .clk(clk),
        .rst_clean(clean_rst),
        .sw(sw),
        .ledo(led)
    );    

endmodule

module debouncer (
    input wire clk,
    input wire pbin,
    output reg pbout
);

    reg [19:0] count = 20'd0;
    reg sync_0 = 1'b0;
    reg sync_1 = 1'b0;
    always @(posedge clk) begin
        sync_0 <= pbin;
        sync_1 <= sync_0;
    end
    always @(posedge clk) begin
        if (sync_1 == pbout) begin
            count <= 20'd0;
        end else begin
            count <= count + 1'b1;
            if (count == 20'hFFFFF) begin
                pbout <= sync_1;
                count <= 20'd0;
            end
        end
    end

endmodule

module countdown_fsm (
    input wire clk,
    input wire rst_clean,
    input wire [15:0] sw,
    output reg [15:0] ledo
);
    localparam S_WAIT  = 1'b0;
    localparam S_COUNT = 1'b1;

    reg state_reg, state_next;
    reg [15:0] count_reg, count_next;

    reg [26:0] tick_counter = 27'd0;
    wire tick = (tick_counter == 27'd49_999_999);

    always @(posedge clk or posedge rst_clean) begin
        if (rst_clean) begin
            tick_counter <= 27'd0;
        end else begin
            if (tick)
                tick_counter <= 27'd0;
            else
                tick_counter <= tick_counter + 1'b1;
        end
    end
    always @(posedge clk or posedge rst_clean) begin
        if (rst_clean) begin
            state_reg <= S_WAIT;
            count_reg <= 16'd0;
        end else begin
            state_reg <= state_next;
            count_reg <= count_next;
        end
    end

    always @(*) begin
        state_next = state_reg;
        count_next = count_reg;
        ledo       = 16'd0;

        case (state_reg)
            S_WAIT: begin
                ledo = 16'd0;
                if (sw > 0) begin
                    count_next = sw;
                    state_next = S_COUNT;
                end
            end

            S_COUNT: begin
                ledo = count_reg;
             
                if (tick) begin
                    if (count_reg == 16'd1) begin
                        count_next = 16'd0;
                        state_next = S_WAIT;
                    end else begin
                        count_next = count_reg - 1'b1;
                    end
                end
            end

            default: begin
                state_next = S_WAIT;
                count_next = 16'd0;
            end
        endcase
    end

endmodule