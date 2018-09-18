`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:15 12/02/2017 
// Design Name: 
// Module Name:    Instr_Memory 
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
module Instr_Memory(
		 pc_addr_i,
		instr_o
);
     
//I/O ports
		input  [32-1:0]  pc_addr_i;
		output [32-1:0]	 instr_o;

//Internal Signals
		reg    [32-1:0]	 instr_o;
		integer          i;

//32 words Memory
		reg    [32-1:0]  Instr_Mem [0:32-1];

//Parameter
    
//Main function
		always @(pc_addr_i) instr_o = Instr_Mem[pc_addr_i/4];

//Initial Memory Contents
		initial 
		begin
				for ( i=0; i<32; i=i+1 )
						Instr_Mem[i] = 32'b0;		
		end
endmodule
