module IF_Stage(
  input CLK,                            // CLOCK
  input [31:0] MUX_OPT_0,               // MUX OPTION 0
  input [31:0] MUX_OPT_1,               // MUX OPTION 1
  input MEM_WRITE,                      // MUX CONTROL SIGNAL
  input [31:0] INS_MEM [0:16777215],    // INSTRUCTION MEMORY
  output [31:0] NEXT_INS_ADR_OUT,       // NEXT INSTRUCTION ADDRESS OUTPUT
  output [31:0] CUR_INS_OUT             // CURRENT INSTRUCTION OUTPUT
);

wire [31:0] NEXT_INS_ADR, CUR_INS;

IF_Sel IF_Sel_Module(
  MUX_OPT_0,
  MUX_OPT_1,
  MEM_WRITE,
  INS_MEM,
  NEXT_INS_ADR,
  CUR_INS
);

IF_ID_Reg IF_ID_Reg_Module(
  CLK,
  NEXT_INS_ADR,
  CUR_INS,
  NEXT_INS_ADR_OUT,
  CUR_INS_OUT
);

endmodule