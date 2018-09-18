`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:00:19 12/03/2017 
// Design Name: 
// Module Name:    Sign_Extend 
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
module Sign_Extend(
    data_i,
    data_o
    );
               
//I/O ports
			input   [16-1:0] data_i;
			output  [32-1:0] data_o;

//Internal Signals
			reg     [32-1:0] data_o;

//Sign extended
			always @(data_i) 
			begin
					 if (data_i[15] == 0) 
					 begin
						  data_o [31:16] <= 16'b0000000000000000;
						  data_o  [15:0] <= data_i;
					 end
					 else 
					 begin
						  data_o [31:16] <= 16'b1111111111111111;
						  data_o  [15:0] <= data_i;
					 end
			end
endmodule
