/**
 *  calculates the constant values con2i and con2i+1 needed
 *  for the key scheduling function.
 *  @param i round number
 *  @param constants con2i and con2i+1 constants
 *  @return errorcode
 */

module Con2i(con1, con2, i);
    input [4:0] i;
    wire [4:0] i;
    output [15:0] con1;
    output [15:0] con2;
    reg [15:0] con1;
    reg [15:0] con2;
    reg [15:0] pre_keys[49:0];
    
    initial 
    begin   
        pre_keys[0] <= 16'h293d;
        pre_keys[1] <= 16'h071c;
        pre_keys[2] <= 16'h253e;
        pre_keys[3] <= 16'h1f1a;
        pre_keys[4] <= 16'h213f;
        pre_keys[5] <= 16'h1718;
        pre_keys[6] <= 16'h3d38;
        pre_keys[7] <= 16'h2f16;
        pre_keys[8] <= 16'h3939;
        pre_keys[9] <= 16'h2714;
        pre_keys[10] <= 16'h353a;
        pre_keys[11] <= 16'h3f12;
        pre_keys[12] <= 16'h313b;
        pre_keys[13] <= 16'h3710;
        pre_keys[14] <= 16'h0d34;
        pre_keys[15] <= 16'h4f0e;
        pre_keys[16] <= 16'h0935;
        pre_keys[17] <= 16'h470c;
        pre_keys[18] <= 16'h0536;
        pre_keys[19] <= 16'h5f0a;
        pre_keys[20] <= 16'h0137;
        pre_keys[21] <= 16'h5708;
        pre_keys[22] <= 16'h1d30;
        pre_keys[23] <= 16'h6f06;
        pre_keys[24] <= 16'h1931;
        pre_keys[25] <= 16'h6704;
        pre_keys[26] <= 16'h1532;
        pre_keys[27] <= 16'h7f02;
        pre_keys[28] <= 16'h1133;
        pre_keys[29] <= 16'h7700;
        pre_keys[30] <= 16'h6d2c;
        pre_keys[31] <= 16'h8f3e;
        pre_keys[32] <= 16'h692d;
        pre_keys[33] <= 16'h873c;
        pre_keys[34] <= 16'h652e;
        pre_keys[35] <= 16'h9f3a;
        pre_keys[36] <= 16'h612f;
        pre_keys[37] <= 16'h9738;
        pre_keys[38] <= 16'h7d28;
        pre_keys[39] <= 16'haf36;
        pre_keys[40] <= 16'h7929;
        pre_keys[41] <= 16'ha734;
        pre_keys[42] <= 16'h752a;
        pre_keys[43] <= 16'hbf32;
        pre_keys[44] <= 16'h712b;
        pre_keys[45] <= 16'hb730;
        pre_keys[46] <= 16'h4d24;
        pre_keys[47] <= 16'hcf2e;
        pre_keys[48] <= 16'h4925;
        pre_keys[49] <= 16'hc72c;
    end
    
    /* calculation of constants con2i and con2i+1 */
    always @ (i)
    begin
        assign con1 = pre_keys[2 * i];
        assign con2 = pre_keys[2*i + 1];
    end
endmodule