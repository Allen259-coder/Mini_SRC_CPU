module ProgramCounter (
    input wire [31:0] BusMuxOut,     // Input from bus
    input wire clr,                 
    input wire en,                   
    input wire clk,                 
    input wire inc,                // Increment PC
  output reg [31:0] PC             // PC output
);

    always @(posedge clk) begin
        if (clr) begin
            PC <= 32'b0;              // Clear PC when clr and clock is high
        end 
        else if (en) begin
            if (inc) begin
                PC <= PC + 1;         // Increment PC by 1 when en is high
            end 
            else begin
                PC <= BusMuxOut;      // Load value from the system bus instead 
            end
        end
    end

endmodule
