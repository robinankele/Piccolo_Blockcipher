/**
 *  does a sbox lookup for a block of SBOXSIZE.
 *  @param x inputvalue
 *  @param y sbox lookuped outputvalue
 *  @return errorcode
 */

`include "nor2gate.v"
`include "xor2gate.v"
`include "xnor2gate.v"

module Sbox4(A, Q); 
  input [3:0] A;
  output [3:0] Q;
  wire t1, t2, t3, t4;

  NOR2gate nor1 (A[2], A[3], t1);   
  XOR2gate xor1 (A[0], t1, Q[3]);
  NOR2gate nor2 (A[2], A[1], t2);
  XOR2gate xor2 (A[3], t2, Q[2]);
  NOR2gate nor3 (A[1], Q[3], t3);
  XNOR2gate xnor1 (A[2], t3, Q[1]);
  NOR2gate nor4 (Q[3], Q[2], t4);
  XOR2gate xor3 (A[1], t4, Q[0]);

endmodule
