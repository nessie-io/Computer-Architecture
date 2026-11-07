
`timescale 1ns / 1ps

module AddressDecoder(
    input [9:0] address,
    input MemRead,
    input MemWrite,
    output DataMemRead,
    output DataMemWrite,
    output LEDWrite,
    output SwitchReadEnable
);

    wire [1:0] device_select = address[9:8];

    assign DataMemWrite     = (device_select == 2'b00) ? MemWrite : 1'b0;
    assign DataMemRead      = (device_select == 2'b00) ? MemRead  : 1'b0;
    assign LEDWrite         = (device_select == 2'b01) ? MemWrite : 1'b0;
    assign SwitchReadEnable = (device_select == 2'b10) ? MemRead  : 1'b0;

endmodule