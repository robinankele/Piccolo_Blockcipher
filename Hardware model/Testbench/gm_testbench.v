// gm_testbench.v
// Galois Multiplication Testbench

`timescale 1ns / 1ps
`include "../gm.v"

module Gm_testbench;

   reg [3:0] A_t;
   reg [3:0] B_t;
   wire [3:0] Result_t;

   Gm Gm_1(A_t, B_t, Result_t);
   
   initial
   begin

      A_t <= 3; B_t <= 10;
      #50 
      $display("Result_t = %h", Result_t);

   end
endmodule