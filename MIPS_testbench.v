module MIPS_testbench();

// the clock
reg CLK;
integer cycle_counter;

// instantiate the mips processor
MIPS mips(CLK);

// get the clock working
initial 
begin
	cycle_counter <= 0;
	CLK <= 0;
	forever 
	begin
		#100 CLK <= ~CLK;
	end
end

// incrememnt cycle counter at each positive edge
always @(posedge CLK) cycle_counter <= cycle_counter + 1;

// monitor the cycle counter
initial
begin
$monitor("Cycle %d\n", cycle_counter,
//--- IF Stage Output ---//
"IF/ID Stage Pipeline Register:\n",
"PC+4=%d\n", MIPS_testbench.mips.IF_ID_NEXT_INS_ADR,
"Instruction=%b\n", MIPS_testbench.mips.IF_ID_CUR_INS,
//--- End of IF Stage ---//
//--- ID Stage Output ---//
"ID/EX Stage Pipeline Register:\n",
"Instruction Bits [15:11] = %b\n", MIPS_testbench.mips.ID_EX_instr_bits_15_11,
"Instruction Bits [20:16] = %b\n", MIPS_testbench.mips.ID_EX_instr_bits_20_16,
"Extended Bits = %b\n", MIPS_testbench.mips.ID_EX_extended_bits,
"Read Data 1 = %d\n", MIPS_testbench.mips.ID_EX_read_data1,
"Read Data 2 = %d\n", MIPS_testbench.mips.ID_EX_read_data2,
"PC + 4 = %d\n", MIPS_testbench.mips.ID_EX_new_pc_value,
"RegDst = %b\n", MIPS_testbench.mips.ID_EX_RegDst,
"RegWrite = %b\n", MIPS_testbench.mips.ID_EX_RegWrite,
"ALUSrc = %b\n", MIPS_testbench.mips.ID_EX_ALUSrc,
"MemWrite = %b\n", MIPS_testbench.mips.ID_EX_MemWrite,
"MemRead = %b\n", MIPS_testbench.mips.ID_EX_MemRead,
"MemToReg = %b\n", MIPS_testbench.mips.ID_EX_MemToReg,
"Branch = %b\n", MIPS_testbench.mips.ID_EX_Branch,
"Load Mode = %b\n", MIPS_testbench.mips.ID_EX_load_mode,
"ALUOp = %b\n", MIPS_testbench.mips.ID_EX_ALUOp,
//--- End of ID Stage ---//
//--- EX Stage Output ---//
"EX/MEM Stage Pipeline Register:\n",
MIPS_testbench.mips.EX_MEM_zero_out,
"RegWrite = %b\n", MIPS_testbench.mips.EX_MEM_RegWrite_out,
"MemWrite = %b\n", MIPS_testbench.mips.EX_MEM_MemWrite_out,
"MemRead = %b\n", MIPS_testbench.mips.EX_MEM_MemRead_out,
"MemToReg = %b\n", MIPS_testbench.mips.EX_MEM_MemToReg_out,
"Load Mode = %b\n", MIPS_testbench.mips.EX_MEM_load_mode_out,
"Writeback Destination = %b\n", MIPS_testbench.mips.EX_MEM_writebackDestination_out,
"ALU Result = %d\n", MIPS_testbench.mips.EX_MEM_aluResult_out,
"Write Data (RT for Memory) = %d\n", MIPS_testbench.mips.EX_MEM_rt_out,
"PC + 4 + Offset = %d\n", MIPS_testbench.mips.EX_IF_pc_out,
"Branch = %b\n", MIPS_testbench.mips.EX_MEM_branch_out,
//--- End of EX Stage ---//
//--- MEM Stage Output ---//
"MEM/WB Stage Pipeline Register:\n",
"PCSrc = %b\n", MIPS_testbench.mips.MEM_IF_pc_src,
"Read Data = %d\n", MIPS_testbench.mips.MEM_WB_read_data,
"MemToReg = %b\n", MIPS_testbench.mips.MEM_WB_mem_to_reg,
"RegWrite = %b\n", MIPS_testbench.mips.MEM_WB_reg_write_out,
"ALU Result = %d\n", MIPS_testbench.mips.MEM_WB_address_out,
"Writeback Destination = %b\n", MIPS_testbench.mips.MEM_WB_write_back_destination_out,
//--- End of MEM Stage ---//
//--- WB Stage Output ---//
"WB Stage Output:\n",
"Write Data = %b\n", MIPS_testbench.mips.WB_ID_wb_out,
"RegWrite = %b\n", MIPS_testbench.mips.WB_ID_reg_write_out,
"Writeback Destination = %b\n", MIPS_testbench.mips.WB_ID_write_back_destination_out,
//--- End of WB Stage ---//
"End of Clock Cycle %d", cycle_counter
);
end

// stop after 1000ps
initial
begin
	#400 $stop;
end


endmodule
