// xnor2gate_testbench.v
// 2-input XNOR gate testbench


`timescale 1ns / 1ps
`include "../xnor2gate.v"

module Xnor2gate_testbench;

   reg A_t, B_t;
   wire F_t;

   XNOR2gate XNOR2gate_1(A_t, B_t, F_t);
   
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