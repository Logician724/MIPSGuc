module EX_Stage(clk, in_RegDst, in_RegWrite, in_ALUSrc, in_MemWrite, in_MemRead, in_MemToReg,
in_ALUOp, in_instr_bits_15_11, in_instr_bits_20_16, in_extended_bits, in_read_data1,
in_read_data2, in_new_pc_value, in_load_mode,
zero_out, RegWrite_out, MemWrite_out, MemRead_out, MemToReg_out,load_mode_out,
writebackDestination_out, aluResult_out, rt_out, pc_out);

// inputs to the stage
input clk, in_RegDst, in_RegWrite, in_ALUSrc, in_MemWrite, in_MemRead, in_MemToReg;
input [1:0] in_load_mode;
input [2:0] in_ALUOp;
input [4:0] in_instr_bits_15_11, in_instr_bits_20_16;
input [31:0] in_extended_bits, in_read_data1, in_read_data2, in_new_pc_value;

// outputs from the stage
output reg zero_out, RegWrite_out, MemWrite_out, MemRead_out, MemToReg_out;
output reg [1:0] load_mode_out;
output reg [4:0] writebackDestination_out;
output reg [31:0] aluResult_out, rt_out, pc_out;

// multiplexer before ALU
reg [31:0] second_alu_input;
always @(in_read_data2, in_extended_bits, in_ALUSrc)
begin
	if(in_ALUSrc)
		second_alu_input <= in_extended_bits;
	else
		second_alu_input <= in_read_data2;
end

// ALU Control
ALU_Control alu_control(in_ALUOp, in_extended_bits[5:0], aluControlInput);

// ALU
ALU alu (in_read_data1, second_alu_input, aluControlInput, aluResult, in_extended_bits[10:6], zero);

// PC calculation unit
EX_PC_Calculation pc_calculator(in_new_pc_value, in_extended_bits, PC);

// multiplexer for write_back_destination
reg [4:0] write_back_destination;
always @(in_instr_bits_15_11, in_instr_bits_20_16, in_RegDst)
begin
	if(in_RegDst)
		write_back_destination <= in_instr_bits_15_11;
	else
		write_back_destination <= in_instr_bits_20_16;
end

// pipelining register
EX_MEM_Reg pipelining_register(clk, in_RegWrite, in_MemWrite, in_MemRead, in_MemToReg, PC, 
	zero, aluResult, in_read_data2, write_back_destination, in_load_mode,
	RegWrite_out, MemWrite_out, MemRead_out, MemToReg_out, pc_out,
	zero_out, aluResult_out, rt_out, writebackDestination_out, load_mode_out);

endmodule
