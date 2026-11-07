`timescale 1ns/1ps
// Runs the Lab 10 FSM program (instructions.mem) on the single-cycle processor and checks
// the REAL processor state (register file, PC link, stack pointer, LEDs) - nothing is forced.
module tb_TopLevel;
    reg clk = 0, reset = 1, rst_btn = 0;
    reg [15:0] sw = 0;
    wire [15:0] led;
    integer errors = 0;
    integer tcyc = 0;

    TopLevelProcessor #(.CLK_DIV_BITS(0)) dut (.clk(clk), .reset(reset), .sw(sw), .rst_btn(rst_btn), .led(led));

    always #5 clk = ~clk;

    task check(input [8*30-1:0] name, input [31:0] got, input [31:0] expected);
        begin
            if (got === expected) $display("  PASS: %0s = %0d (0x%0h)", name, got, got);
            else begin $display("  FAIL: %0s expected 0x%0h, got 0x%0h", name, expected, got); errors = errors + 1; end
        end
    endtask

    // Per-cycle trace of what the processor really fetches/decodes (first 60 cycles after reset)
    always @(posedge clk) if (!reset) begin
        tcyc = tcyc + 1;
        if (tcyc <= 60)
            $display("cyc=%0d PC=%0d instr=%h opcode=%b rs1=x%0d rs2=x%0d rd=x%0d imm=%0d ALU=%0d RegW=%b MemW=%b",
                tcyc, dut.pc, dut.instr, dut.opcode, dut.rs1_addr, dut.rs2_addr, dut.rd_addr,
                $signed(dut.imm), dut.alu_result, dut.RegWrite, dut.MemWrite);
    end
    always @(led) $display("t=%0t  LED=%0d  (sw=%0d rst_btn=%b PC=%0d)", $time, led, sw, rst_btn, dut.pc);

    initial begin #1000000; $display("TIMEOUT"); $finish; end

    initial begin
        $dumpfile("top.vcd"); $dumpvars(0, tb_TopLevel);
        // Simulation only: shorten delay (DELAY_SHIFT 20 -> 2) by patching 'addi t2,x0,20' in instruction memory
        #1 dut.IM.memory[130] = 8'h20;  dut.IM.memory[131] = 8'h00;
        #20 reset = 0;

        // ---- Check 1: startup instructions (addi sp, s0, s1, s2) really executed ----
        repeat (5) @(posedge clk); #1;
        $display("CHECK 1: register file after startup code");
        check("x2  (sp)  = STACK_TOP 0x1F0", dut.RF.regs[2],  32'h1F0);
        check("x8  (s0)  = SW_ADDR  0x100",  dut.RF.regs[8],  32'h100);
        check("x9  (s1)  = LED_ADDR 0x104",  dut.RF.regs[9],  32'h104);
        check("x18 (s2)  = RST_ADDR 0x108",  dut.RF.regs[18], 32'h108);
        check("x0 stays zero",               dut.RF.regs[0],  32'h0);

        // ---- Check 2: countdown 3 -> 2 -> 1 -> 0 ----
        $display("CHECK 2: countdown with switches = 3");
        sw = 16'd3;
        wait (led == 16'd3); #1;
        check("LED = 3",                     led,             32'd3);
        check("x10 (a0)  = switch value 3",  dut.RF.regs[10], 32'd3);
        check("x19 (s3)  = counter 3",       dut.RF.regs[19], 32'd3);
        check("x20 (s4)  = state 1",         dut.RF.regs[20], 32'd1);
        check("x1  (ra)  = jal link PC+4=52",dut.RF.regs[1],  32'd52);
        check("x2  (sp)  = 0x1E8 (pushed)",  dut.RF.regs[2],  32'h1E8);
        wait (led == 16'd2); wait (led == 16'd1);
        sw = 16'd0;                                   // stop after this countdown
        wait (led == 16'd0); #1;
        check("LED back to 0",               led,             32'd0);
        check("x2  (sp)  restored 0x1F0",    dut.RF.regs[2],  32'h1F0);
        check("x1  (ra)  restored = 52",     dut.RF.regs[1],  32'd52);
        check("x20 (s4)  = state 0",         dut.RF.regs[20], 32'd0);

        // ---- Check 3: reset pressed mid-countdown ----
        $display("CHECK 3: reset button during countdown (switches = 5)");
        sw = 16'd5;
        wait (led == 16'd5); wait (led == 16'd4); #1;
        rst_btn = 1;
        wait (led == 16'd0); #1;
        check("LED cleared by reset",        led,             32'd0);
        check("x10 (a0)  = 1 (reset path)",  dut.RF.regs[10], 32'd1);
        check("x2  (sp)  restored 0x1F0",    dut.RF.regs[2],  32'h1F0);
        sw = 16'd0;
        #200 rst_btn = 0;
        #500;
        check("LED stays 0 when idle",       led,             32'd0);

        if (errors == 0) $display("ALL CHECKS PASSED");
        else             $display("%0d CHECK(S) FAILED", errors);
        $finish;
    end
endmodule
