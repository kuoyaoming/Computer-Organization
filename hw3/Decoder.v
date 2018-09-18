`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:53:41 12/02/2017 
// Design Name: 
// Module Name:    Decoder 
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
module Decoder(
		 instr_op_i,
		 RegWrite_o,
		 ALU_op_o,
		 ALUSrc_o,
		 RegDst_o,
		 Branch_o,
		 MemWrite_o,
		 MemRead_o,
		 MemtoReg_o,
		 Jump_o
);
     
//I/O ports
		input  [6-1:0] instr_op_i;
		output  RegWrite_o;
		output [3-1:0] ALU_op_o;
		output  ALUSrc_o;
		output  RegDst_o;
		output  Branch_o;
		output  MemWrite_o;
		output  MemRead_o;
		output  MemtoReg_o;
		output  Jump_o;
 
//Internal Signals
		reg       [3-1:0] ALU_op_o;  
		reg       R_format;
		reg       beq,addi,slti,lui,ori,bne,lw,sw,j;
		wire      RegDst_o;
		wire	  Branch_o;
		wire	  RegWrite_o;
		wire	  ALUSrc_o;
		wire      MemWrite_o;
		wire      MemRead_o;
		wire      MemtoReg_o;
		wire      Jump_o;
       //Parameter
		parameter    R_type=6'b000000;
		parameter    BEQ =6'b000100;
		parameter    ADDi=6'b001000;
		parameter    SLTi=6'b001010;
		parameter    LUI =6'b001111;
		parameter    ORi =6'b001101;
		parameter    BNE =6'b000101;
		parameter    LW  =6'b100011;
		parameter    SW  =6'b101011;
		parameter    J   =6'b000010;
		    

        //Main function
        //Check op code instrustion
		always @(instr_op_i) 
		begin
					R_format<=(instr_op_i==R_type)?1:0;
					beq<=(instr_op_i == BEQ)? 1:0;
					addi<=(instr_op_i==ADDi)?1:0;
					slti<=(instr_op_i==SLTi)?1:0;
					lui<=(instr_op_i==LUI)?1:0;
					ori<=(instr_op_i==ORi)?1:0;
					bne<=(instr_op_i==BNE)?1:0;
					lw<=(instr_op_i==LW)?1:0;
					sw<=(instr_op_i==SW)?1:0;
					j<=(instr_op_i==J)?1:0;
		end
		assign   RegDst_o= R_format;             //R-type control
		assign   ALUSrc_o= addi || slti || lui || ori || sw || lw; // immediate value control
		assign   Branch_o= beq || bne;           //Branch control
		assign   RegWrite_o=(~beq && ~sw) && (~j) ;        //Regsister write control
		assign   MemWrite_o=sw;                  //Datamemory write control
		assign   MemRead_o =lw;                  //Datamemory read control
		assign   MemtoReg_o=lw;                  //Datamemory to Regsister mux control 
		assign   Jump_o    =j;                   //Jump instruction mux control
		always @(instr_op_i) 
		begin                                    //Decoder to ALU-Control(ALU_op_o)
				 case(instr_op_i)
						R_type:  ALU_op_o = 3'b010;
						BEQ:     ALU_op_o = 3'b001;
						ADDi:    ALU_op_o = 3'b100;
						SLTi:    ALU_op_o = 3'b101;
						LUI:     ALU_op_o = 3'b110;
						ORi:     ALU_op_o = 3'b111;
						BNE:     ALU_op_o = 3'b001;
						LW:      ALU_op_o = 3'b100;//
						SW:      ALU_op_o = 3'b100;//
						default: ALU_op_o = 3'b000;
				 endcase
		end
endmodule

