/**
 *  calculates the diffusion of a block with the diffusion 
 *  Matrix M.
 *  @param x inputvalue
 *  @param y diffusied outputvalue
 *  @return errorcode
 */

`include "gm.v"

module DiffusionMatrix(A, Q); 
  input [15:0] A;
  output [15:0] Q;
  reg [15:0] Q;
  reg [3:0] M [0:15];
  wire [15:0] temp_a;
  wire [15:0] temp_b;
  wire [15:0] temp_c;
  wire [15:0] temp_d;
  
  // ---------------- M Matrix ------------------------------
  initial 
  begin
     M[0] = 4'h2;
     M[1] = 4'h3;
     M[2] = 4'h1;
     M[3] = 4'h1;
  
     M[4] = 4'h1;
     M[5] = 4'h2;
     M[6] = 4'h3;
     M[7] = 4'h1;
  
     M[8] = 4'h1;
     M[9] = 4'h1;
     M[10] = 4'h2;
     M[11] = 4'h3;
  
     M[12] = 4'h3;
     M[13] = 4'h1;
     M[14] = 4'h1;
     M[15] = 4'h2; 
  end
  
  
  always @ A 
  begin
     #40
     Q[15:12] <= temp_a[15:12] ^ temp_a[11: 8] ^ temp_a[7:4] ^ temp_a[3: 0];
     Q[11:8] <= temp_b[15:12] ^ temp_b[11: 8] ^ temp_b[7:4] ^ temp_b[3: 0];
     Q[7:4] <= temp_c[15:12] ^ temp_c[11: 8] ^ temp_c[7:4] ^ temp_c[3: 0];
     Q[3:0] <= temp_d[15:12] ^ temp_d[11: 8] ^ temp_d[7:4] ^ temp_d[3: 0];
   end

  // -------------------------------------------------------
  Gm Gm1(M[0], A[15:12], temp_a[15:12]);
  Gm Gm2(M[1], A[11: 8], temp_a[11: 8]);
  Gm Gm3(M[2], A[ 7: 4], temp_a[ 7: 4]);
  Gm Gm4(M[3], A[ 3: 0], temp_a[ 3: 0]);
  
  // -------------------------------------------------------
  Gm Gm5(M[4], A[15:12], temp_b[15:12]);
  Gm Gm6(M[5], A[11: 8], temp_b[11: 8]);
  Gm Gm7(M[6], A[ 7: 4], temp_b[ 7: 4]);
  Gm Gm8(M[7], A[ 3: 0], temp_b[ 3: 0]);

  // -------------------------------------------------------
  Gm Gm9(M[8], A[15:12], temp_c[15:12]);
  Gm Gm10(M[9], A[11: 8], temp_c[11: 8]);
  Gm Gm11(M[10], A[ 7: 4], temp_c[ 7: 4]);
  Gm Gm12(M[11], A[ 3: 0], temp_c[ 3: 0]);
  
  // -------------------------------------------------------
  Gm Gm13(M[12], A[15:12], temp_d[15:12]);
  Gm Gm14(M[13], A[11: 8], temp_d[11: 8]);
  Gm Gm15(M[14], A[ 7: 4], temp_d[ 7: 4]);
  Gm Gm16(M[15], A[ 3: 0], temp_d[ 3: 0]);
  
endmodule
