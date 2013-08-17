
// sbox4_testbench.v
// 4-bit Sbox Testbench

`timescale 1ns / 1ps
//`include "sbox4.v"
`include "sbox4_performance.v"

module Sbox4_testbench;

   reg [3:0] A_t;
   wire [3:0] Result_t;

   Sbox4 Sbox4_1(A_t, Result_t);
   
   initial
   begin

      A_t <= 2;  
      #1 $display("Result_t = %h", Result_t);

   end
endmodule  