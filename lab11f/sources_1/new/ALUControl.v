module ALUControl(
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7_5,
    output reg [3:0] ALUCtrl
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUCtrl = 4'b0010;                      // add (lw/sw/addi/jalr)
            2'b01: ALUCtrl = 4'b0110;                      // sub (beq/bne)
            default: case (funct3)                         // R-type
                3'b000:  ALUCtrl = funct7_5 ? 4'b0110 : 4'b0010; // sub : add
                3'b001:  ALUCtrl = 4'b0011;                // sll
                3'b111:  ALUCtrl = 4'b0000;                // and
                3'b110:  ALUCtrl = 4'b0001;                // or
                default: ALUCtrl = 4'b0010;
            endcase
        endcase
    end
endmodule
