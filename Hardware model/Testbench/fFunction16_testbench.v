// ffunction16.v
// 16-bit F-Function

`timescale 1ns / 1ps
//`include "fFunction16.v" 
`include "fFunction16_chipsize.v" 

module FFunction16_testbench();
   reg [15:0] Din;
   wire [15:0] Dout;
   
   FFunction16 f1(Din, Dout);
   
   initial
   begin
        Din <= 16'h5361;
        
       #350
       $display("Dout = %h < should be 4104", Dout);
   end

endmodule
