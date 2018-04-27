module IF_Sel(
  input CLK,				// the clock
  input [31:0] MUX_OPT_0,               // MUX OPTION 0
  input [31:0] MUX_OPT_1,               // MUX OPTION 1
  input PC_SRC,                      // MUX CONTROL SIGNAL
  output reg [31:0] NEXT_INS_ADR,       // PC + 4
  output reg [31:0] CUR_INS             // CURRENT INSTRUCTION
);

reg [31:0] INS_MEM [0:4000]; //adjusted due to constraints by modelsim
reg [31:0] PC; // the PC register

initial
begin
PC = 0;
INS_MEM[0] = 32'b001000_00000_01001_0000000000000010;
end

always @(posedge CLK)
begin
	PC <= (PC_SRC) ? MUX_OPT_1 : MUX_OPT_0;
	NEXT_INS_ADR <= PC + 4;
	CUR_INS <= INS_MEM[PC];
end

endmodule
