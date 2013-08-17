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
   output [0:15] Dout;
   reg [0:15] Dout;
   integer i;
   reg [0:15] temp1;
   reg [0:15] temp2;
   reg [0:15] min;
   wire [0:15] mout;
   reg [0:3] s1in;
   reg [0:3] s2in;
   wire [0:3] s1out;
   wire [0:3] s2out;
   
   Sbox4 s1(s1in[0:3], s1out[0:3]);
   DiffusionMatrix diff(min, mout);
   Sbox4 s2(s2in[0:3], s2out[0:3]);
   
   always @Din
   begin
        assign temp1[0:15] = Din[0:15];
        #1
        for(i = 0; i < 4; i = i + 1)
        begin
            s1in[0:3] <= temp1[12:15];
            #1
            temp1[0:15] <= temp1[0:15] >> 4;
            
            #15  // waiting for sbox
            
            temp2[0:3] <= s1out[0:3];
            #1
            if(i != 3)
                temp2[0:15] <= temp2[0:15] >> 4;
        end
        
        assign min[0:15] = temp2[0:15];
        #200 // waiting for diffusion        
        assign temp1[0:15] = mout[0:15];

        for(i = 0; i < 4; i = i + 1)
        begin
            s2in[0:3] <= temp1[12:15];
            temp1[0:15] <= temp1[0:15] >> 4;
            
            #15  // waiting for sbox
            
            temp2[0:3] <= s2out[0:3];
            #1
            if(i != 3)
                temp2[0:15] <= temp2[0:15] >> 4;
        end
        #1
        Dout[0:15] <= temp2[0:15];
   end
   
endmodule
