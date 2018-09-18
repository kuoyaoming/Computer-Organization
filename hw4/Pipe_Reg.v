module Pipe_Reg(
            rst_n,
			clk_i,   
			data_i,
			data_o
);
					
parameter size = 0;
input                    rst_n;
input                    clk_i;		  
input      [size-1: 0] data_i;
output reg [size-1: 0] data_o;
	  
always @(posedge clk_i or negedge  rst_n) begin
	if(!rst_n) data_o <= 0;
    else data_o <= data_i;
end

endmodule	