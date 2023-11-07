// from lecture 4 slide 17

module lfsr (
    input logic           clk,
    input logic           rst,
    input logic           en,
    // output logic [4:1]    data_out // non challenge
    output logic [7:1]    data_out // challenge
);

    // logic [4:1]           sreg; // non challenge
    logic [7:1]           sreg; // challenge

    always_ff @(posedge clk, posedge rst) 
        /* wrong version: cannot put if (en) outside the if (rst)
        if (en)
            if (rst)
                sreg <= 4'b1;
            else
                sreg <= {sreg[3:1], sreg[4] ^ sreg[3]}; 
        */ 

        // non challenge
        // if (rst)
        //     sreg <= 4'b1;
        // else if (en)
        //     sreg <= {sreg[3:1], sreg[4] ^ sreg[3]}; 

        // challenge
        if (rst)
            sreg <= 4'b1;
        else if (en)
            sreg <= {sreg[6:1], sreg[7] ^ sreg[3]}; 

    assign data_out = sreg;

endmodule
