`timescale 1ns / 1ps

module Simple_Single_CPU(
       clk_i,
		  rst_n
		);
		
//I/O port
		input         clk_i;
		input         rst_n;
//Internal Signles
//宣告出所有會用到的線再照著ppt接起來
		wire  [32-1:0]  pc_out_o;
		wire  [32-1:0]  instr_add_4_o;
		wire  [32-1:0]  instr_o;
		wire  [32-1:0]  RSdata_o;
		wire  [32-1:0]  RTdata_o;
		wire  [32-1:0]  SE_o;
		wire  [32-1:0]  ALU_src2_o;
		wire  [32-1:0]  Shifter_o;
		wire  [32-1:0]  instr_branch_o;
		wire  [32-1:0]  instr_next_o;
		wire  [32-1:0]  ALU_result_o;
		wire  [5-1:0]   RDaddr_o;
		wire  [4-1:0]   ALU_ctrl_o;
		wire  [3-1:0]   ALU_op_o;
		wire  ALUSrc_o;
		wire  RegDst_o;
		wire  RegWrite_o;
		wire  Branch_o;
		wire  ALU_zero_o;
		wire  sel_branch_o;
		wire  ALU_cout_o;
		wire  ALU_overflow_o;
		
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),
	     .rst_n (rst_n),
	     .pc_in_i(instr_next_o),
	     .pc_out_o(pc_out_o)
	    );
	
Adder Adder1(
        .src1_i(pc_out_o),
	     .src2_i(32'd4),
	     .sum_o(instr_add_4_o)
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out_o),
	     .instr_o(instr_o)  
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst_o),
        .data_o(RDaddr_o)
        );	
		
Reg_File RF(
        .clk_i(clk_i),
	     .rst_n(rst_n),
        .RSaddr_i(instr_o[25:21]),
        .RTaddr_i(instr_o[20:16]),
        .RDaddr_i(RDaddr_o),
        .RDdata_i(ALU_result_o),
        .RegWrite_i(RegWrite_o),
        .RSdata_o(RSdata_o),
        .RTdata_o(RTdata_o) 
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]),
	     .RegWrite_o(RegWrite_o),
	     .ALU_op_o(ALU_op_o),
	     .ALUSrc_o(ALUSrc_o),
	     .RegDst_o(RegDst_o),
  		  .Branch_o(Branch_o)
	    );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),
		  .ALUOp_i(ALU_op_o),
        .ALUCtrl_o(ALU_ctrl_o)
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(SE_o)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_o),
        .data1_i(SE_o),
        .select_i(ALUSrc_o),
        .data_o(ALU_src2_o)
        );	
		
alu ALU(
		  .src1(RSdata_o),
	     .src2(ALU_src2_o),
	     .ALU_control(ALU_ctrl_o),
	     .result(ALU_result_o),
		  .zero(ALU_zero_o),
		  .cout(ALU_cout_o),
		  .overflow(ALU_ovflow_o)
	    );		
Adder Adder2(
        .src1_i(instr_add_4_o),
	     .src2_i(Shifter_o),
	     .sum_o(instr_branch_o)
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(SE_o),
        .data_o(Shifter_o)
        ); 		
and(sel_branch_o ,ALU_zero_o, Branch_o);	
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(instr_add_4_o),
        .data1_i(instr_branch_o),
        .select_i(sel_branch_o),
        .data_o(instr_next_o)
        );	


endmodule
