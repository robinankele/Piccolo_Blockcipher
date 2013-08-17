`timescale 1ns / 1ps
`include "../keyschedule.v"

module keyschedule_testbench;

    reg [79:0] k;
    wire [63:0] wk;
    wire [799:0] rk;
    
    keyschedule sched(k, wk, rk);

    initial 
    begin
        k[79:0] <= 80'h00112233445566778899;
        #250 // wait some time
        #1; $display("wk = %h", wk);
        #1 $display("rk = %h", rk);
    end
endmodule
