module MIPS(
    input CLK
);

// --- IF Stage --- //
wire [31:0] MUX_OPT_0
wire [31:0] MUX_OPT_1;
wire MEM_WRITE;
wire [31:0] NEXT_INS_ADR_OUT;
wire [31:0] CUR_INS_OUT;

IF_Stage IF_Stage_Module(
    CLK,
    MUX_OPT_0,
    MUX_OPT_1,
    MEM_WRITE,
    NEXT_INS_ADR_OUT,
    CUR_INS_OUT
);
// --- IF Stage --- //

// --- ID Stage --- //
wire [5:0] delay_write_register;
wire [31:0] delay_write_data;
wire delay_in_RegWrite;
wire [1:0] delay_in_load_mode;
wire [31:0] register_input;
wire [4:0] instr_bits_15_11;
wire [4:0] instr_bits_20_16;
wire [31:0] extended_bits;
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] new_pc_value;
wire RegDst;
wire RegWrite;
wire ALUSrc;
wire MemWrite;
wire MemRead;
wire MemToReg;
wire Branch;
wire [1:0] load_mode;
wire [2:0] ALUOp;

ID_Stage ID_Stage_Module(
    CLK,
    delay_write_register,
    delay_write_data,
    delay_in_RegWrite,
    delay_in_load_mode,
    CUR_INS_OUT,
    NEXT_INS_ADR_OUT,
    register_input,
    instr_bits_15_11,
    instr_bits_20_16,
    extended_bits,
    read_data1,
    read_data2,
    new_pc_value,
    RegDst,
    RegWrite,
    ALUSrc,
    MemWrite,
    MemRead,
    MemToReg,
    Branch,
    load_mode,
    ALUOp
);
// --- ID Stage --- //

endmodule