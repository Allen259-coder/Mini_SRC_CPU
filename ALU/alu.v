`timescale 1ns / 1ps

module alu(
    input  wire [31:0] A,     // 32-bit operand A
    input  wire [31:0] B,     // 32-bit operand B
    input  wire [2:0]  op,    // operation selector
    output reg  [63:0] result,// 64-bit result (to accommodate multiplication)
    output wire        zero   // zero flag
);

    // Internal wires for each operation
    wire [31:0] and_out;
    wire [31:0] or_out;
    wire [31:0] not_out;
    wire [31:0] add_out;
    wire        add_cout;
    wire [31:0] sub_out;
    wire        sub_borrow;
    wire [63:0] mult_out;
    wire [31:0] div_quot;
    wire [31:0] div_rem;

    // AND
    assign and_out = A & B;

    // OR
    assign or_out  = A | B;

    // NOT (only on A, ignoring B for this operation)
    assign not_out = ~A;

    // ADD
    adder_32bit u_adder(
        .A(A),
        .B(B),
        .SUM(add_out),
        .COUT(add_cout)
    );

    // SUB
    subtractor_32bit u_sub(
        .A(A),
        .B(B),
        .DIFF(sub_out),
        .BORROW(sub_borrow)
    );

    // MULT
    booth_multiplier u_mult(
        .A(A),
        .B(B),
        .PRODUCT(mult_out)
    );

    // DIV
    divider u_div(
        .A(A),
        .B(B),
        .QUOTIENT(div_quot),
        .REMAINDER(div_rem)
    );

    // Multiplex the output based on `op`
    always @(*) begin
        case(op)
            3'b000: result = { 32'b0, and_out };        // AND
            3'b001: result = { 32'b0, or_out };         // OR
            3'b010: result = { 32'b0, not_out };        // NOT
            3'b011: result = { 32'b0, add_out };        // ADD
            3'b100: result = { 32'b0, sub_out };        // SUB
            3'b101: result = mult_out;                  // MULT (64-bit)
            3'b110: result = { div_rem, div_quot };     // DIV => High 32 bits = remainder, Low 32 bits = quotient
            default: result = 64'b0;                    // Unused/Default
        endcase
    end

    // Zero flag (1 if the 64-bit result is all zeroes)
    assign zero = (result == 64'b0);

endmodule
