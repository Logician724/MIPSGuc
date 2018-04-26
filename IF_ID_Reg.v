module IF_ID_Reg(
    input CLK,                          // CLOCK
    input [31:0] NEXT_INS_ADR_IN,       // NEXT INSTRUCTION ADDRESS INPUT
    input [31:0] CUR_INS_IN,            // CURRENT INSTRUCTION INPUT
    output reg [31:0] NEXT_INS_ADR_OUT, // NEXT INSTRUCTION ADDRESS OUTPUT
    output reg [31:0] CUR_INS_OUT       // CURRENT INSTRUCTION OUTPUT
);

always @(posedge CLK)
begin
  NEXT_INS_ADR_OUT <= NEXT_INS_ADR_IN;
  CUR_INS_OUT <= CUR_INS_IN;
end

endmodule