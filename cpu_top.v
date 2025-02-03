`timescale 1ns/1ps

module cpu_top (
    input  wire        clk,
    input  wire        reset,
    input  wire        load,           // General load signal
    input  wire [3:0]  addr_in,        // Address to write in register file
    input  wire [3:0]  addr_out,       // Address to read from register file
    input  wire [31:0] data_in,        // External data input (for register file)
    input  wire [4:0]  reg_out_select, // Select which register drives the bus
    input  wire        read,           // MDR read control: 0 = from bus, 1 = from memory
    output wire [31:0] bus_out,
    output wire [31:0] mdr_out
);

    // Internal signals
    wire [31:0] data_out;         // Output from register_file
    wire [31:0] pc_bus_out;       // PC -> bus
    wire [31:0] ir_bus_out;       // IR -> bus

    // Wires for each of the 16 register outputs going to the bus multiplexer
    wire [31:0] BusMuxIn_R0,  BusMuxIn_R1,  BusMuxIn_R2,  BusMuxIn_R3;
    wire [31:0] BusMuxIn_R4,  BusMuxIn_R5,  BusMuxIn_R6,  BusMuxIn_R7;
    wire [31:0] BusMuxIn_R8,  BusMuxIn_R9,  BusMuxIn_R10, BusMuxIn_R11;
    wire [31:0] BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15;

    //=========================================================================
    // 1 Register File
    //=========================================================================
    register_file reg_file (
        .clk       (clk),
        .reset     (reset),
        .addr_in   (addr_in),
        .addr_out  (addr_out),
        .load      (load),
        .enable_out(1'b1),      // Always enable register output for testing
        .data_in   (data_in),
        .data_out  (data_out)
    );

    // For illustration, we connect each of the 16 registers to the bus MUX
    // Only the one addressed by `addr_out` has valid data_out; others can be z or 0.
    // A simpler approach is to store all 16 regs in an array and do a big multiplexer,
    // but here we show a conceptual approach.

    // You can do direct assignments, or a generate block. For simplicity:
    assign BusMuxIn_R0  = (addr_out == 0) ? data_out : 32'b0;
    assign BusMuxIn_R1  = (addr_out == 1) ? data_out : 32'b0;
    assign BusMuxIn_R2  = (addr_out == 2) ? data_out : 32'b0;
    assign BusMuxIn_R3  = (addr_out == 3) ? data_out : 32'b0;
    assign BusMuxIn_R4  = (addr_out == 4) ? data_out : 32'b0;
    assign BusMuxIn_R5  = (addr_out == 5) ? data_out : 32'b0;
    assign BusMuxIn_R6  = (addr_out == 6) ? data_out : 32'b0;
    assign BusMuxIn_R7  = (addr_out == 7) ? data_out : 32'b0;
    assign BusMuxIn_R8  = (addr_out == 8) ? data_out : 32'b0;
    assign BusMuxIn_R9  = (addr_out == 9) ? data_out : 32'b0;
    assign BusMuxIn_R10 = (addr_out == 10)? data_out : 32'b0;
    assign BusMuxIn_R11 = (addr_out == 11)? data_out : 32'b0;
    assign BusMuxIn_R12 = (addr_out == 12)? data_out : 32'b0;
    assign BusMuxIn_R13 = (addr_out == 13)? data_out : 32'b0;
    assign BusMuxIn_R14 = (addr_out == 14)? data_out : 32'b0;
    assign BusMuxIn_R15 = (addr_out == 15)? data_out : 32'b0;

    //=========================================================================
    // 2 Program Counter (PC) and Instruction Register (IR)
    //=========================================================================
    pc_register pc (
        .clk        (clk),
        .reset      (reset),
        .load       (load),
        .enable_out (1'b1),
        .d          (data_in),
        .q          (),          // We aren't using q externally here
        .bus_out    (pc_bus_out)
    );

    ir_register ir (
        .clk        (clk),
        .reset      (reset),
        .load       (load),
        .enable_out (1'b1),
        .d          (data_in),
        .q          (),
        .bus_out    (ir_bus_out)
    );

    //=========================================================================
    // 3 MDR (Memory Data Register)
    //    - read=0 => load from bus
    //    - read=1 => load from memory
    //=========================================================================
    mdr mdr_unit (
        .clk        (clk),
        .clr        (reset),
        .mdr_in     (load),       // Re-using "load" as the write-enable for MDR
        .read       (read),
        .mdr_in_bus (bus_out),    // MDR sees the CPU bus as input when read=0
        .mdatain    (32'hDEADBEEF),
        .mdr_out    (mdr_out)
    );

    //=========================================================================
    // 4 System Bus
    //    - Multiplexer that selects which register’s output drives bus_out
    //=========================================================================
    bus data_bus (
        .BusMuxIn_R0   (BusMuxIn_R0),
        .BusMuxIn_R1   (BusMuxIn_R1),
        .BusMuxIn_R2   (BusMuxIn_R2),
        .BusMuxIn_R3   (BusMuxIn_R3),
        .BusMuxIn_R4   (BusMuxIn_R4),
        .BusMuxIn_R5   (BusMuxIn_R5),
        .BusMuxIn_R6   (BusMuxIn_R6),
        .BusMuxIn_R7   (BusMuxIn_R7),
        .BusMuxIn_R8   (BusMuxIn_R8),
        .BusMuxIn_R9   (BusMuxIn_R9),
        .BusMuxIn_R10  (BusMuxIn_R10),
        .BusMuxIn_R11  (BusMuxIn_R11),
        .BusMuxIn_R12  (BusMuxIn_R12),
        .BusMuxIn_R13  (BusMuxIn_R13),
        .BusMuxIn_R14  (BusMuxIn_R14),
        .BusMuxIn_R15  (BusMuxIn_R15),
        .BusMuxIn_HI   (32'b0),
        .BusMuxIn_LO   (32'b0),
        .BusMuxIn_Zhigh(32'b0),
        .BusMuxIn_Zlow (32'b0),
        .BusMuxIn_PC   (pc_bus_out),
        .BusMuxIn_IR   (ir_bus_out),
        .BusMuxIn_MDR  (mdr_out),
        .reg_out_select(reg_out_select),
        .BusMuxOut     (bus_out)
    );

endmodule
