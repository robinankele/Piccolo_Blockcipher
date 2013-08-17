// nor2gate.v
// 2-input NOR gate

module NOR2gate(A, B, Q);
   input A;
   input B;
   output Q;
   reg Q;

   always @ (A or B)
   begin
      Q <= ~(A | B);
   end
endmodule