// Data memory (stack/RAM 0x000-0x1FF) with the Lab 10 memory-mapped I/O:
//   0x100 : switches (read)     0x104 : LEDs (write/read)     0x108 : reset button (read)
module DataMemory(
    input         clk, MemRead, MemWrite,
    input  [31:0] addr, write_data,
    input  [15:0] sw_in,
    input         rst_in,
    output [31:0] read_data,
    output reg [15:0] led_out
);
    localparam SW_ADDR  = 32'h100;
    localparam LED_ADDR = 32'h104;
    localparam RST_ADDR = 32'h108;

    reg [31:0] ram [0:127];
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) ram[i] = 32'b0;
        led_out = 16'b0;
    end

    assign read_data = !MemRead          ? 32'b0 :
                       (addr == SW_ADDR)  ? {16'b0, sw_in}  :
                       (addr == LED_ADDR) ? {16'b0, led_out} :
                       (addr == RST_ADDR) ? {31'b0, rst_in} :
                                            ram[addr[8:2]];

    always @(posedge clk) begin
        if (MemWrite) begin
            if (addr == LED_ADDR)                          led_out <= write_data[15:0];
            else if (addr != SW_ADDR && addr != RST_ADDR)  ram[addr[8:2]] <= write_data;
        end
    end
endmodule
