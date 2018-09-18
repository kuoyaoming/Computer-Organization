`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:01:57 12/03/2017 
// Design Name: 
// Module Name:    Shift_Left_Two_32 
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
module Shift_Left_Two_32(
   data_i,
    data_o
    );

//I/O ports                    
	  input [32-1:0] data_i;
	  output [32-1:0] data_o;

//shift left 2
     assign data_o = data_i << 2;   
endmodule

