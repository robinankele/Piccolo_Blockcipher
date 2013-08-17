/**
 *  Round permutation.
 *  @param x inputvalue
 *  @param y shuffled outputvalue
 *  @return errorcode
 */
 
module Roundpermutation(A, Q, start_rp);
   input [63:0] A;
   input start_rp;
   output [63:0] Q;
   reg [63:0] Q;  

   always @ start_rp
   begin
      Q[ 7: 0] <= A[23:16];
      Q[15: 8] <= A[63:56];
      Q[23:16] <= A[39:32];
      Q[31:24] <= A[15: 8];
      Q[39:32] <= A[55:48];
      Q[47:40] <= A[31:24];
      Q[55:48] <= A[ 7: 0];
      Q[63:56] <= A[47:40];
   end
endmodule