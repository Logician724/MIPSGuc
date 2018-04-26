module EX_Stage(
	input clk,
	input in_RegDst,
	input in_RegWrite,
	input in_ALUSrc,
	input in_MemWrite,
	input in_MemRead,
	input in_MemToReg,
	input [2:0] in_ALUOp,
	input [4:0] in_instr_bits_15_11,
	input [4:0] in_instr_bits_20_16,
	input [31:0] in_extended_bits,
	input [31:0] in_read_data1,
	input [31:0] in_read_data2,
	input [31:0] in_new_pc_value,
	input [1:0] in_load_mode,
	output zero_out,
	output RegWrite_out,
	output MemWrite_out,
	output MemRead_out,
	output MemToReg_out,
	output [1:0] load_mode_out,
	output [4:0] writebackDestination_out,
	output [31:0] aluResult_out,
	output [31:0] rt_out,
	output [31:0] pc_out
);

// delay variables
reg RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg;
reg [1:0] load_mode;
reg [2:0] ALUOp;
reg [4:0] instr_bits_15_11, instr_bits_20_16;
reg [31:0] extended_bits, read_data1, read_data2, new_pc_value;

// stage delays
always @(in_RegDst) #5 RegDst = in_RegDst;
always @(in_MemWrite) #5 MemWrite = in_MemWrite;
always @(in_MemRead) #5 MemRead = in_MemRead;
always @(in_RegWrite) #5 RegWrite = in_RegWrite;
always @(in_ALUSrc) #5 ALUSrc = in_ALUSrc;
always @(in_MemToReg) #5 MemToReg =in_MemToReg;
always @(in_load_mode) #5 load_mode = in_load_mode;
always @(in_ALUOp) #5 ALUOp = in_ALUOp;
always @(in_instr_bits_15_11) #5 instr_bits_15_11 =in_instr_bits_15_11;
always @(in_instr_bits_20_16) #5 instr_bits_20_16 =in_instr_bits_20_16;
always @(in_extended_bits) #5 extended_bits = in_extended_bits;
always @(in_read_data1) #5 read_data1 = in_read_data1;
always @(in_read_data2) #5 read_data2 = in_read_data2;
always @(in_new_pc_value) #5 new_pc_value = in_new_pc_value;

// multiplexer before ALU
reg [31:0] second_alu_input;
always @(read_data2, extended_bits, ALUSrc)
begin
	if(ALUSrc)
		second_alu_input <= extended_bits;
	else
		second_alu_input <= read_data2;
end

// ALU Control
wire [3:0] aluControlInput;
ALU_Control alu_control(ALUOp, extended_bits[5:0], aluControlInput);

// ALU
wire zero;
wire [31:0] aluResult;
ALU alu (read_data1, second_alu_input, aluControlInput, aluResult, extended_bits[10:6], zero);

// PC calculation unit
wire [31:0] PC;
EX_PC_Calculation pc_calculator(new_pc_value, extended_bits, PC);

// multiplexer for write_back_destination
reg [4:0] write_back_destination;
always @(instr_bits_15_11, instr_bits_20_16, RegDst)
begin
	if(RegDst)
		write_back_destination <= instr_bits_15_11;
	else
		write_back_destination <= instr_bits_20_16;
end

// pipelining register
EX_MEM_Reg pipelining_register(clk, RegWrite, MemWrite, MemRead, MemToReg, PC, 
	zero, aluResult, read_data2, write_back_destination, load_mode,
	RegWrite_out, MemWrite_out, MemRead_out, MemToReg_out, pc_out,
	zero_out, aluResult_out, rt_out, writebackDestination_out, load_mode_out);

endmodule
