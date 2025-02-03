`timescale 1ns/1ps

module mdr (
    input  wire        clk,         // Clock signal
    input  wire        clr,         // Asynchronous clear/reset (active high)
    input  wire        mdr_in,      // Write enable for MDR
    input  wire        read,        // 0 = load from bus, 1 = load from memory
    input  wire [31:0] mdr_in_bus,  // Data from the CPU bus
    input  wire [31:0] mdatain,     // Data from memory
    output reg  [31:0] mdr_out      // Output of MDR
);

    always @(posedge clk or posedge clr) begin
        if (clr) begin
            mdr_out <= 32'b0;
        end
        else if (mdr_in) begin
            if (read)
                mdr_out <= mdatain;    // Load from memory
            else
                mdr_out <= mdr_in_bus; // Load from bus
        end
    end

endmodule
