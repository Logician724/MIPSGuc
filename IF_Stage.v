module (
  input [31:0] MUX_OPT_0,       // MUX OPTION 0
  input [31:0] MUX_OPT_1,       // MUX OPTION 1
  input MEM_WRITE,              // MUX CONTROL SIGNAL
  output reg [31:0] NEXT_INST,  // PC + 4
  output reg [31:0] CUR_INS     // PC
);

always @(MUX_OPT_0, MUX_OPT_1, MEM_WRITE)
begin
    NEXT_INST <= (MEM_WRITE) ? MUX_OPT_1 + 4 : MUX_OPT_0 + 4;
    CUR_INS <= (MEM_WRITE) ? MUX_OPT_1 : MUX_OPT_0;
end

endmodule