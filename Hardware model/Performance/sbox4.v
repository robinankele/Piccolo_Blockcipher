/**
 *  does a sbox lookup for a block of SBOXSIZE.
 *  @param x inputvalue
 *  @param y sbox lookuped outputvalue
 *  @return errorcode
 */
 
module Sbox4(A, Q); 
  input [3:0] A;
  output [3:0] Q;
  reg [3:0] Q;
  reg [3:0]prev_value[15:0];
  
  initial 
  begin
    prev_value[0] <= 4'he;
    prev_value[1] <= 4'h4;
    prev_value[2] <= 4'hb;
    prev_value[3] <= 4'h2;
    prev_value[4] <= 4'h3;
    prev_value[5] <= 4'h8;
    prev_value[6] <= 4'h0;
    prev_value[7] <= 4'h9;
    prev_value[8] <= 4'h1;
    prev_value[9] <= 4'ha;
    prev_value[10] <= 4'h7;
    prev_value[11] <= 4'hf;
    prev_value[12] <= 4'h6;
    prev_value[13] <= 4'hc;
    prev_value[14] <= 4'h5;
    prev_value[15] <= 4'hd;
  end

  always @ A
  begin
    Q <= prev_value[A];
  end

endmodule
