module immGen(
    input  [31:0] instr,
    output reg [31:0] imm
);
    always @(*) begin
        case (instr[6:0])
            7'b0000011,                                   // lw
            7'b0010011,                                   // addi
            7'b1100111: imm = {{20{instr[31]}}, instr[31:20]};                                  // jalr (I-type)
            7'b0100011: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};                     // sw   (S-type)
            7'b1100011: imm = {{20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8]};// beq/bne (B-type) = imm[12:1]
            7'b1101111: imm = {{12{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21]}; // jal (J-type) = imm[20:1]
            default:    imm = 32'b0;
        endcase
    end
endmodule
