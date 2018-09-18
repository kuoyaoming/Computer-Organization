`timescale 1ns / 1ps

module Decoder(
		 instr_op_i,
		 RegWrite_o,
		 ALU_op_o,
		 ALUSrc_o,
		 RegDst_o,
		 Branch_o
);
     
//I/O ports
		input  [6-1:0] instr_op_i;
		output  RegWrite_o;
		output [3-1:0] ALU_op_o;
		output  ALUSrc_o;
		output  RegDst_o;
		output  Branch_o;
 
//Internal Signals
		reg    [3-1:0] ALU_op_o;  
		reg     R_format;
		reg     beq,addi,slti,lui,ori,bne;
		wire    RegDst_o;
		wire	  Branch_o;
		wire	  RegWrite_o;
		wire	  ALUSrc_o; 
//Parameter
		parameter    R_type=6'b000000;
		parameter    BEQ =6'b000100;
		parameter    ADDi=6'b001000;
		parameter    SLTi=6'b001010;
		parameter    LUI =6'b001111;
		parameter    ORi =6'b001101;
		parameter    BNE =6'b000101;

//Main function
always @(instr_op_i) //剛opcode進來時開始解碼
		begin
					R_format<=(instr_op_i==R_type)?1:0;//根據輸入的質來判斷相對應的指令
					beq<=(instr_op_i == BEQ)? 1 : 0;
					addi<=(instr_op_i==ADDi)?1:0;
					slti<=(instr_op_i==SLTi)?1:0;
					lui<=(instr_op_i==LUI)?1:0;
					ori<=(instr_op_i==ORi)?1:0;
					bne<=(instr_op_i==BNE)?1:0;
		end
		assign   RegDst_o= R_format;//指令處理
		assign   ALUSrc_o= addi || slti || lui || ori;
		assign   Branch_o= beq || bne;
		assign   RegWrite_o= ~beq && ~bne;
		always @(instr_op_i) 
		begin
				 case(instr_op_i)//根據不同的指令給出相對應的ALU控制碼
						R_type:  ALU_op_o = 3'b010;
						BEQ:     ALU_op_o = 3'b001;
						ADDi:    ALU_op_o = 3'b100;
						SLTi:    ALU_op_o = 3'b101;
						LUI:     ALU_op_o = 3'b110;
						ORi:     ALU_op_o = 3'b111;
						BNE:     ALU_op_o = 3'b001;
						default: ALU_op_o = 3'b000;
				 endcase
		end
endmodule

