`timescale 1ns/1ps

module z_register (
    input  wire        clk,      // Clock signal
    input  wire        reset,    // Reset signal
    input  wire        load,     // Load enable
    input  wire [63:0] d,        // 64-bit data input
    output reg  [63:0] q,        // 64-bit stored output
    output wire [31:0] zhigh,    // Upper 32-bits output
    output wire [31:0] zlow      // Lower 32-bits output
);
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 64'b0;    // Clear register on reset
        else if (load)
            q <= d;        // Load data into register when enabled
    end
    
    assign zhigh = q[63:32]; // Upper 32 bits
    assign zlow  = q[31:0];  // Lower 32 bits
    
endmodule
