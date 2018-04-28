module MIPS_testbench();

// the clock
reg clk;
integer cycle_counter;

// instantiate the mips processor
MIPS mips(clk);

// get the clock working
initial 
begin
		// branch
		MIPS_testbench.mips.ID_Stage_Module.Registers.registers[10] <= 14;
	MIPS_testbench.mips.ID_Stage_Module.Registers.registers[9] <= 14;
	MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram[20] <= 255;
	MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram[21] <= 255;
	MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram[22] <= 255;
	MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram[23] <= 255;
	MIPS_testbench.mips.IF_Stage_Module.instruction_memory[0] <= 32'b000100_01001_01010_0000000000001000; // branch
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
//--- PC Output ---//
"PC At the End of Cycle =%h\n", MIPS_testbench.mips.IF_Stage_Module.PC,
//--- END PC Output ---//
//--- IF Stage Output ---//
"IF/ID Stage Pipeline Register:\n",
"PC+4=%h\n", MIPS_testbench.mips.ID_new_pc_value,
"Instruction=%h\n", MIPS_testbench.mips.ID_instruction,
//--- End IF Stage Output ---//
"------------------------------------------------------------\n",
//--- ID Stage Output ---//
"ID/EX Stage Pipeline Register:\n",
"Instruction[15:11]=%h\n", MIPS_testbench.mips.EX_instr_bits_15_11,
"Instruction[20:16]=%h\n", MIPS_testbench.mips.EX_instr_bits_20_16,
"Extended Bits=%h\n", MIPS_testbench.mips.EX_extended_bits,
"Read Data 1 (Decimal)=%d\n", MIPS_testbench.mips.EX_read_data1,
"Read Data 2 (Decimal)=%d\n", MIPS_testbench.mips.EX_read_data2,
"PC + 4=%h\n", MIPS_testbench.mips.EX_new_pc_value,
"RegDst=%b\n", MIPS_testbench.mips.EX_RegDst,
"RegWrite=%b\n", MIPS_testbench.mips.EX_RegWrite,
"ALUSrc=%b\n", MIPS_testbench.mips.EX_ALUSrc,
"MemWrite=%b\n", MIPS_testbench.mips.EX_MemWrite,
"MemRead=%b\n", MIPS_testbench.mips.EX_MemRead,
"MemToReg=%b\n", MIPS_testbench.mips.EX_MemToReg,
"Branch=%b\n", MIPS_testbench.mips.EX_branch,
"Load Mode=%h\n", MIPS_testbench.mips.EX_load_mode,
"ALUOp=%h\n", MIPS_testbench.mips.EX_ALUOp,
//--- End ID Stage Output ---//
"------------------------------------------------------------\n",
//--- EX Stage Output ---//
"EX/MEM Stage Pipeline Register:\n",
"RegWrite=%b\n", MIPS_testbench.mips.MEM_reg_write,
"MemWrite=%b\n", MIPS_testbench.mips.MEM_mem_write,
"MemRead=%b\n", MIPS_testbench.mips.MEM_mem_read,
"MemToReg=%b\n", MIPS_testbench.mips.MEM_mem_to_reg,
"PC Branch Address=%h\n", MIPS_testbench.mips.IF_branch_address,
"Zero=%b\n", MIPS_testbench.mips.MEM_zero,
"ALU Result/Address (decimal) = %d\n", MIPS_testbench.mips.MEM_address,
"Write Data (decimal) = %d\n", MIPS_testbench.mips.MEM_write_data,
"Writeback Destination=%h\n", MIPS_testbench.mips.MEM_write_back_destination,
"Load Mode = %h\n", MIPS_testbench.mips.MEM_load_mode,
"Branch=%b\n", MIPS_testbench.mips.MEM_branch,
//--- End EX Stage Output ---//
"------------------------------------------------------------\n",
//--- MEM Stage Output ---//
"MEM/WB Stage Pipeline Register:\n",
"Writeback Destination=%h\n", MIPS_testbench.mips.WB_write_back_destination,
"RegWrite=%b\n", MIPS_testbench.mips.WB_reg_write,
"Read Data (decimal) = %d\n", MIPS_testbench.mips.WB_read_data,
"AluResult (decimal) = %d\n", MIPS_testbench.mips.WB_address,
"MemToReg = %b\n", MIPS_testbench.mips.WB_mem_to_reg,
//--- End MEM Stage Output ---//
"------------------------------------------------------------\n",
"==============================================================\n",
"=============================================================="
);
end

// stop after program ends
initial
begin
	#1800 $display("Register File: %p",MIPS_testbench.mips.ID_Stage_Module.Registers.registers);
	$display("Data Memory (Bytes): %p", MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram);
	$stop;
end


endmodule
