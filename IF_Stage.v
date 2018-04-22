module (
  input [31:0] MUX_OPT_0,           // MUX OPTION 0
  input [31:0] MUX_OPT_1,           // MUX OPTION 1
  input MEM_WRITE,                  // MUX CONTROL SIGNAL
  input [31:0] INST_MEM [50000:0],  // INSTRUCTION MEMORY
  output reg [31:0] NEXT_INST_ADR,  // PC + 4
  output reg [31:0] CUR_INST        // CURRENT INSTRUCTION
);

always @(MUX_OPT_0, MUX_OPT_1, MEM_WRITE, INST_MEM)
begin
    NEXT_INST_ADR <= (MEM_WRITE) ? MUX_OPT_1 + 4 : MUX_OPT_0 + 4;
    CUR_INST <= (MEM_WRITE) ? INST_MEM[MUX_OPT_1] : INST_MEM[MUX_OPT_0];
end

endmodule