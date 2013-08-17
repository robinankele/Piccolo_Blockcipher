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
    
    reg [4:0] c0;
    reg [4:0] ci;
    reg [31:0] KEYCONST;
    reg [31:0] temp;
    
    /* calculation of constants con2i and con2i+1 */
    always @ (i)
    begin
        assign c0 = 5'b00000;
        assign ci = i + 1;
        assign KEYCONST = 32'h0F1E2D3C;
    
        assign temp[ 4: 0] = ci;
        assign temp[ 9: 5] = c0;
        assign temp[14:10] = ci;
        assign temp[16:15] = 2'b00;
        assign temp[21:17] = ci;
        assign temp[26:22] = c0;
        assign temp[31:27] = ci;

        temp[31:0] <= temp[31: 0] ^ KEYCONST[31: 0];
        assign con1 = temp[15:0];
        assign con2 = temp[31:16];
    end
endmodule
