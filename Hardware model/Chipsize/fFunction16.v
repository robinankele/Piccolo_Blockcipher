/**
 *  does a fFunction operation on the inputblock.
 *  @param x inputvalue
 *  @param y outputvalue
 *  @return errorcode
 */
 
`include "sbox4.v" 
`include "diffusionmatrix.v" 

module FFunction16(Din, Dout);
   input [0:15] Din;
   wire [0:15] s_out;
   wire [0:15] m_out;
   output [0:15] Dout;
   
   Sbox4 Sbox4_1(Din[0:3], s_out[0:3]);
   Sbox4 Sbox4_2(Din[4:7], s_out[4:7]);
   Sbox4 Sbox4_3(Din[8:11], s_out[8:11]);
   Sbox4 Sbox4_4(Din[12:15], s_out[12:15]);
   DiffusionMatrix DiffusionMatrix_1(s_out, m_out);
   Sbox4 Sbox4_5(m_out[0:3], Dout[0:3]);
   Sbox4 Sbox4_6(m_out[4:7], Dout[4:7]);
   Sbox4 Sbox4_7(m_out[8:11], Dout[8:11]);
   Sbox4 Sbox4_8(m_out[12:15], Dout[12:15]); 
endmodule
