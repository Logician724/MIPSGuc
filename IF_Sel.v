module IF_Sel(
  input [31:0] MUX_OPT_0,               // MUX OPTION 0
  input [31:0] MUX_OPT_1,               // MUX OPTION 1
  input MEM_WRITE,                      // MUX CONTROL SIGNAL
  input [31:0] INS_MEM [0:16777215],    // INSTRUCTION MEMORY
  output reg [31:0] NEXT_INS_ADR,       // PC + 4
  output reg [31:0] CUR_INS             // CURRENT INSTRUCTION
);

always @(MUX_OPT_0, MUX_OPT_1, MEM_WRITE)
begin
    NEXT_INS_ADR <= (MEM_WRITE) ? MUX_OPT_1 + 4 : MUX_OPT_0 + 4;
    CUR_INS <= (MEM_WRITE) ? INS_MEM[MUX_OPT_1] : INS_MEM[MUX_OPT_0];
end

endmodule