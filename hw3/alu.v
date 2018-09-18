`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:01:20 12/03/2017 
// Design Name: 
// Module Name:    alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu(
          
          clk,
          rst,
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


    input   clk,rst;
	input  [32-1:0] src1;
	input  [32-1:0] src2;
	input   [4-1:0] ALU_control;

   output reg [32-1:0] result;
	output reg  zero;
	output reg  cout;
	output reg  overflow;
	wire [32:0] tmp,tmp2;
	assign tmp={1'b0,src1} + {1'b0,src2};
	assign tmp2={1'b0,src1} +(~{1'b1,src2});
   always@( negedge clk ) 
   if (~rst)
   result = 32'b0;
   else
		begin	   
			  case(ALU_control) 
					 4'b0000: begin
									result=src1&src2;     //AND
									zero=(result==32'b0)?1'b1:1'b0;
									overflow=1'b0;
									cout=1'b0;
								 end
					 4'b0001: begin
									result=src1|src2;      //OR
									zero=(result==32'b0)?1'b1:1'b0;
									overflow=1'b0;
									cout=1'b0;
								 end
					 4'b0010: begin					     //ADD
									result=src1+src2;
									zero=(result==32'b0)?1'b1:1'b0;
									cout=tmp[32];
									if ((src1>=0&&src2>=0&&result<0)||(src1<0&&src2<0&&result>=0)) 
			                        overflow=1'b1;
									else  overflow=1'b0;
								 end
					 4'b0110: begin					     //sub
									result=src1-src2;
									zero=(result==32'b0)?1'b1:1'b0;
									cout=tmp2[32];
									if ((src1>=0&&src2<0&&result<0)||(src1<0&&src2>=0&&result>=0)) 
			                        overflow=1'b1;
									else  overflow=1'b0;
								 end     
					 4'b1100: begin
									result=~(src1|src2);    //NOR
									zero=(result==32'b0)?1'b1:1'b0;
									overflow=1'b0;
									cout=1'b0;
								 end
					 4'b1101: begin
									result=~(src1&src2);   //NAND
									zero=(result==32'b0)?1'b1:1'b0;
									overflow=1'b0;	
									cout=1'b0;
								 end
					 4'b0111: begin  				        //slt 
									result=(src1>src2)?32'h1:32'h0;
									zero=(result==32'b0)?1'b1:1'b0;
									overflow=1'b0;
									cout=1'b0;
								 end 
					 4'b0011: begin  				        //mul 
									result=(src1*src2)?32'h1:32'h0;
									zero=(result==32'b0)?1'b1:1'b0;
									overflow=1'b0;
									cout=1'b0;
								 end      
					 default: begin
									zero=(result==32'b0)?1'b1:1'b0;
									overflow=1'b0;
									cout=1'b0;		
								 end
				endcase
			end
endmodule 
