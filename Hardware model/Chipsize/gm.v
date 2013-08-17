/**
 *  performs a GF(2^4) multiplication
 *  @param a operand
 *  @param b operand
 *  @return result
 */

module Gm(A, B, result);
 input [3:0] A;
 input [3:0] B;
 output [3:0] result;
 reg [3:0] result;
 integer i;
 reg [5:0] A_;
 reg [5:0] B_;
 reg [5:0] A_temp;
 reg [5:0] B_temp;
 reg [5:0] g;
 reg [5:0] hbs;
 reg [5:0] res_temp;
 reg [5:0] A_temp_;
 reg [5:0] B_temp_;
 
 always @ (A or B)
 begin    
    assign A_ = A;
    assign B_ = B;
    g <= 0;
  
     #1
   for (i = 0; i < 4; i = i + 1) 
     begin
       res_temp <= B_ & 4'b001;
       #1 
       if(res_temp == 1)
       begin
          #1       
          g <= g ^ A_;
       end
       #1
        hbs <= A_ & 4'b1000;
        A_temp_ <= A_ * 2;
        #1
        assign A_ = A_temp_;
       if(hbs == 4'b1000)
       begin
         //A_ <= A_ ^ 19;
         A_temp_ <= A_ ^ 19;
         #1
         assign A_ = A_temp_;
       end  
        //B_ <= B_ >> 1;
        B_temp_ <= B_ / 2;
        #1
        assign B_ = B_temp_;
     end
       assign result = g;
 end
endmodule

