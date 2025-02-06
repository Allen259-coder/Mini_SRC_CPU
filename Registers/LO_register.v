`timescale 1ns / 1ps

module lo_register (
    input wire clk,
    input wire clr,      // Reset signal
    input wire lo_in,    // Write enable signal
    input wire [31:0] lo_in_bus,  // Input data
    output reg [31:0] lo_out      // Output data
);

    always @(posedge clk or posedge clr) begin
        if (clr)
            lo_out <= 32'b0;  // Reset LO register
        else if (lo_in)
            lo_out <= lo_in_bus;  // Store lower bits
    end

endmodule
