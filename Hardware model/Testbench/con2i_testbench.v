`timescale 1ns / 1ps
`include "con2i_chipsize.v"
//`include "con2i.v"

module con2i_testbench;
   wire [15:0] con1;
   wire [15:0] con2;
   reg[4:0] i;
   
   Con2i constants(con1, con2, i);
      
   initial 
   begin
        i <= 2;
        #10 $display("i = %d, con1 = %h, con2 = %h", i, con1, con2);
   end
    
endmodule
