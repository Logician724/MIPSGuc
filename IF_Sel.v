module IF_Sel(
  input [31:0] MUX_OPT_0,               // MUX OPTION 0
  input [31:0] MUX_OPT_1,               // MUX OPTION 1
  input PC_SRC,                      // MUX CONTROL SIGNAL
  output reg [31:0] NEXT_INS_ADR,       // PC + 4
  output reg [31:0] CUR_INS             // CURRENT INSTRUCTION
);

reg [31:0] INS_MEM [0:200000000]; //adjusted due to constraints by modelsim

always @(MUX_OPT_0, MUX_OPT_1, PC_SRC)
begin
    NEXT_INS_ADR <= (PC_SRC) ? MUX_OPT_1 + 4 : MUX_OPT_0 + 4;
    CUR_INS <= (PC_SRC) ? INS_MEM[MUX_OPT_1] : INS_MEM[MUX_OPT_0];
end

endmodule