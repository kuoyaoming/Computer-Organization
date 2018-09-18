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
module MUX_2(
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
		reg     [size-1:0] data_o;

//Main function
		always @(select_i) 
		begin
				 if (select_i == 0) data_o <= data0_i;
				 else data_o <= data1_i;
		end
endmodule    
