module MIPS(
    input clk
);

// --- IF Wires --- //
wire IF_PCSrc;
wire [31:0] IF_branch_address, instruction_IF, pc_plus_four_IF;
// --- END IF Wires --- //

// --- ID Wires --- //
wire [4:0] ID_write_register;
wire [31:0] ID_write_data;
wire ID_RegWrite;
wire [4:0] instr_bits_15_11_ID;
wire [4:0] instr_bits_20_16_ID;
wire [31:0] extended_bits_ID;
wire [31:0] read_data1_ID;
wire [31:0] read_data2_ID;
wire [31:0] new_pc_value_ID;
wire RegDst_ID;
wire RegWrite_ID;
wire ALUSrc_ID;
wire MemWrite_ID;
wire MemRead_ID;
wire MemToReg_ID;
wire Branch_ID;
wire [1:0] load_mode_ID;
wire [2:0] ALUOp_ID;
// --- END ID Wires --- //

// --- IF Stage --- //
IF_Stage IF_Stage_Module(
clk,
IF_PCSrc,
IF_branch_address,
instruction_IF,
pc_plus_four_IF
);
// --- END IF Stage --- //

// --- IF/ID Pipeline Register --- //
IF_ID_Reg IF_ID_Pipeline_Register(
	clk,
	instruction_IF,
	pc_plus_four_IF,
	ID_instruction,
	ID_new_pc_value
);
// --- END IF/ID Pipeline Register --- //

// --- ID Stage --- //
ID_Stage ID_Stage_Module(
	clk,
	ID_write_register,
	ID_write_data,
	ID_RegWrite,
	ID_instruction,
	ID_new_pc_value,
	instr_bits_15_11_ID,
	instr_bits_20_16_ID,
	extended_bits_ID,
	read_data1_ID,
	read_data2_ID,
	new_pc_value_ID,
	RegDst_ID,
	RegWrite_ID,
	ALUSrc_ID,
	MemWrite_ID,
	MemRead_ID,
	MemToReg_ID,
	Branch_ID,
	load_mode_ID,
	ALUOp_ID
);
// --- END ID Stage -- //

endmodule
