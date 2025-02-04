`timescale 1ns/1ps

module mar (
    input  wire        clk,       // Clock signal
    input  wire        clr,       // Asynchronous clear/reset (active high)
    input  wire        mar_in,    // Write enable for MAR
    input  wire [31:0] bus_in,    // Data from the bus
    output reg  [31:0] mar_out    // Address output from MAR
);

always @(posedge clk or posedge clr) begin
    if (clr) begin
        mar_out <= 32'b0;
    end else if (mar_in) begin
        mar_out <= bus_in;  // Load address from the bus
    end
end

endmodule
