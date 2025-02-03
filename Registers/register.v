`timescale 1ns/1ps

module register (
    input  wire        clk,
    input  wire        reset,       // Asynchronous reset
    input  wire        load,        // Load enable
    input  wire        enable_out,  // Drive bus_out if enabled
    input  wire [31:0] d,
    output reg [31:0]  q,           // Stored value
    output reg [31:0]  bus_out
);

    // Synchronous load / reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 32'b0;
        end else if (load) begin
            q <= d;
        end
    end

    // Drive bus combinationally
    always @(*) begin
        if (enable_out)
            bus_out = q;
        else
            bus_out = 32'bz;
    end

endmodule
