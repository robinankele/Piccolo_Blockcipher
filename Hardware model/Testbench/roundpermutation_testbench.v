// roundpermutation_testbench.v
// Roundpermutation - Testbench

`timescale 1ns /1ps
`include "../roundpermutation.v"

module Roundpermutation_testbench;

 reg [63:0] A_t;
 wire [63:0] Q_t;

  Roundpermutation Roundpermutation_1(A_t, Q_t);
   initial
   begin
      A_t <= 64'h1122334455667788;
      #10 $display("Q_t = %h", Q_t);
      
      A_t <= 64'h8877665544332211;
      #10 $display("Q_t = %h", Q_t);
      
      A_t <= 64'h1234567890abcdef;
      #10 $display("Q_t = %h", Q_t);
   end
endmodule