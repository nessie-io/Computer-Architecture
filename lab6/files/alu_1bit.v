`timescale 1ns / 1ps

module alu_1bit(
    input  wire a,
    input  wire b,
    input  wire cin,
    input  wire sll_val, // Shift Left value passed from 32-bit top level
    input  wire srl_val, // Shift Right value passed from 32-bit top level
    input  wire [3:0] alu_ctrl,
    output reg  result,
    output wire cout
);


    wire res_and = a & b;
    wire res_or  = a | b;
    wire res_xor;
    my_xorr custom_xor(.A(a),.B(b),.result(res_xor));

    //arithmetic Operation (Addition / Subtraction)
    //If SUB (0110), invert B for Two's Complement
    wire b_eff = (alu_ctrl == 4'b0110) ? ~b : b; 
    wire res_add_sub;
    
    // Instantiate your custom Full Adder
    FA custom_adder(.A(a),.B(b_eff),.Cin(cin),.result(res_add_sub), .Cout(cout));

    //operation Mux
    always @(*) begin
        case(alu_ctrl)
            4'b0000: result = res_and;       // AND
            4'b0001: result = res_or;        // OR
            4'b0100: result = res_xor;       // XOR
            4'b0010: result = res_add_sub;   // ADD 
            4'b0110: result = res_add_sub;   // SUB 
            4'b0011: result = sll_val;       // SLL
            4'b0101: result = srl_val;       // SRL
            default: result = 1'b0;
        endcase
    end

endmodule
