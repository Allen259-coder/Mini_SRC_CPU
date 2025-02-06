module y_register (
    input wire clk,         
    input wire reset,      
    input wire load_y,           // Load enable for Y register 
    input wire [31:0] bus_data,  // Data input from the system bus
    output reg [31:0] y_out      // Data output to ALU A input
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y_out <= 32'b0;  // Clear register on reset
        end else if (load_y) begin
            y_out <= bus_data;  // Load data when enabled
        end
    end

endmodule
