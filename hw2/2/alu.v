`timescale 1ns/1ps


module alu(
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );
           
input  [31:0]  src1;
input  [31:0]  src2;
input [4-1:0] ALU_control;


output reg [31:0]  result=0;
output reg         zero=0;
output reg         cout=0;
output reg         overflow=0;
reg signed [32+32:0] ooff=0;

always@(*) begin
    case(ALU_control) 
		4'b0000: begin //AND
					result <= src1 & src2;//??and??
				end  
		4'b0001: begin //OR 
					result <= src1 | src2;//??or??
				end
		4'b0010: begin //ADD
		{cout ,result} = src1+src2;//?????????????cout?
					result <= src1 + src2;
					ooff [32:0] <= {src1[31], src1 [31:0]} + {src2[31], src2 [31:0]}; // Add A + B
                    if(ooff [32:31] == (2'b11 | 2'b10)) overflow <= 1'b1;???????or??????
                    else overflow <= 1'b0;
				end
		4'b0110: begin //sub
					 result <= src1 - src2;
					ooff [32:0] <= {src1[31], src1 [31:0]} - {src2[31], src2 [31:0]}; // Subtract A - B
                    if((ooff[32+32]) && (~ooff [32+31:31] != 0)) overflow <= 1'b1;//??
                    else if ((~ooff[32+32]) && (ooff [32+31:31] != 0)) overflow <= 1'b1;
                    else overflow <= 1'b0;	
				end
		4'b1100: begin //NOR 
					result <= ~(src1 | src2);	//??nor??
				end 
		4'b1101: begin //NAND 
					result <= ~(src1 & src2);	//??nand??
				end 
		4'b0111: begin //slt
					result <= (src1 < src2) ? 0 : 1 ;
				end        
		default:begin 
					/*
						modify
				    */
			    end    
    endcase
end

always @* zero = (result==0);//?????????1

endmodule
