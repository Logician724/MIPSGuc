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

endmodule