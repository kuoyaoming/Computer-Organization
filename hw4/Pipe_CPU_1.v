module Pipe_CPU_1(
        clk_i,
		rst_n
		);
        
/****************************************
Parameter
****************************************/       

  
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_n;

/****************************************
Internal signal
****************************************/
wire [31:0]PC_4;
wire [31:0]branch_in;
wire PCSrc;
wire [31:0]pc_in;
wire [31:0]pc_out;
wire [31:0]instr;

wire [31:0]IF_ID_PC4;
wire [31:0]IF_ID_instr;
wire [31:0]rdata1;
wire [31:0]rdata2;
//wire [4:0]writereg;
//wire [31:0]writedata;
//
wire regwrite;
//

wire RegWrite_o;
wire [2:0]ALU_op_o;
wire ALUSrc_o;
wire RegDst_o;
wire Branch_o;
//wire Flag_ORI;
wire MemToReg_o;
wire MemRead_o;
wire MemWrite_o;
//

wire [31:0]signex;

wire ID_EX_RegWrite;
wire ID_EX_MemToReg;
wire ID_EX_Branch;
wire ID_EX_MemRead;
wire ID_EX_MemWrite;
wire ID_EX_RegDst;
wire [2:0]ID_EX_ALU_op;
wire ID_EX_ALUSrc;
wire [31:0]ID_EX_PC4;
wire [31:0]add2_o;
wire [31:0]AluIn1;
wire [31:0]ID_EX_rd2;
wire [31:0]ID_EX_signex;
wire [4:0]ID_EX_RD;
wire [4:0]ID_EX_RT;
wire [31:0]shift2;
wire [31:0]AluIn2;
wire [31:0]Alu_result;
wire [3:0]Aluctrl;

wire zero;
wire cout;
wire overflow;
wire [4:0]ID_EX_Write_R;

wire EX_M_RegWrite;
wire EX_M_MemToReg;
wire EX_M_Branch;
wire EX_M_MemRead;
wire EX_M_MemWrite;

wire M_zero;
wire [31:0]M_Alu_result;
wire [31:0]WriteData;       //W
wire [4:0]EX_M_Write_R;     //R
wire [31:0]Memdata_o;
wire [31:0]WB_Memdata_o;
wire [31:0]WB_Alu_result;
wire MemToReg;


wire [4:0]final_RD;
wire [31:0]final_data;

/**** IF stage ****/
MUX_2to1 #(.size(32)) Mux_PC(
        .data0_i(PC_4),
        .data1_i(branch_in),
        .select_i(PCSrc),
        .data_o(pc_in)
        );	
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_n (rst_n),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
Adder Adder1(                       // keep doing PC + 4
        .src1_i(pc_out),     
	    .src2_i(32'd4),     
	    .sum_o(PC_4)    
	    );
Instr_Memory IM(                    // Get Instruction from IM by PC address
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
	    );
/**** IF stage ****/
/**** IF stage ****/
Pipe_Reg #(.size(32)) IF_PC(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(PC_4),
		.data_o(IF_ID_PC4)
		);
Pipe_Reg #(.size(32)) IF_instr(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(instr),
		.data_o(IF_ID_instr)
		);
/**** IF stage ****/
/**** ID stage ****/
Reg_File RF(                        // Read or write register data
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(IF_ID_instr[25:21]) ,  
        .RTaddr_i(IF_ID_instr[20:16]) ,  
        .RDaddr_i(final_RD) ,  
        .RDdata_i(final_data)  , 
        .RegWrite_i (regwrite),
        .RSdata_o(rdata1) ,  
        .RTdata_o(rdata2)   
        );
Decoder Decoder(                    // Decode instruct to ALU / MUX / RF / BRANCH
        .instr_op_i(IF_ID_instr[31:26]), 
	    .RegWrite_o(RegWrite_o), 
	    .ALU_op_o(ALU_op_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o),          
		.Branch_o(Branch_o),
		.MemToReg_o(MemToReg_o),
		.Jump_o(),                   //¦h¾l
		.MemRead_o(MemRead_o),
		.MemWrite_o(MemWrite_o) 
	    );
Sign_Extend SE(                     // Sign extend from 16 bits to 32 bits
		//.ALUop(),
        .data_i(IF_ID_instr[15:0]),
        .data_o(signex)
        );
/**** ID stage ****/
/**** ID stage ****/      
Pipe_Reg #(.size(1))ID_WB(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(RegWrite_o),
		.data_o(ID_EX_RegWrite)
		);    
Pipe_Reg #(.size(1))ID_WB2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(MemToReg_o),
		.data_o(ID_EX_MemToReg)
		);  
Pipe_Reg #(.size(1))ID_M1(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(Branch_o),
		.data_o(ID_EX_Branch)
		); 
Pipe_Reg #(.size(1))ID_M2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(MemRead_o),
		.data_o(ID_EX_MemRead)
		); 
Pipe_Reg #(.size(1))ID_M3(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(MemWrite_o),
		.data_o(ID_EX_MemWrite)
		);       
Pipe_Reg  #(.size(1))ID_EX1(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ALUSrc_o),
		.data_o(ID_EX_ALUSrc)
		);
Pipe_Reg  #(.size(3))ID_EX2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ALU_op_o),
		.data_o(ID_EX_ALU_op)
		);
Pipe_Reg  #(.size(1))ID_EX3(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(RegDst_o),
		.data_o(ID_EX_RegDst)
		);

Pipe_Reg  #(.size(32))ID_PC(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(IF_ID_PC4),
		.data_o(ID_EX_PC4)
		);
Pipe_Reg  #(.size(32))Rd1(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(rdata1),
		.data_o(AluIn1)
		);
Pipe_Reg  #(.size(32))Rd2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(rdata2),
		.data_o(ID_EX_rd2)
		);
Pipe_Reg  #(.size(32))ID_SE(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(signex),
		.data_o(ID_EX_signex)
		);
Pipe_Reg  #(.size(5))ID_RD(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(IF_ID_instr[15:11]),
		.data_o(ID_EX_RD)
		);
Pipe_Reg  #(.size(5))ID_RT(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(IF_ID_instr[20:16]),
		.data_o(ID_EX_RT)
		);
         
/**** ID stage ****/
/**** EX stage ****/
Shift_Left_Two_32  Shifter(
        .data_i(ID_EX_signex),
        .data_o(shift2)
        ); 		
Adder Adder2(                       // PC = PC + 4 + branch_addr * 4
        .src1_i(shift2),     
	    .src2_i(ID_EX_PC4),     
	    .sum_o(add2_o)      
	    );
MUX_2to1 #(.size(32)) Mux_ALU(      // Select source of ALU_IN_2
        .data0_i(ID_EX_rd2),
        .data1_i(ID_EX_signex),
        .select_i(ID_EX_ALUSrc),
        .data_o(AluIn2)
        );	
alu ALU(
        .clk(clk_i),
        .rst(rst_n),
        .src1(AluIn1),
	    .src2(AluIn2),
	    .ALU_control(Aluctrl),
	    .result(Alu_result),
		.zero(zero),
		.cout(),
		.overflow()
	    );		
ALU_Ctrl AC(                        // Decode ALUCtrl_o
        .funct_i(ID_EX_signex[5:0]),   
        .ALUOp_i(ID_EX_ALU_op),   
        .ALUCtrl_o(Aluctrl) 
        );
MUX_2to1 #(.size(5)) Mux_Dst(
        .data0_i(ID_EX_RT),
        .data1_i(ID_EX_RD),
        .select_i(ID_EX_RegDst),
        .data_o(ID_EX_Write_R)
        );	
/**** EX stage ****/
/**** EX stage ****/    
Pipe_Reg  #(.size(1))EX_WB(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ID_EX_RegWrite),
		.data_o(EX_M_RegWrite)
		);   
Pipe_Reg #(.size(1))EX_WB2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ID_EX_MemToReg),
		.data_o(EX_M_MemToReg)
		);  
Pipe_Reg  #(.size(1))EX_M1(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ID_EX_Branch),
		.data_o(EX_M_Branch)
		); 
Pipe_Reg  #(.size(1))EX_M2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ID_EX_MemRead),
		.data_o(EX_M_MemRead)
		); 
Pipe_Reg  #(.size(1))EX_M3(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ID_EX_MemWrite),
		.data_o(EX_M_MemWrite)
		); 
Pipe_Reg  #(.size(32))EX_PC(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(add2_o),
		.data_o(branch_in)
		); 
Pipe_Reg  #(.size(1))EX_Zero(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(zero),
		.data_o(M_zero)
		); 
Pipe_Reg  #(.size(32))EX_Alu(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(Alu_result),
		.data_o(M_Alu_result)
		); 
Pipe_Reg  #(.size(32))EX_Rd2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ID_EX_rd2),
		.data_o(WriteData)
		);
Pipe_Reg  #(.size(5))EX_Write_R(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(ID_EX_Write_R),
		.data_o(EX_M_Write_R)
		);      
/**** EX stage ****/
/**** MEM stage ****/
and(PCSrc,EX_M_Branch,M_zero);
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(M_Alu_result),
		.data_i(WriteData),
		.MemRead_i(EX_M_MemRead),
		.MemWrite_i(EX_M_MemWrite),
		.data_o(Memdata_o)
		);
/**** MEM stage ****/
/**** MEM stage ****/
Pipe_Reg  #(.size(1))M_WB(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(EX_M_RegWrite),
		.data_o(regwrite)
		); 
Pipe_Reg #(.size(1))M_WB2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(EX_M_MemToReg),
		.data_o(MemToReg)
		); 
Pipe_Reg  #(.size(32))M_DM(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(Memdata_o),
		.data_o(WB_Memdata_o)
		);
Pipe_Reg  #(.size(32))M_Alu(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(M_Alu_result),
		.data_o(WB_Alu_result)
		);
Pipe_Reg  #(.size(5))M_Write_R(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(EX_M_Write_R),
		.data_o(final_RD)
		);
/**** MEM stage ****/
/**** WB stage ****/
MUX_2to1 #(.size(32)) Mux_MtoR(
        .data0_i(WB_Memdata_o),
        .data1_i(WB_Alu_result),
        .select_i(MemToReg),
        .data_o(final_data)
        );	
/**** WB stage ****/

endmodule

