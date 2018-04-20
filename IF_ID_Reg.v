module (
    input CLK,                      // CLOCK
    input [31:0] NEXT_INS_IN,       // NEXT INSTRUCTION INPUT
    input [31:0] CUR_INS_IN,        // CURRENT INSTRUCTION INPUT
    output reg [31:0] NEXT_INS_OUT, // NEXT INSTRUCTION OUTPUT
    output reg [31:0] CUR_INS_OUT   // CURRENT INSTRUCTION OUTPUT
);

always @(posedge CLK)
begin
  NEXT_INS_OUT <= NEXT_INS;
  CUR_INS_OUT <= CUR_INS;
end

endmodule