// nor2gate_testbench.v
// 2-input NOR gate testbench


`timescale 1ns / 1ps
`include "../nor2gate.v"

module Nor2gate_testbench;

   reg A_t, B_t;
   wire F_t;

   NOR2gate NOR2gate_1(A_t, B_t, F_t);
   
   initial
   begin

      //case 0
      A_t <= 0; B_t <= 0;
      #1 $display("F_t = %b", F_t);
	  
      //case 1
      A_t <= 0; B_t <= 1;
      #1 $display("F_t = %b", F_t);
	  
      //case 2
      A_t <= 1; B_t <= 0;
      #1 $display("F_t = %b", F_t);
	  
      //case 3
      A_t <= 1; B_t <= 1;
      #1 $display("F_t = %b", F_t);
	  
   end
endmodule