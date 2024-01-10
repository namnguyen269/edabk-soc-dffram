module synapse_matrix_design (
`ifdef USE_POWER_PINS
    inout VPWR,    // User area 1 1.8V supply
    inout VGND,    // User area 1 digital ground
`endif
    
    // Wishbone slave interface
    input wb_clk_i,             // Clock
    input wb_rst_i,             // Reset
    input wbs_cyc_i,            // Indicates an active Wishbone cycle
    input wbs_stb_i,            // Active during a valid address phase
    input wbs_we_i,             // Determines read or write operation
    input [3:0] wbs_sel_i,      // Byte lanes selector (expected as 4'b1111)
    input [31:0] wbs_adr_i,     // Address input
    input [31:0] wbs_dat_i,     // Data input for writes
    output reg wbs_ack_o,       // Acknowledgment for data transfer
    output reg [31:0] wbs_dat_o, // Data output (not used in this module)

    // Synapse matrix specific output
    output [31:0] neurons_connections_o  // Represents connections of an axon with 32 neurons
);
wire [7:0] addr = wbs_adr_i[9:2];
wire [3:0] we0;
assign we0 = wbs_we_i?wbs_sel_i:4'd0;
DFFRAM256x32 sram0 (
`ifdef USE_POWER_PINS
    .VPWR (VPWR),    // User area 1 1.8V supply
    .VGND (VGND),    // User area 1 digital ground
`endif
    .CLK(wb_clk_i),     // Clock
    .WE0(we0),    // Write Enable
    .EN0(wbs_cyc_i & wbs_stb_i), // Chip Enable
    .Di0(wbs_dat_i),    // Data Input
    .Do0(wbs_dat_o),           // Data Output
    .A0(addr)        // Address
    // Removed the trailing comma and empty lines
);

always @(negedge wb_clk_i or posedge wb_rst_i) begin
    if(wb_rst_i) begin
        wbs_ack_o <= 1'b0;
    end else begin
        if (wbs_cyc_i && wbs_stb_i) begin
            wbs_ack_o <= 1'b1;
        end
        else
            wbs_ack_o <= 1'b0;
    end
end
// Generating the connections based on the input address during read operations
// Outputs all zeros when there's a write operation or an invalid Wishbone transaction
assign neurons_connections_o = (!(|we0) && wbs_cyc_i && wbs_stb_i) ? 
            wbs_dat_o : 32'b0;  // Simplified connection generation for 32 neurons

endmodule

