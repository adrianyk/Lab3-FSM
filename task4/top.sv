module top#(
	parameter WIDTH = 16
)(
    // interface signals
    input  logic             clk,      // clock 
    input  logic             rst,      // reset 
    input  logic [WIDTH-1:0] N,     
    input  logic             trigger,
    output logic [7:0]       data_out,
    output logic             cmd_seq,
    output logic             cmd_delay
);

    logic  tick;
    logic  time_out;
    logic  mux_out = cmd_seq ? tick : time_out;
    logic  lfsr_out;

delay delay(
    .trigger(cmd_delay),
    .rst(rst),
    .clk(clk),
    .K(lfsr_out),
    .time_out(time_out)
);

lfsr lfsr(
    .clk(clk),
    .rst(rst),
    .data_out(lfsr_out)
);

clktick clktick(
    .clk(clk),
    .en(cmd_seq),
    .rst(rst),
    .N(N),
    .tick(tick)
);

f1_fsm f1_fsm(
    .rst(rst),
    .en(mux_out),
    .clk(clk),
    .trigger(trigger),
    .data_out(data_out),
    .cmd_seq(cmd_seq),
    .cmd_delay(cmd_delay)
);

endmodule
