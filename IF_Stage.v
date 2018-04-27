module IF_Stage(
  input CLK,                            // CLOCK
  input [31:0] MUX_OPT_0,               // MUX OPTION 0
  input [31:0] MUX_OPT_1,               // MUX OPTION 1
  input PC_SRC,                      // MUX CONTROL SIGNAL
  output [31:0] NEXT_INS_ADR_OUT,       // NEXT INSTRUCTION ADDRESS OUTPUT
  output [31:0] CUR_INS_OUT             // CURRENT INSTRUCTION OUTPUT
);

wire [31:0] NEXT_INS_ADR, CUR_INS;
reg [31:0] MUX_OPT_0_DELAYED, MUX_OPT_1_DELAYED;
reg PC_SRC_DELAYED;

always @(MUX_OPT_0) #5 MUX_OPT_0_DELAYED = MUX_OPT_0;
always @(MUX_OPT_1) #5 MUX_OPT_1_DELAYED = MUX_OPT_0;
always @(PC_SRC) #5 PC_SRC_DELAYED = PC_SRC;

IF_Sel IF_Sel_Module(
  CLK,
  MUX_OPT_0_DELAYED,
  MUX_OPT_1_DELAYED,
  PC_SRC_DELAYED,
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
