`timescale 1ns/1ps

module register_file (
    input  wire        clk,
    input  wire        reset,
    input  wire [3:0]  addr_in,    // Address of the register to write to
    input  wire [3:0]  addr_out,   // Address of the register to read from
    input  wire        load,       // Load enable signal
    input  wire        enable_out, // Enables data_out
    input  wire [31:0] data_in,    // Data to write
    output wire [31:0] data_out    // Data read from the selected register
);

    // 16 registers (R0 to R15)
    reg [31:0] registers [0:15];
    integer i;

    // Synchronous write logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        else if (load) begin
            registers[addr_in] <= data_in;
        end
        // No "else" clause needed. If we're not loading, the registers keep their value.
    end

    // Combinational read logic
    assign data_out = (enable_out) ? registers[addr_out] : 32'bz;

endmodule
