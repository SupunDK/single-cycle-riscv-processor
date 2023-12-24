module ALU_32bit(i1, i2, control, o);

input [31:0] i1;
input [31:0] i2;
input [3:0] control;
output reg [31:0] o;
reg signed [31:0] temp;

always @(control or i1 or i2)
    begin
        case(control)
            4'b0000: o = i1 + i2; //ADD -> tested
            4'b0001: o = i1 - i2; //SUB -> tested
            4'b0010: o = i1 | i2; //OR  -> tested
            4'b0011: o = i1 & i2; //AND -> tested
            4'b0100: o = i1 ^ i2; //XOR -> tested
            
            4'b0101: o = i1 << i2[4:0]; //LSHIFT -> tested
            4'b0110: o = i1 >> i2[4:0]; //RSHIFT -> tested
            4'b0111:
                begin
                    temp = i1;
                    o = temp >>>i2[4:0]; //RASHIFT; ->tested
                end 
            4'b1000: o = (i1 < i2) ? 1 : 0; //LESS THAN -> tested
            4'b1001: //LESS THAN UNSIGNED -> tested
                begin
                    if (i1[31] == 0 && i2[31] == 0)
                        o = (i1 < i2) ? 1: 0;
                    else if ( i1[31] == 1 && i2[31] == 1)
                        o = (i1 > i2) ? 1: 0;
                    else if ( i1[31] == 1 && i2[31] == 0)
                        o = 0;
                    else
                        o = 1;
                end    
                
             4'b1010: o = i2;
             4'b1011: 
                begin
                    o = ( i1 + i2 ) & 32'hfffffffc;
                end   
        
        endcase     
    end
endmodule