`timescale 1ns/1ps
module tb_Task1;
    reg clk = 0, reset = 1, PCSrc = 0;
    reg [31:0] instr;
    wire [31:0] pc, pc_plus4, branch_target, pc_next, imm;

    ProgramCounter PC(.clk(clk), .reset(reset), .pc_next(pc_next), .pc(pc));
    pcAdder        PA(.pc(pc), .pc_plus4(pc_plus4));
    immGen         IG(.instr(instr), .imm(imm));
    branchAdder    BA(.pc(pc), .imm(imm), .branch_target(branch_target));
    mux2           M (.d0(pc_plus4), .d1(branch_target), .sel(PCSrc), .y(pc_next));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("task1.vcd"); $dumpvars(0, tb_Task1);
        instr = 32'h00500093;              // addi x1,x0,5
        #12 reset = 0;
        repeat (3) @(posedge clk);
        #1 $display("PC after 3 clocks (PCSrc=0) = %0d (expect 12)", pc);
        instr = 32'h00338463; PCSrc = 1;   // beq x7,x3,+8
        #1 $display("B-imm = %0d (expect 4), target = %0d (expect 20)", imm, branch_target);
        @(posedge clk); #1 $display("PC after branch = %0d (expect 20)", pc);
        PCSrc = 0;
        instr = 32'hFFF00093; #1 $display("I-type -1  : %0d (expect -1)", $signed(imm));
        instr = 32'h00500093; #1 $display("I-type  5  : %0d (expect 5)",  $signed(imm));
        instr = 32'hFE302E23; #1 $display("S-type -4  : %0d (expect -4)", $signed(imm));
        instr = 32'h00302223; #1 $display("S-type  4  : %0d (expect 4)",  $signed(imm));
        instr = 32'hFE338EE3; #1 $display("B-type -4  : %0d (expect -2 => offset -4)", $signed(imm));
        instr = 32'h008000ef; #1 $display("J-type +8  : %0d (expect 4 => offset 8)", $signed(imm));
        #20 $finish;
    end
endmodule
