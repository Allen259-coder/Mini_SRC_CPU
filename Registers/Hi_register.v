`timescale 1ns / 1ps

module hi_register (
    input wire clk,
    input wire clr,      // Reset signal
    input wire hi_in,    // Write enable signal
    input wire [31:0] hi_in_bus,  // Input data
    output reg [31:0] hi_out      // Output data
);

    always @(posedge clk or posedge clr) begin
        if (clr)
            hi_out <= 32'b0;  // Reset HI register
        else if (hi_in)
            hi_out <= hi_in_bus;  // Store upper bits
    end

endmodule
