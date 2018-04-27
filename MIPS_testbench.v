`timescale 1ps/1ps
module MIPS_testbench();

// the clock
reg clk;
integer cycle_counter;

// instantiate the mips processor
MIPS mips(clk);

// get the clock working
initial 
begin
	// mips.IF_Stage_Module.instruction_memory[0] =
	cycle_counter <= 0;
	clk <= 1;
	forever 
	begin
		#100 clk <= ~clk;
	end
end

// incrememnt cycle counter at each positive edge
always @(posedge clk) cycle_counter <= cycle_counter + 1;

// monitor the cycle counter
initial
begin
$monitor("Cycle %d\n", cycle_counter,
//--- IF Stage Output ---//
"IF/ID Stage Pipeline Register:\n",
"PC=%d\n", MIPS_testbench.mips.IF_Stage_Module.PC,
"PC+4=%d\n", MIPS_testbench.mips.ID_new_pc_value,
"Instruction=%b\n", MIPS_testbench.mips.ID_instruction,
//--- End IF Stage Output ---//
"------------------------------------------------------------\n",
//--- ID Stage Output ---//
"ID/EX Stage Pipeline Register:\n",
"Instruction[15:11]=%b\n", MIPS_testbench.mips.EX_instr_bits_15_11,
"Instruction[20:16]=%b\n", MIPS_testbench.mips.EX_instr_bits_20_16,
"Extended Bits=%b\n", MIPS_testbench.mips.EX_extended_bits,
"Read Data 1=%d\n", MIPS_testbench.mips.EX_read_data1,
"Read Data 2=%d\n", MIPS_testbench.mips.EX_read_data2,
"PC + 4=%d\n", MIPS_testbench.mips.EX_new_pc_value,
"RegDst=%b\n", MIPS_testbench.mips.EX_RegDst,
"RegWrite=%b\n", MIPS_testbench.mips.EX_RegWrite,
"ALUSrc=%b\n", MIPS_testbench.mips.EX_ALUSrc,
"MemWrite=%b\n", MIPS_testbench.mips.EX_MemWrite,
"MemRead=%b\n", MIPS_testbench.mips.EX_MemRead,
"MemToReg=%b\n", MIPS_testbench.mips.EX_MemToReg,
"Branch=%b\n", MIPS_testbench.mips.EX_branch,
"Load Mode=%b\n", MIPS_testbench.mips.EX_load_mode,
"ALUOp=%b\n", MIPS_testbench.mips.EX_ALUOp,
//--- End ID Stage Output ---//
"------------------------------------------------------------\n",
//--- EX Stage Output ---//
"EX/MEM Stage Pipeline Register:\n",
"RegWrite=%b\n", MIPS_testbench.mips.MEM_reg_write,
"MemWrite=%b\n", MIPS_testbench.mips.MEM_mem_write,
"MemRead=%b\n", MIPS_testbench.mips.MEM_mem_read,
"MemToReg=%b\n", MIPS_testbench.mips.MEM_mem_to_reg,
"PC Branch Address=%d\n", MIPS_testbench.mips.IF_branch_address,
"Zero=%b\n", MIPS_testbench.mips.MEM_zero,
"ALU Result/Address=%d\n", MIPS_testbench.mips.MEM_address,
"Write Data=%d\n", MIPS_testbench.mips.MEM_write_data,
"Writeback Destination=%b\n", MIPS_testbench.mips.MEM_write_back_destination,
"Load Mode=%b\n", MIPS_testbench.mips.MEM_load_mode,
"Branch=%b\n", MIPS_testbench.mips.MEM_branch,
//--- End EX Stage Output ---//
"------------------------------------------------------------\n",
//--- MEM Stage Output ---//
"MEM/WB Stage Pipeline Register:\n",
"Writeback Destination=%b\n", MIPS_testbench.mips.WB_write_back_destination,
"RegWrite=%b\n", MIPS_testbench.mips.WB_reg_write,
"Read Data=%b\n", MIPS_testbench.mips.WB_read_data,
"AluResult=%b\n", MIPS_testbench.mips.WB_address,
"MemToReg=%b\n", MIPS_testbench.mips.WB_mem_to_reg,
//--- End MEM Stage Output ---//
"------------------------------------------------------------\n",
"End of Cycle\n",
"==============================================================\n",
"=============================================================="
);
end

// stop after 1000ps
initial
begin
	#1000 $stop;
end


endmodule
