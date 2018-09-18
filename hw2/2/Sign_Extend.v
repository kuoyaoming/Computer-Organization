`timescale 1ns / 1ps

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
					 if (data_i[15] == 0) //如果輸入為0就將輸入由16bit轉成32bit
					 begin
						  data_o [31:16] <= 16'd0;
						  data_o  [15:0] <= data_i;
					 end
					 else 
					 begin
						  data_o [31:16] <= 16'd0;
						  data_o  [15:0] <= data_i;
					 end
			end
endmodule
