`timescale 1ns / 1ps

module alu_tb();

    // Test Inputs
    reg  [31:0] A;
    reg  [31:0] B;
    reg  [2:0]  op;

    // Outputs
    wire [63:0] result;
    wire        zero_flag;

    // Instantiate the ALU
    alu uut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero(zero_flag)
    );

    initial begin
        // Display header
        $display("Time   |    op    |       A       |       B       |               result               | zero_flag");
        $display("-----------------------------------------------------------------------------------------------");

        // 1 AND operation with inputs A = 0xA5A5A5A5 and B = 0x5A5A5A5A
        A = 32'hA5A5A5A5;
        B = 32'h5A5A5A5A;
        op = 3'b000; // AND
        #10;
        $display("%0dns | AND(000) | %h | %h | result = %h (hex), %d (dec), zero=%b", 
                 $time, A, B, result[31:0], result[31:0], zero_flag);

        // 2 OR operation with inputs A = 0xA5A5A5A5 and B = 0x5A5A5A5A
        A = 32'hA5A5A5A5;
        B = 32'h5A5A5A5A;
        op = 3'b001; // OR
        #10;
        $display("%0dns | OR (001) | %h | %h | result = %h (hex), %d (dec), zero=%b", 
                 $time, A, B, result[31:0], result[31:0], zero_flag);

        // 3 NOT operation on A = 0xFFFFFFFF (B is ignored)
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        op = 3'b010; // NOT
        #10;
        $display("%0dns | NOT(010) | %h | %h | result = %h (hex), %d (dec), zero=%b", 
                 $time, A, B, result[31:0], result[31:0], zero_flag);

        // 4 Addition with A = 10 and B = 5
        A = 32'd10;
        B = 32'd5;
        op = 3'b011; // ADD
        #10;
        $display("%0dns | ADD(011) | %d | %d | result = %d (dec), 0x%h (hex), zero=%b", 
                 $time, A, B, result[31:0], result[31:0], zero_flag);

        // 5 Subtraction with A = 10 and B = 5
        A = 32'd10;
        B = 32'd5;
        op = 3'b100; // SUB
        #10;
        $display("%0dns | SUB(100) | %d | %d | result = %d (dec), 0x%h (hex), zero=%b", 
                 $time, A, B, result[31:0], result[31:0], zero_flag);

        // 6 Multiplication with A = 7 and B = 6
        A = 32'd7;
        B = 32'd6;
        op = 3'b101; // MULT
        #10;
        $display("%0dns | MUL(101) | %d | %d | result = %d (dec), 0x%h (hex), zero=%b", 
                 $time, A, B, result, result, zero_flag);

        // 7 Division with A = 42 and B = 6
        A = 32'd42;
        B = 32'd6;
        op = 3'b110; // DIV
        #10;
        // Lower 32 bits = Quotient, Upper 32 bits = Remainder
        $display("%0dns | DIV(110) | %d | %d | quotient=%d, remainder=%d, 0x%h (hex), zero=%b",
                 $time, A, B, result[31:0], result[63:32], result, zero_flag);

        // End of Simulation
        $stop;
    end
endmodule
