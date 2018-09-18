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
wire [4:0]writereg;
wire [31:0]writedata;
wire regwrite;
wire RegWrite_o;
wire [2:0]ALU_op_o;
wire ALUSrc_o;
wire RegDst_o;
wire Branch_o;
wire Flag_ORI;
wire MemToReg_o;
wire MemRead_o;
wire MemWrite_o;
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
wire [31:0]WriteData;
wire [4:0]EX_M_Write_R;
wire [31:0]Memdata_o;
wire [31:0]WB_Memdata_o;
wire [31:0]WB_Alu_result;
wire MemToReg;
wire [4:0]shamt;

/**** IF stage ****/
MUX_2to1 #(.size(32)) Mux_PC(
        .data0_i(),
        .data1_i(),
        .select_i(),
        .data_o()
        );	
ProgramCounter PC(
        .clk_i(),      
	    .rst_n (),     
	    .pc_in_i() ,   
	    .pc_out_o() 
	    );
Adder Adder1(                       // keep doing PC + 4
        .src1_i(),     
	    .src2_i(),     
	    .sum_o()    
	    );
Instr_Memory IM(                    // Get Instruction from IM by PC address
        .pc_addr_i(),  
	    .instr_o()    
	    );
/**** IF stage ****/

/**** ID stage ****/
Reg_File RF(                        // Read or write register data
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i() ,  
        .RTaddr_i() ,  
        .RDaddr_i() ,  
        .RDdata_i()  , 
        .RegWrite_i (),
        .RSdata_o() ,  
        .RTdata_o()   
        );
Decoder Decoder(                    // Decode instruct to ALU / MUX / RF / BRANCH
        .instr_op_i(), 
	    .RegWrite_o(), 
	    .ALU_op_o(),   
	    .ALUSrc_o(),   
	    .RegDst_o(),   
		.Branch_o(),
		.Flag_ORI(),
		.MemToReg(),
		.BranchType(),
		.Jump(),
		.MemRead(),
		.MemWrite() 
	    );
Sign_Extend SE(                     // Sign extend from 16 bits to 32 bits
		.ALUop(),
        .data_i(),
        .data_o()
        );
/**** ID stage ****/

/**** EX stage ****/
Shift_Left_Two_32 #(.size(32)) Shifter(
        .data_i(),
        .data_o()
        ); 		
Adder Adder2(                       // PC = PC + 4 + branch_addr * 4
        .src1_i(),     
	    .src2_i(),     
	    .sum_o()      
	    );
MUX_2to1 #(.size(32)) Mux_ALU(      // Select source of ALU_IN_2
        .data0_i(),
        .data1_i(),
        .select_i(),
        .data_o()
        );	
alu ALU(
        .src1(),
	    .src2(),
	    .ALU_control(),
	    .result(),
		.zero(),
		.cout(),
		.overflow(),
        .shamt()
	    );		
ALU_Ctrl AC(                        // Decode ALUCtrl_o
        .funct_i(),   
        .ALUOp_i(),   
        .ALUCtrl_o() 
        );
MUX_2to1 #(.size(5)) Mux_Dst(
        .data0_i(),
        .data1_i(),
        .select_i(),
        .data_o()
        );	
/**** EX stage ****/

/**** MEM stage ****/
and(PCSrc,EX_M_Branch,M_zero);
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(),
		.data_i(),
		.MemRead_i(),
		.MemWrite_i(),
		.data_o()
		);
/**** MEM stage ****/

/**** WB stage ****/
MUX_2to1 #(.size(32)) Mux_MtoR(
        .data0_i(),
        .data1_i(),
        .select_i(),
        .data_o()
        );	
/**** WB stage ****/

/****************************************
signal assignment
****************************************/
/**** IF stage ****/
Pipe_Reg #(.size(32)) IF_PC(
        .rst_n(),
		.clk_i(),  
		.data_i(),
		.data_o()
		);
Pipe_Reg #(.size(32)) IF_instr(
        .rst_n(),
		.clk_i(),  
		.data_i(),
		.data_o()
		);
/**** IF stage ****/

/**** ID stage ****/      
Pipe_Reg #(.size(1))ID_WB(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);    
Pipe_Reg #(.size(1))ID_WB2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);  
Pipe_Reg #(.size(1))ID_M1(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg #(.size(1))ID_M2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg #(.size(1))ID_M3(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);       
Pipe_Reg  #(.size(1))ID_EX1(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(3))ID_EX2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(1))ID_EX3(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);

Pipe_Reg  #(.size(32))ID_PC(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(32))Rd1(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(32))Rd2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(32))ID_SE(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(5))ID_RD(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(5))ID_RT(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(5))ID_shamt(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);            
/**** ID stage ****/

/**** EX stage ****/    
Pipe_Reg  #(.size(1))EX_WB(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);   
Pipe_Reg #(.size(1))EX_WB2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);  
Pipe_Reg  #(.size(1))EX_M1(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg  #(.size(1))EX_M2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg  #(.size(1))EX_M3(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg  #(.size(32))EX_PC(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg  #(.size(1))EX_Zero(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg  #(.size(32))EX_Alu(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg  #(.size(32))EX_Rd2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(5))EX_Write_R(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);      
/**** EX stage ****/

/**** MEM stage ****/
Pipe_Reg  #(.size(1))M_WB(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg #(.size(1))M_WB2(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		); 
Pipe_Reg  #(.size(32))M_DM(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(32))M_Alu(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
Pipe_Reg  #(.size(5))M_Write_R(
        .rst_n(rst_n),
		.clk_i(clk_i),  
		.data_i(),
		.data_o()
		);
/**** MEM stage ****/

/**** WB stage ****/
/**** WB stage ****/

/****************************************
Instnatiate modules
****************************************/

//Instantiate the components in IF stage

//Instantiate the components in ID stage

//Instantiate the components in EX stage	   

//Instantiate the components in MEM stage


//Instantiate the components in WB stage

endmodule

