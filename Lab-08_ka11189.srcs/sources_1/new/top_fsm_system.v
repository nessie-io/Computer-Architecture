`timescale 1ns / 1ps

module top_fsm_system(
    input clk,
    input rst_btn,
    input step_btn,
    input [15:0] sw_in,
    output [15:0] leds
);

    wire debounced_step;
    
    debouncer d_btn (
        .clk(clk),
        .pbin(step_btn),
        .pbout(debounced_step)
    );

    reg [31:0] test_address;
    reg test_write_en;
    reg test_read_en;
    reg [31:0] test_write_data;
    wire [31:0] test_read_data;
    wire [15:0] core_leds;

    addressDecoderTop core_sys (
        .clk(clk),
        .rst(rst_btn),
        .address(test_address),
        .readEnable(test_read_en),
        .writeEnable(test_write_en),
        .writeData(test_write_data),
        .switches(sw_in),
        .readData(test_read_data),
        .leds(core_leds)
    );

    reg [2:0] demo_state;
    reg [15:0] saved_leds = 16'b0;
    reg prev_sw15 = 0;

    always @(posedge clk or posedge rst_btn) begin
        if (rst_btn) begin
            demo_state <= 3'd0;
            test_address <= 32'h0;
            test_write_en <= 1'b0;
            test_read_en <= 1'b0;
            test_write_data <= 32'h0;
            saved_leds <= 16'b0;
            prev_sw15 <= 0;
        end else begin
            prev_sw15 <= sw_in[15];

            if ((demo_state == 3'd2) && sw_in[15] && !prev_sw15) begin
                saved_leds <= core_leds;
            end

            if (debounced_step) begin
                case(demo_state)
                    3'd0: begin
                        test_address <= 32'h00000005;
                        test_write_data <= {16'b0, sw_in};
                        test_write_en <= 1'b1;
                        test_read_en <= 1'b0;
                        demo_state <= 3'd1;
                    end
                    3'd1: begin
                        test_write_en <= 1'b0;
                        test_read_en <= 1'b1;
                        test_address <= 32'h00000005;
                        demo_state <= 3'd2;
                    end
                    3'd2: begin
                        test_read_en <= 1'b0;
                        test_address <= 32'h00000100;
                        test_write_data <= test_read_data;
                        test_write_en <= 1'b1;
                        demo_state <= 3'd3;
                    end
                    3'd3: begin
                        test_write_en <= 1'b0;
                        test_address <= 32'h00000300;
                        test_read_en <= 1'b1;
                        demo_state <= 3'd0;
                    end
                    default: demo_state <= 3'd0;
                endcase
            end
        end
    end

    assign leds = sw_in[15] ? saved_leds : core_leds;

endmodule