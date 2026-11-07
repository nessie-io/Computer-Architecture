module TopLevelProcessor #(
    parameter CLK_DIV_BITS = 2        // CPU clock = board clock / 2^CLK_DIV_BITS (2 -> 25 MHz). 0 = no divider (simulation)
)(
    input         clk,                // board clock (100 MHz)
    input         reset,              // CPU reset (button)
    input  [15:0] sw,                 // switches   -> MMIO 0x100
    input         rst_btn,            // FSM reset  -> MMIO 0x108
    output [15:0] led                 // LEDs       <- MMIO 0x104
);
    // ---------------- optional clock divider (single-cycle path is long) ----------------
    reg [7:0] div_cnt = 8'b0;
    always @(posedge clk) div_cnt <= div_cnt + 1'b1;
    wire clk_cpu;
    generate
        if (CLK_DIV_BITS == 0) begin : no_div
            assign clk_cpu = clk;
        end else begin : with_div
            assign clk_cpu = div_cnt[CLK_DIV_BITS-1];
        end
    endgenerate

    // ---------------- input synchronizers ----------------
    reg [15:0] sw_s1 = 16'b0, sw_s2 = 16'b0;
    reg        rb_s1 = 1'b0,  rb_s2 = 1'b0;
    always @(posedge clk_cpu) begin
        sw_s1 <= sw;       sw_s2 <= sw_s1;
        rb_s1 <= rst_btn;  rb_s2 <= rb_s1;
    end

    // ---------------- wires ----------------
    wire [31:0] pc, pc_next, pc_plus4, branch_target, pc_br, instr, imm;
    wire [31:0] rd1, rd2, alu_b, alu_result, mem_rdata, wb_mem, wb_data;
    wire        Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Jal, Jalr, zero;
    wire [1:0]  ALUOp;
    wire [3:0]  ALUCtrl;

    // ---------------- decoded instruction fields (visible in waveform) ----------------
    wire [6:0] opcode   = instr[6:0];
    wire [4:0] rd_addr  = instr[11:7];
    wire [2:0] funct3   = instr[14:12];
    wire [4:0] rs1_addr = instr[19:15];
    wire [4:0] rs2_addr = instr[24:20];
    wire       funct7_5 = instr[30];

    // ---------------- PC path ----------------
    ProgramCounter PC (.clk(clk_cpu), .reset(reset), .pc_next(pc_next), .pc(pc));
    pcAdder        PA (.pc(pc), .pc_plus4(pc_plus4));
    branchAdder    BA (.pc(pc), .imm(imm), .branch_target(branch_target));

    // beq (funct3[0]=0) taken when zero=1 ; bne (funct3[0]=1) taken when zero=0
    wire branch_taken = Branch & (zero ^ funct3[0]);
    wire PCSrc        = branch_taken | Jal;
    mux2 PCMUX   (.d0(pc_plus4), .d1(branch_target), .sel(PCSrc), .y(pc_br));
    mux2 JALRMUX (.d0(pc_br), .d1({alu_result[31:1], 1'b0}), .sel(Jalr), .y(pc_next));

    // ---------------- fetch / decode (Lab 10 instruction memory) ----------------
    instructionMemory IM (.instAddress(pc), .instruction(instr));

    ControlUnit CU (.opcode(opcode), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg),
                    .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite),
                    .Jal(Jal), .Jalr(Jalr), .ALUOp(ALUOp));
    immGen IG (.instr(instr), .imm(imm));
    RegisterFile RF (.clk(clk_cpu), .RegWrite(RegWrite), .rs1(rs1_addr), .rs2(rs2_addr),
                     .rd(rd_addr), .write_data(wb_data), .read_data1(rd1), .read_data2(rd2));

    // ---------------- execute ----------------
    mux2 ALUSRCMUX (.d0(rd2), .d1(imm), .sel(ALUSrc), .y(alu_b));
    ALUControl AC (.ALUOp(ALUOp), .funct3(funct3), .funct7_5(funct7_5), .ALUCtrl(ALUCtrl));
    ALU alu (.a(rd1), .b(alu_b), .ctrl(ALUCtrl), .result(alu_result), .zero(zero));

    // ---------------- memory / MMIO / write-back ----------------
    DataMemory DM (.clk(clk_cpu), .MemRead(MemRead), .MemWrite(MemWrite), .addr(alu_result),
                   .write_data(rd2), .sw_in(sw_s2), .rst_in(rb_s2),
                   .read_data(mem_rdata), .led_out(led));
    mux2 WBMUX   (.d0(alu_result), .d1(mem_rdata), .sel(MemtoReg), .y(wb_mem));
    mux2 LINKMUX (.d0(wb_mem), .d1(pc_plus4), .sel(Jal | Jalr), .y(wb_data));   // jal/jalr write PC+4 to rd
endmodule
