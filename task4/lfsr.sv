// from lecture 4 slide 17

module lfsr (
    input logic           clk,
    input logic           rst,
    output logic [7:1]    data_out
);

    logic [7:1]           sreg;

    always_ff @(posedge clk, posedge rst) 
        if (rst)
            sreg <= 4'b1;
        else
            sreg <= {sreg[6:1], sreg[7] ^ sreg[3]}; 

    assign data_out = sreg;

endmodule
