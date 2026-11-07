module RegisterFile(
    input         clk, RegWrite,
    input  [4:0]  rs1, rs2, rd,
    input  [31:0] write_data,
    output [31:0] read_data1, read_data2
);
    reg [31:0] regs [0:31];
    integer i;
    initial for (i = 0; i < 32; i = i + 1) regs[i] = 32'b0;

    assign read_data1 = (rs1 == 0) ? 32'b0 : regs[rs1];
    assign read_data2 = (rs2 == 0) ? 32'b0 : regs[rs2];

    always @(posedge clk)
        if (RegWrite && rd != 0) regs[rd] <= write_data;
endmodule
