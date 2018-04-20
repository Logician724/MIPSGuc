module (
    input CLK,                      // CLOCK
    input [31:0] NEXT_INS,          // NEXT INSTRUCTION
    input [31:0] CUR_INS,           // CURRENT INSTRUCTION
    output reg [31:0] NEXT_INS_OUT, // NEXT INSTRUCTION OUTPUT
    output reg [31:0] CUR_INS_OUT   // CURRENT INSTRUCTION OUTPUT
);

always @(posedge CLK)
begin
  NEXT_INS_OUT <= NEXT_INS;
  CUR_INS_OUT <= CUR_INS;
end

endmodule