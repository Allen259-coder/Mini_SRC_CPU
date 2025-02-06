`timescale 1ns/1ps

module datapath (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [3:0] addr_in,
    input wire [3:0] addr_out,
    input wire [31:0] data_in,
    input wire [4:0] reg_out_select,
    input wire read,
    input wire alu_op,
    output wire [31:0] bus_out,
    output wire [31:0] mdr_out
);

    // Internal signals
    wire [31:0] data_out;
    wire [31:0] pc_bus_out;
    wire [31:0] ir_bus_out;
    wire [31:0] mdr_bus_out;
    wire [31:0] mar_bus_out;
    wire [63:0] z_out;
    wire [31:0] hi_bus_out, lo_bus_out;
    
    // Wires for register file outputs
    wire [31:0] BusMuxIn_R [15:0];

    // Register File
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .addr_in(addr_in),
        .addr_out(addr_out),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Special Registers
    special_registers spec_regs (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_bus_out),
        .ir_out(ir_bus_out)
    );

    // HI and LO Registers
    hi_register hi_reg (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data_in(data_in),
        .data_out(hi_bus_out)
    );

    lo_register lo_reg (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data_in(data_in),
        .data_out(lo_bus_out)
    );

    // MAR and MDR
    mar mar_unit (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data_in(bus_out),
        .data_out(mar_bus_out)
    );

    mdr mdr_unit (
        .clk(clk),
        .clr(reset),
        .mdr_in(load),
        .read(read),
        .mdr_in_bus(bus_out),
        .mdatain(32'hDEADBEEF),
        .mdr_out(mdr_bus_out)
    );

    // ALU
    alu alu_unit (
        .A(bus_out),
        .B(data_out),
        .op(alu_op),
        .result(z_out)
    );

    // Z Register
    z_register z_reg (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data_in(z_out),
        .data_out({BusMuxIn_Zhigh, BusMuxIn_Zlow})
    );

    // System Bus
    bus data_bus (
        .BusMuxIn_R0(BusMuxIn_R[0]), .BusMuxIn_R1(BusMuxIn_R[1]),
        .BusMuxIn_R2(BusMuxIn_R[2]), .BusMuxIn_R3(BusMuxIn_R[3]),
        .BusMuxIn_R4(BusMuxIn_R[4]), .BusMuxIn_R5(BusMuxIn_R[5]),
        .BusMuxIn_R6(BusMuxIn_R[6]), .BusMuxIn_R7(BusMuxIn_R[7]),
        .BusMuxIn_R8(BusMuxIn_R[8]), .BusMuxIn_R9(BusMuxIn_R[9]),
        .BusMuxIn_R10(BusMuxIn_R[10]), .BusMuxIn_R11(BusMuxIn_R[11]),
        .BusMuxIn_R12(BusMuxIn_R[12]), .BusMuxIn_R13(BusMuxIn_R[13]),
        .BusMuxIn_R14(BusMuxIn_R[14]), .BusMuxIn_R15(BusMuxIn_R[15]),
        .BusMuxIn_HI(hi_bus_out), .BusMuxIn_LO(lo_bus_out),
        .BusMuxIn_Zhigh(BusMuxIn_Zhigh), .BusMuxIn_Zlow(BusMuxIn_Zlow),
        .BusMuxIn_PC(pc_bus_out), .BusMuxIn_IR(ir_bus_out),
        .BusMuxIn_MDR(mdr_bus_out),
        .reg_out_select(reg_out_select),
        .BusMuxOut(bus_out)
    );

endmodule
