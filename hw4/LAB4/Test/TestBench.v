`timescale 1ns / 1ps
`define CYCLE_TIME 10
`define DATA_NUM 32			

module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;
integer     i;
integer     handle;
integer		Reg_Error_Number;
integer		Mem_Error_Number;
integer		Check_Index;

// answwer data
reg	[32:0] Reg_data				[0:`DATA_NUM - 1];
reg	[32:0] Memory_data			[0:`DATA_NUM - 1];

//Greate tested modle  
Pipe_CPU_1 cpu(
        .clk_i(CLK),
	    .rst_n(RST)
		);
 
//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial  begin
	$readmemb("PipelineData.txt", cpu.IM.Instr_Mem);
	$readmemh("Check_Reg.txt", Reg_data);
	$readmemh("Check_Mem.txt", Memory_data);
	
	CLK = 0;
	RST = 0;
	count = 0;
	Reg_Error_Number = 0;
	Mem_Error_Number = 0;
    
    #(`CYCLE_TIME)      RST = 1;

end


always@(posedge CLK) begin
    count = count + 1;
	
	// check 
	if( count == 30 ) begin
		for(Check_Index = 0; Check_Index < `DATA_NUM; Check_Index = Check_Index + 1) begin
			if(Reg_data[Check_Index] != cpu.RF.Reg_File[Check_Index])
				Reg_Error_Number = Reg_Error_Number +1;
			if(Memory_data[Check_Index] != cpu.DM.memory[Check_Index])
				Mem_Error_Number = Mem_Error_Number +1;
		end

		if(Reg_Error_Number == 0 && Mem_Error_Number == 0) begin
				$display("============================================");
				$display("======== ==== ============= ==== ===========");
				$display("========  ==  =============  ==  ===========");
				$display("========      ==   ===   ==      ===========");
				$display("=========    ==== ===== ====    ============");
				$display("==========  ===           ===  =============");
				$display("===========  ==           ==  ==============");
				$display("============================================");
				$display("Congratulation.  Final Lab Pass!!!!!!!!!!!!!");
				$stop;
		end
		else begin
			$display("ERROR!!ERROR!!ERROR!!ERROR!!ERROR!!ERROR!!ERROR!!");
			//print result to transcript 
			$display("Your Register===========================================================");
			$display("r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d,",
			cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], cpu.RF.Reg_File[4], 
			cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
			);
			$display("r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d, r15=%d,",
			cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10], cpu.RF.Reg_File[11], cpu.RF.Reg_File[12], 
			cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15],
			);
			$display("r16=%d, r17=%d, r18=%d, r19=%d, r20=%d, r21=%d, r22=%d, r23=%d,",
			cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19], cpu.RF.Reg_File[20], 
			cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23],
			);
			$display("r24=%d, r25=%d, r26=%d, r27=%d, r28=%d, r29=%d, r30=%d, r31=%d",
			cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], cpu.RF.Reg_File[28], 
			cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31],
			);
			
			$display("\nCorrect Register===========================================================");
			for(Check_Index = 0; Check_Index < `DATA_NUM; Check_Index = Check_Index + 1) begin
				$write("r%1d=%8d, ",Check_Index,Reg_data[Check_Index]);
				if(Check_Index % 7 == 0)
					$write("\n");
			end
			
			
			$display("\n\nYour Memory===========================================================");
			$display("m0=%d, m1=%d, m2=%d, m3=%d, m4=%d, m5=%d, m6=%d, m7=%d\nm8=%d, m9=%d, m10=%d, m11=%d, m12=%d, m13=%d, m14=%d, m15=%d\nr16=%d, m17=%d, m18=%d, m19=%d, m20=%d, m21=%d, m22=%d, m23=%d\nm24=%d, m25=%d, m26=%d, m27=%d, m28=%d, m29=%d, m30=%d, m31=%d",							 
					  cpu.DM.memory[0], cpu.DM.memory[1], cpu.DM.memory[2], cpu.DM.memory[3],
						 cpu.DM.memory[4], cpu.DM.memory[5], cpu.DM.memory[6], cpu.DM.memory[7],
						 cpu.DM.memory[8], cpu.DM.memory[9], cpu.DM.memory[10], cpu.DM.memory[11],
						 cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
						 cpu.DM.memory[16], cpu.DM.memory[17], cpu.DM.memory[18], cpu.DM.memory[19],
						 cpu.DM.memory[20], cpu.DM.memory[21], cpu.DM.memory[22], cpu.DM.memory[23],
						 cpu.DM.memory[24], cpu.DM.memory[25], cpu.DM.memory[26], cpu.DM.memory[27],
						 cpu.DM.memory[28], cpu.DM.memory[29], cpu.DM.memory[30], cpu.DM.memory[31]
					  );
					  
					  
			$display("\nCorrect Memory===========================================================");
			for(Check_Index = 0; Check_Index < `DATA_NUM; Check_Index = Check_Index + 1) begin
				$write("m%1d=%8d, ",Check_Index,Memory_data[Check_Index]);
				if(Check_Index % 7 == 0)
					$write("\n");
			end
			
			$stop;
		end
	end
	
	
end
  
endmodule

