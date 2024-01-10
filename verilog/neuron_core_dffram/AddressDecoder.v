module AddressDecoder (
`ifdef USE_POWER_PINS
    inout VPWR,    // User area 1 1.8V supply
    inout VGND,    // User area 1 digital ground
`endif    
    input [31:0] addr,
    output reg synap_matrix,
    output reg [4:0] param_num,   // Will be valid only if address is in param range
    output reg neuron_spike_out,
    output reg param

);

    always @(addr) begin
        // Default outputs to 0
        synap_matrix = 0;
        param = 0;
        param_num = 5'b0;
        neuron_spike_out = 0;

        if(addr[31:15] == 17'h6000) begin
                    // Decode based on addr[14:13] begin
                case(addr[14:13])
                    2'b00:  if(addr[12:10] <= 3'b000) synap_matrix = 1;
                    2'b01: if(addr[12:4] == 9'd0 && !(&addr[3:2]))begin
                                param = 1;
                                param_num = addr[8:4];
                            end
                    2'b10: if(addr[12:2] <= 11'd0) neuron_spike_out = 1;
                    default: ; // Do nothing, outputs remain 0
                endcase
        end

    end 

endmodule

