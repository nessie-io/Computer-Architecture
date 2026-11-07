module branchAdder(
    input  [31:0] pc,
    input  [31:0] imm,           // sign-extended imm[12:1] (B) or imm[20:1] (J) from immGen
    output [31:0] branch_target
);
    assign branch_target = pc + (imm << 1);
endmodule
