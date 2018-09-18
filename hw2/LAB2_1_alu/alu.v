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


output reg [31:0]  result;
output reg         zero;
output reg         cout;
output reg         overflow;


always@(*) begin
    case(ALU_control) 
		4'b0000: begin //AND
					/*
						modify
					*/
				end  
		4'b0001: begin //OR 
					/*
						modify
					*/
				end
		4'b0010: begin //ADD
					/*
						modify
					*/
				end
		4'b0110: begin //sub
					/*
						modify
					*/			
				end
		4'b1100: begin //NOR 
					/*
						modify
					*/		
				end 
		4'b1101: begin //NAND 
					/*
						modify
					*/		
				end 
		4'b0111: begin //slt
					/*
						modify
					*/		
				end        
		default:begin 
					/*
						modify
				    */
			    end    
    endcase
end


endmodule
