module ControlUnit(
    input  [6:0] opcode,
    output reg   Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Jal, Jalr,
    output reg [1:0] ALUOp
);
    always @(*) begin
        Branch=0; MemRead=0; MemtoReg=0; MemWrite=0; ALUSrc=0; RegWrite=0; Jal=0; Jalr=0; ALUOp=2'b00;
        case (opcode)
            7'b0110011: begin RegWrite=1; ALUOp=2'b10; end                                   // R-type (add/sub/and/or/sll)
            7'b0010011: begin RegWrite=1; ALUSrc=1; end                                      // addi
            7'b0000011: begin RegWrite=1; ALUSrc=1; MemRead=1; MemtoReg=1; end               // lw
            7'b0100011: begin ALUSrc=1; MemWrite=1; end                                      // sw
            7'b1100011: begin Branch=1; ALUOp=2'b01; end                                     // beq / bne
            7'b1101111: begin RegWrite=1; Jal=1; end                                         // jal
            7'b1100111: begin RegWrite=1; Jalr=1; ALUSrc=1; end                              // jalr
            default: ;
        endcase
    end
endmodule
