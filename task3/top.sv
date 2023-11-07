module top#(
	parameter WIDTH = 16
)(
    // interface signals
    input  logic             clk,      // clock 
    input  logic             rst,      // reset 
    input  logic             en,       // enable
    input  logic [WIDTH-1:0] N,     
    output logic [7:0]       data_out       
);

    logic  tick;

clktick clktick(
    .clk(clk),
    .en(en),
    .rst(rst),
    .N(N),
    .tick(tick)
);

f1_fsm f1_fsm(
    .rst(rst),
    .en(tick),
    .clk(clk),
    .data_out(data_out)
);

endmodule
