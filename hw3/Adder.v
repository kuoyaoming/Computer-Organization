`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:04:44 12/03/2017 
// Design Name: 
// Module Name:    Adder 
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
module Adder(
    src1_i,
	src2_i,
	sum_o
	);
     
//I/O ports
		input  [32-1:0]  src1_i;
		input  [32-1:0]  src2_i;
		output [32-1:0]  sum_o;

//Internal Signals
		wire    [32-1:0]	 sum_o;

//Parameter
    
//Main function
		assign sum_o = src1_i + src2_i;
		endmodule