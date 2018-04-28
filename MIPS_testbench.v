module MIPS_testbench();

// the clock
reg clk;
integer cycle_counter;

// instantiate the mips processor
MIPS mips(clk);

// get the clock working
initial 
begin
	//mips.IF_Stage_Module.instruction_memory[0] <= 32'b001000_00000_01001_0000000000000010; // addi $t1,$0,2
	MIPS_testbench.mips.ID_Stage_Module.Registers.registers[10] <= 32'd7;
	MIPS_testbench.mips.ID_Stage_Module.Registers.registers[11] <= 32'd32;
	MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram[20] <= 255;
	MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram[21] <= 255;
	MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram[22] <= 255;
	MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram[23] <= 255;
	mips.IF_Stage_Module.instruction_memory[0] <= 32'b000000_01010_01011_01001_00000_100101; // lw $t1, 4($t2)
	//mips.IF_Stage_Module.instruction_memory[2] <= 32'b001000_00000_01000_0000000000000100;
	//mips.IF_Stage_Module.instruction_memory[3] <= 32'b000000_00000_00000_0000000000000000;
	cycle_counter <= 0;
	clk <= 1;
	forever 
	begin
		#100 clk <= ~clk;
	end
end

// incrememnt cycle counter at each positive edge
always @(posedge clk) cycle_counter <= #10 cycle_counter + 1;

// monitor the cycle counter
initial
begin
$monitor("Cycle %d\n", cycle_counter,
//--- PC Output ---//
"PC=%d\n", MIPS_testbench.mips.IF_Stage_Module.PC,
//--- END PC Output ---//
//--- IF Stage Output ---//
"IF/ID Stage Pipeline Register:\n",
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
"Result After WB Stage:\n",
"Register File: %p\n",MIPS_testbench.mips.ID_Stage_Module.Registers.registers,
"The Data Memory will be printed once at the end of the program because of its size\n",
"End of Cycle\n",
"==============================================================\n",
"=============================================================="
);
end

// stop after program ends
initial
begin
	#1200 $display("Register File: %p",MIPS_testbench.mips.ID_Stage_Module.Registers.registers);
	$display("Data Memory (Bytes): %p", MIPS_testbench.mips.MEM_Stage_Module.mem_ram.ram);
	$stop;
end


endmodule
