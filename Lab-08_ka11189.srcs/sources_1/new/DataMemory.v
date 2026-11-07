`timescale 1ns / 1ps

module DataMemory(
    input clk,
    input rst,
    input MemWrite,
    input [8:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

    reg [31:0] mem_array [511:0];
    
    assign read_data = mem_array[address];

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 512; i = i + 1)
                mem_array[i] <= 32'b0;
        end else if (MemWrite) begin
            mem_array[address] <= write_data;
        end
    end

endmodule