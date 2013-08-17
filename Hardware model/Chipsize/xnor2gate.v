// xnor2gate.v
// 2-input XNOR gate

module XNOR2gate(A, B, Q);
   input A;
   input B;
   output Q;
   reg Q;

   always @ (A or B)
   begin
      Q <= A ~^ B;
   end

endmodule