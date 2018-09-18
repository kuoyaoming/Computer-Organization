`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:50:16 12/02/2017 
// Design Name: 
// Module Name:    MUX_2to1 
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
module MUX_2to1(
			data0_i,
         data1_i,
         select_i,
         data_o
);

		parameter size = 0;			   
			
//I/O ports               
		input   [size-1:0] data0_i;          
		input   [size-1:0] data1_i;
		input              select_i;
		output  [size-1:0] data_o; 

//Internal Signals
		

//Main function
		assign data_o = (select_i ) ? data1_i :  data0_i; 
		
endmodule    
