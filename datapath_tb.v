`timescale 1ns/1ps
module datapath_tb;

  // Control signals for the datapath.
  reg         clear, clock, incPC;
  reg         e_PC, e_IR, e_Y, e_Z, e_HI, e_LO, e_MDR, e_MAR, e_GP;
  reg  [3:0]  reg_addr;
  reg  [31:0] Mdatain;
  reg         read;
  reg  [5:0]  alu_op;         // 6-bit ALU operation code (only lower 4 bits used)
  reg  [4:0]  BusDataSelect;  // selects which register appears on the bus

  // Define simulation states corresponding to the control steps.
  localparam T0 = 3'd0,
             T1 = 3'd1,
             T2 = 3'd2,
             T3 = 3'd3,
             T4 = 3'd4,
             T5 = 3'd5;
  reg [2:0] state;

  // Bus source codes (match your bus module's case statement).
  localparam BUS_R3   = 5'd3;    // R3
  localparam BUS_R7   = 5'd7;    // R7
  localparam BUS_PC   = 5'd20;   // PC
  localparam BUS_Zlow = 5'd19;   // Z low half
  localparam BUS_MDR  = 5'd21;   // MDR

  // ALU operation code for AND.
  // In your ALU, AND is selected when op = 4'b0000.
  localparam ALU_AND = 6'b000000;

  // Instantiate the datapath.
  datapath DUT (
    .clear(clear),
    .clock(clock),
    .incPC(incPC),
    .e_PC(e_PC),
    .e_IR(e_IR),
    .e_Y(e_Y),
    .e_Z(e_Z),
    .e_HI(e_HI),
    .e_LO(e_LO),
    .e_MDR(e_MDR),
    .e_MAR(e_MAR),
    .e_GP(e_GP),
    .reg_addr(reg_addr),
    .Mdatain(Mdatain),
    .read(read),
    .alu_op(alu_op),
    .BusDataSelect(BusDataSelect)
  );

  // Clock generation using an always block.
  initial begin
    clock = 0;
  end
  always #10 clock = ~clock;  // Toggle clock every 10 ns (20 ns period)

  // Initial conditions: assert reset and initialize control signals.
  initial begin
    clear         = 1;
    incPC         = 0;
    e_PC          = 0;
    e_IR          = 0;
    e_Y           = 0;
    e_Z           = 0;
    e_HI          = 0;
    e_LO          = 0;
    e_MDR         = 0;
    e_MAR         = 0;
    e_GP          = 0;
    reg_addr      = 4'd0;
    Mdatain       = 32'd0;
    read          = 0;
    alu_op        = 6'b0;
    BusDataSelect = 5'd0;
    state         = T0;
    
    #15 clear = 0; // Release reset after 15 ns.
  end

  // FSM: Advance through the control states on each rising clock edge.
  always @(posedge clock) begin
    case (state)
      T0: state <= T1;
      T1: state <= T2;
      T2: state <= T3;
      T3: state <= T4;
      T4: state <= T5;
      T5: state <= T5;  // Remain in T5 indefinitely.
      default: state <= T0;
    endcase
  end

  // Drive control signals based on the current state.
  always @(*) begin
    // Default (inactive) assignments.
    incPC         = 0;
    e_PC          = 0;
    e_IR          = 0;
    e_Y           = 0;
    e_Z           = 0;
    e_HI          = 0;
    e_LO          = 0;
    e_MDR         = 0;
    e_MAR         = 0;
    e_GP          = 0;
    reg_addr      = 4'd0;
    Mdatain       = 32'd0;
    read          = 0;
    alu_op        = 6'b0;
    BusDataSelect = 5'd0;
    
    case (state)
      T0: begin
        // T0: PCout, MARin, IncPC, Zin.
        BusDataSelect = BUS_PC;  // Drive the PC value onto the bus.
        e_MAR         = 1;       // Load MAR with the bus value.
        incPC         = 1;       // Increment the PC.
        e_Z           = 1;       // Load Z (typically with PC+offset).
      end
      T1: begin
        // T1: Zlowout, PCin, Read, MDRin.
        BusDataSelect = BUS_Zlow; // Drive the low half of Z onto the bus.
        e_PC          = 1;        // Load the PC.
        read          = 1;        // Initiate a memory read.
        e_MDR         = 1;        // Load the MDR.
        Mdatain       = 32'h2A2B8000; // Instruction code for "and R4, R3, R7".
      end
      T2: begin
        // T2: MDRout, IRin.
        BusDataSelect = BUS_MDR;  // Drive MDR onto the bus.
        e_IR          = 1;        // Load the IR.
      end
      T3: begin
        // T3: R3out, Yin.
        BusDataSelect = BUS_R3;   // Drive R3 onto the bus.
        e_Y           = 1;        // Load Y.
      end
      T4: begin
        // T4: R7out, AND, Zin.
        BusDataSelect = BUS_R7;   // Drive R7 onto the bus.
        alu_op        = ALU_AND;  // Set the ALU to perform an AND operation.
        e_Z           = 1;        // Load Z with the ALU result.
      end
      T5: begin
        // T5: Zlowout, R4in.
        BusDataSelect = BUS_Zlow; // Drive the low half of Z onto the bus.
        reg_addr      = 4'd4;     // Select register R4.
        e_GP          = 1;        // Write the bus value into R4.
      end
    endcase
  end

  // End simulation after sufficient time.
  initial begin
    #300 $finish;
  end

endmodule
