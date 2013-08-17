/**
 *  Key scheduling - generates whitening and roundkeys 
 *  from the key (key lenght KEYSIZE).
 *  @param k the key 
 *  @param wk whitening keys - wki(16) 0<=i<= 4
 *  @param rk round keys (4) - rkj(16) 0<=j<=2r
 *  @return errorcode
 */
 
`include "con2i.v"

module keyschedule(k, wk, rk);

    input [79:0] k;
    output [63:0] wk;
    output [799:0] rk;

    reg [15:0] k0;
    reg [15:0] k1;
    reg [15:0] k2;
    reg [15:0] k3;
    reg [15:0] k4;
    
    reg [63:0] wk;
    reg [799:0] rk;
    reg [31:0] temp;
    wire [15:0] con1;
    wire [15:0] con2;
    
    reg [4:0] i;
    integer ROUNDS;
    initial 
    begin 
        ROUNDS = 25; 
        i <= 0;
    end
    
    Con2i con2i(con1, con2, i);
        
    always @ (k)
    begin
    
        /* generating keys k0-k4 */
        assign k4[15:0] = k[15: 0];
        assign k3[15:0] = k[31:16];
        assign k2[15:0] = k[47:32];
        assign k1[15:0] = k[63:48];
        assign k0[15:0] = k[79:64];

        /* generating whitening keys */
        assign wk[ 7: 0] = k1[ 7: 0];     // wk0
        assign wk[15: 8] = k0[15: 8];
        assign wk[23:16] = k0[ 7: 0];     // wk1
        assign wk[31:24] = k1[15: 8];
        assign wk[39:32] = k3[ 7: 0];     // wk2
        assign wk[47:40] = k4[15: 8];
        assign wk[55:48] = k4[ 7: 0];     // wk3
        assign wk[63:56] = k3[15: 8];   
    
        /* generating round keys */
        for(i = 0; i < ROUNDS; i = i + 1)
        begin

        #5 // wait some time for key constants to be calculated
            
            if(i % 5 == 0)
                 begin 
                    temp[31:16] <= k2[15:0] ^ con2[15:0];
                    temp[15: 0] <= k3[15:0] ^ con1[15:0];
                 end
            if(i % 5 == 2)
                 begin 
                    temp[31:16] <= k2[15:0] ^ con2[15:0];
                    temp[15: 0] <= k3[15:0] ^ con1[15:0];
                 end
            if(i % 5 == 1)
                 begin 
                    temp[31:16] <= k0[15:0] ^ con2[15:0];
                    temp[15: 0] <= k1[15:0] ^ con1[15:0];
                 end
            if(i % 5 == 4)
                 begin 
                    temp[31:16] <= k0[15:0] ^ con2[15:0];
                    temp[15: 0] <= k1[15:0] ^ con1[15:0];
                 end
            if(i % 5 == 3)
                 begin
                    temp[31:16] <= k4[15:0] ^ con2[15:0];
                    temp[15: 0] <= k4[15:0] ^ con1[15:0];
                end
            #2   
            assign rk[31:0] = temp[31:0];
            #2
            
            if(i != ROUNDS - 1)
                rk[799:0] <= rk[799:0] << 32;
        end
    end
endmodule
