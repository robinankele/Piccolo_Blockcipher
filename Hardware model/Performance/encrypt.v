/**
 *  Encryption - encrypts the plaintext P using the key K.
 *  @param plaintext the plaintext P
 *  @param key the key K
 *  @param ciphertext the ciphertext C
 *  @return errorcode of encryption
 */

`timescale 1ns / 1ps
`include "grFunction.v" 
`include "keyschedule.v"  

module encrypt();
    
    reg [63:0] plaintext;
    reg [79:0] key;
    wire [63:0] ciphertext;
    wire [63:0] wk;
    wire [799:0] rk;

    keyschedule ks(key, wk, rk);
    grFunction encryption(plaintext, ciphertext, wk, rk);
    
    initial 
    begin
        key[79:0] <= 80'h00112233445566778899;
        #400     // wait for keyschedule to generate keys
        plaintext[63:0] <= 64'h0123456789abcdef;
        
        #15000     // wait some time to do the encryption
        $display("--------------------------");
        $display("-  Piccolo Blockcipher   -");
        $display("-  Blocksize: 64bit      -");
        $display("-  Keylenght: 80bit      -");
        $display("-  Performance Version   -");
        $display("--------------------------");
        $display("plaintext = %h", plaintext);
        $display("key = %h", key);
        $display("ciphertext = %h", ciphertext);
    end
    
endmodule
