#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vlfsr.h"

#include "vbuddy.cpp"     // include vbuddy code

#define MAX_SIM_CYC 1000000

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vlfsr* top = new Vlfsr;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("lfsr.vcd");
 
  // init Vbuddy
  if (vbdOpen()!=1) return(-1);
  vbdHeader("L3T1: Random Num");
  vbdSetMode(1);        // Flag mode set to one-shot

  // initialize simulation input 
  top->clk = 1;
  top->rst = 0;
  top->en = 0;

  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }

    top->rst = (simcyc<2);
    top->en = vbdFlag();

    // ++++ Send count value to Vbuddy

    // using hex display
    // displaying four bit output of the random sequence on the 7-segment display
    vbdHex(1, top->data_out & 0xF); // only using 1 hex digit display cuz data_out is only 4 bits, only need 1 hex digit
    vbdHex(2, (top->data_out >> 4) & 0xF); // for the challenge we need to use a second hex digit display cuz now data_out is 7 bits, so we need 2 hex digits to represent 7 bits

    vbdBar(top->data_out & 0xFF); // displaying 4-bit result on the neopixel strip
    /* neopixel strip is the vertical col of red lights on the RHS of Vbuddy. 
    Each light represents each bit, i.e. if data_out is 4 bits, then will use 4 lights
    and if data_out is 1011 then the bottom 4 lights will be light up, no light, light up, light up */
    
    vbdCycle(simcyc+1);
    // ---- end of Vbuddy output section

    // either simulation finished, or 'q' is pressed
    if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
      exit(0);

  }

  vbdClose();
  tfp->close(); 
  printf("Exiting\n");
  exit(0);
}
