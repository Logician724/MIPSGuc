module MIPS(
    input CLK
);

// --- IF Stage Wires --- //
wire [31:0] IF_ID_NEXT_INS_ADR;
wire [31:0] IF_ID_CUR_INS;
// --- IF Stage Wires --- //

// --- ID Stage Wires --- //
wire [31:0] register_input;
wire [4:0] ID_EX_instr_bits_15_11;
wire [4:0] ID_EX_instr_bits_20_16;
wire [31:0] ID_EX_extended_bits;
wire [31:0] ID_EX_read_data1;
wire [31:0] ID_EX_read_data2;
wire [31:0] ID_EX_new_pc_value;
wire ID_EX_RegDst;
wire ID_EX_RegWrite;
wire ID_EX_ALUSrc;
wire ID_EX_MemWrite;
wire ID_EX_MemRead;
wire ID_EX_MemToReg;
wire ID_EX_Branch;
wire [1:0] ID_EX_load_mode;
wire [2:0] ID_EX_ALUOp;
// --- ID Stage Wires --- //

// --- EX Stage Wires --- //
wire EX_MEM_zero_out;
wire EX_MEM_RegWrite_out;
wire EX_MEM_MemWrite_out;
wire EX_MEM_MemRead_out;
wire EX_MEM_MemToReg_out;
wire [1:0] EX_MEM_load_mode_out;
wire [4:0] EX_MEM_writebackDestination_out;
wire [31:0] EX_MEM_aluResult_out;
wire [31:0] EX_MEM_rt_out;
wire [31:0] EX_MEM_pc_out;
wire [31:0] EX_IF_pc_out;
wire EX_MEM_branch_out;
// --- EX Stage Wires --- //

// --- MEM Stage Wires --- //
wire MEM_IF_pc_src;
wire [31:0] MEM_WB_read_data;
wire MEM_WB_mem_to_reg;
wire MEM_WB_reg_write_out;
wire [31:0] MEM_WB_address_out;
wire [4:0] MEM_WB_write_back_destination_out;
// --- MEM Stage Wires --- //

// --- WB Stage Wires --- //
wire [31:0] WB_ID_wb_out;
wire WB_ID_reg_write_out;
wire [4:0] WB_ID_write_back_destination_out;
// --- WB Stage Wires --- //

// --- IF Stage --- //
IF_Stage IF_Stage_Module(
    CLK,
    IF_ID_NEXT_INS_ADR,
    EX_IF_pc_out,
    MEM_IF_pc_src,
    IF_ID_NEXT_INS_ADR,
    IF_ID_CUR_INS
);
// --- IF Stage --- //

// --- ID Stage --- //
ID_Stage ID_Stage_Module(
    CLK,
    WB_ID_write_back_destination_out,
    WB_ID_wb_out,
    WB_ID_reg_write_out,
    IF_ID_CUR_INS,
    IF_ID_NEXT_INS_ADR,
    register_input,
    ID_EX_instr_bits_15_11,
    ID_EX_instr_bits_20_16,
    ID_EX_extended_bits,
    ID_EX_read_data1,
    ID_EX_read_data2,
    ID_EX_new_pc_value,
    ID_EX_RegDst,
    ID_EX_RegWrite,
    ID_EX_ALUSrc,
    ID_EX_MemWrite,
    ID_EX_MemRead,
    ID_EX_MemToReg,
    ID_EX_Branch,
    ID_EX_load_mode,
    ID_EX_ALUOp
);
// --- ID Stage --- //

// --- EX Stage --- //
EX_Stage EX_Stage_Module(
    CLK,
    ID_EX_RegDst,
    ID_EX_RegWrite,
    ID_EX_ALUSrc,
    ID_EX_MemWrite,
    ID_EX_MemRead,
    ID_EX_MemToReg,
    ID_EX_ALUOp,
    ID_EX_instr_bits_15_11,
    ID_EX_instr_bits_20_16,
    ID_EX_extended_bits,
    ID_EX_read_data1,
    ID_EX_read_data2,
    ID_EX_new_pc_value,
    ID_EX_load_mode,
    ID_EX_Branch,
    EX_MEM_zero_out,
    EX_MEM_RegWrite_out,
    EX_MEM_MemWrite_out,
    EX_MEM_MemRead_out,
    EX_MEM_MemToReg_out,
    EX_MEM_load_mode_out,
    EX_MEM_writebackDestination_out,
    EX_MEM_aluResult_out,
    EX_MEM_rt_out,
    EX_IF_pc_out,
    EX_MEM_branch_out
);
// --- EX Stage --- //

// --- MEM Stage --- //
MEM_Stage MEM_Stage_Module(
    CLK,
    EX_MEM_MemToReg_out,
    EX_MEM_aluResult_out,
    EX_MEM_rt_out,
    EX_MEM_MemWrite_out,
    EX_MEM_RegWrite_out,
    EX_MEM_MemRead_out,
    EX_MEM_load_mode_out,
    EX_MEM_zero_out,
    EX_MEM_branch_out,
    EX_MEM_writebackDestination_out,
    MEM_IF_pc_src,
    MEM_WB_read_data,
    MEM_WB_mem_to_reg,
    MEM_WB_reg_write_out,
    MEM_WB_address_out,
    MEM_WB_write_back_destination_out
);
// --- MEM Stage --- //

// --- WB Stage --- //
WB_Stage WB_Stage_Module(
    MEM_WB_mem_to_reg,
    MEM_WB_reg_write_out,
    MEM_WB_write_back_destination_out,
    MEM_WB_address_out,
    MEM_WB_read_data,
    WB_ID_wb_out,
    WB_ID_reg_write_out,
    WB_ID_write_back_destination_out
);
// --- WB Stage --- //

endmodule
