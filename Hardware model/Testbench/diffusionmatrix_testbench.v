// diffusionmatrix_testbench.v
// Diffusion Function Testbench

`timescale 1ns / 1ps
`include "diffusionmatrix.v"

module Diffusionmatrix_testbench;

   reg [15:0] A_t;
   wire [15:0] Q_t;
 
   DiffusionMatrix DiffusionMatrix_1(A_t, Q_t);
   
   initial
   begin
      //case 0
      A_t <= 16'ha1c7;
      #200 $display("Q_t = %h || Should be => b304", Q_t);
      
   end
endmodule