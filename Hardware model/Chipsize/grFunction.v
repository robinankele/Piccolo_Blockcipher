/**
 *  Encryption function - encrypts one block using the 
 *  whiteining keys and round keys. Resulting in a cipher
 *  block.
 *  @param x plaintext of BLOCKSIZE
 *  @param y ciphertext of BLOCKSIZE
 *  @param wk whitening keys
 *  @param rk round keys
 *  @return errorcode
 */

`timescale 1ns / 1ps
`include "fFunction16.v"
`include "roundpermutation.v"  

module grFunction(plaintext, ciphertext, wk, rk);
    input [63:0] plaintext;
    output [63:0] ciphertext;
    reg [63:0] ciphertext;
    input [63:0] wk;
    input [799:0] rk;
    reg [799:0] rk_temp;
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    reg [15:0] x0_t;
    reg [15:0] x2_t;
    wire [15:0] fx1;
    wire [15:0] fx2;
    reg [15:0] temp1;
    reg [15:0] temp2;
    reg [15:0] rk1;
    reg [15:0] rk2;
    reg [63:0] y_;
    wire [63:0] y;
    reg start_rp;
    
    integer i;
    integer ROUNDS;
    
    initial 
    begin
        i = 0;
        ROUNDS = 25;
        start_rp <= 1;
        assign rk_temp[799:0] = rk[799:0];
    end
    
    FFunction16 f1(x0, fx1);
    FFunction16 f2(x2, fx2);
    Roundpermutation rp(y_, y, start_rp);
    
    always @ plaintext
    begin
        #450
        
        assign x0_t[15:0] = plaintext[63:48];
        assign x1[15:0] = plaintext[47:32];
        assign x2_t[15:0] = plaintext[31:16];
        assign x3[15:0] = plaintext[15: 0];
        #20
        
        // performing Gr function
        x0[15:0] <= wk[15: 0] ^ x0_t[15:0];
        x2[15:0] <= wk[31:16] ^ x2_t[15:0];
        #1
        
        for(i = 0; i < ROUNDS - 1; i = i + 1)
        begin
            #20
            assign rk1[15:0] = rk_temp[799:784];
            assign rk2[15:0] = rk_temp[783:768];


            #300      // wait for fFunction      
            // F - function 
            
            temp1[15:0] <= fx1[15: 0] ^ rk1[15:0];
            #50
            x1[15:0] <= temp1[15: 0] ^ x1[15:0];
            
            temp2[15:0] <= fx2[15: 0] ^ rk2[15:0];
            #50
            x3[15:0] <= temp2[15: 0] ^ x3[15:0];
            
            #20
            assign y_[63:48] = x0[15:0];
            assign y_[47:32] = x1[15:0];
            assign y_[31:16] = x2[15:0];
            assign y_[15: 0] = x3[15:0];
            
            start_rp <= ~start_rp;
            // Round permutation 
            #50             // wait some time to do the round permutation 
            
            assign x0[15:0] = y[63:48];
            assign x1[15:0] = y[47:32];
            assign x2[15:0] = y[31:16];
            assign x3[15:0] = y[15: 0];
            #20
            rk_temp[799:0] <= rk_temp[799:0] << 32; 
        end
        
        #5
        assign rk1[15:0] = rk_temp[799:784];
        assign rk2[15:0] = rk_temp[783:768];
        

        #300    //wait for fFunction
        // F - function 
        
        temp1[15:0] <= fx1[15: 0] ^ rk1[15:0];
        #5
        x1[15:0] <= temp1[15: 0] ^ x1[15:0];
        
        temp2[15:0] <= fx2[15: 0] ^ rk2[15:0];
        #5
        x3[15:0] <= temp2[15: 0] ^ x3[15:0];
        
        x0[15:0] <= wk[47: 32] ^ x0[15:0];
        x2[15:0] <= wk[63: 48] ^ x2[15:0];
        
        #5
        assign ciphertext[63:48] = x0[15:0];
        assign ciphertext[47:32] = x1[15:0];
        assign ciphertext[31:16] = x2[15:0];
        assign ciphertext[15: 0] = x3[15:0];  
        
    end
endmodule
