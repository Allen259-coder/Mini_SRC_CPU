module datapath(
	input wire clear, clock, incPC,
	
	//register write enable signals
	input wire e_PC, e_IR, e_Y, e_Z, e_HI, e_LO, e_MDR, e_MAR, e_GP,
	
	input wire [3:0] reg_addr,
	
	input wire [31:0] Mdatain,
	input wire read,

	input wire [3:0] alu_op,
	
	//data signals
	input wire [4:0] BusDataSelect

);

	wire [31:0] GP_r0, GP_r1, GP_r2, GP_r3, GP_r4, GP_r5, GP_r6, GP_r7, GP_r8, GP_r9, GP_r10, GP_r11, GP_r12, GP_r13, GP_r14, GP_r15;
	
	wire [31:0] BusData, BusIn_R0, BusIn_R1, BusIn_R2, BusIn_R3, BusIn_R4, BusIn_R5, BusIn_R6, BusIn_R7;
	wire [31:0] BusIn_R8, BusIn_R9, BusIn_R10, BusIn_R11, BusIn_R12, BusIn_R13, BusIn_R14, BusIn_R15;
	wire [31:0] BusIn_HI, BusIn_LO, BusIn_Zhigh, BusIn_Zlow, BusIn_PC, BusIn_MDR;
	
	wire [31:0] ALU_A;
	wire [63:0] z_out;

	//general purpose 32 bit registers
	register_file GP_reg (
		clear,
		clock,
		reg_addr,
		e_GP,
		BusData,
		GP_r0, GP_r1, GP_r2, GP_r3,
		GP_r4, GP_r5, GP_r6, GP_r7,
		GP_r8, GP_r9, GP_r10, GP_r11,
		GP_r12, GP_r13, GP_r14, GP_r15
	);
	
	assign BusIn_R0 = GP_r0;
	assign BusIn_R1 = GP_r1;
	assign BusIn_R2 = GP_r2;
	assign BusIn_R3 = GP_r1;
	assign BusIn_R4 = GP_r4;
	assign BusIn_R5 = GP_r5;
	assign BusIn_R6 = GP_r6;
	assign BusIn_R7 = GP_r7;
	assign BusIn_R8 = GP_r8;
	assign BusIn_R9 = GP_r9;
	assign BusIn_R10 = GP_r10;
	assign BusIn_R11 = GP_r11;
	assign BusIn_R12 = GP_r12;
	assign BusIn_R13 = GP_r13;
	assign BusIn_R14 = GP_r14;
	assign BusIn_R15 = GP_r15;

	register Y(clock, clear, e_Y, BusData, ALU_A);

    // HI and LO Registers
    hi_register hi_reg (
        .clk(clock),
        .clr(clear),
        .hi_in(e_HI),
        .hi_in_bus(BusData),
        .hi_out(BusIn_HI)
    );

    lo_register lo_reg (
        .clk(clock),
        .clr(clear),
        .lo_in(e_LO),
        .lo_in_bus(BusData),
        .lo_out(BusIn_LO)
    );

    // MAR and MDR
    mar mar_unit (
        .clk(clock),
        .clr(clear),
        .mar_in(e_MAR),
        .bus_in(BusData),
        .mar_out()
    );

    
    // ALU
    alu alu_unit (
        .A(ALU_A),
        .B(BusData),
        .op(alu_op),
        .result(z_out)
    );

    // Z Register
    z_register z_reg (
        .clk(clock),
        .reset(clear),
        .load(e_Z),
        .d(z_out),
        .zhigh(BusMuxIn_Zhigh),
		.zlow(BusMuxIn_Zlow)
    );

	//memory "gateway"
	//register_32 MAR(clear, clock, e_MAR, BusData, toMemory);
	mdr MDR(clear, clock, e_MDR, read, BusData, Mdatain, BusIn_MDR);
	
	//bus
	bus bus(.data_select(BusDataSelect), .BusMuxIn_R0(BusIn_R0), .BusMuxIn_R1(BusIn_R1), .BusMuxIn_R2(BusIn_R2), .BusMuxIn_R3(BusIn_R3),
		.BusMuxIn_R4(BusIn_R4), .BusMuxIn_R5(BusIn_R5), .BusMuxIn_R6(BusIn_R6), .BusMuxIn_R7(BusIn_R7), .BusMuxIn_R8(BusIn_R8), .BusMuxIn_R9(BusIn_R9),
		.BusMuxIn_R10(BusIn_R10), .BusMuxIn_R11(BusIn_R11), .BusMuxIn_R12(BusIn_R12), .BusMuxIn_R13(BusIn_R13), .BusMuxIn_R14(BusIn_R14),
		.BusMuxIn_R15(BusIn_R15), .BusMuxIn_HI(BusIn_HI), .BusMuxIn_LO(BusIn_LO), .BusMuxIn_Zhigh(BusIn_Zhigh), .BusMuxIn_Zlow(BusIn_Zlow),
		.BusMuxIn_PC(BusIn_PC), .BusMuxIn_MDR(BusIn_MDR), .BusMuxOut(BusData));
	
endmodule
