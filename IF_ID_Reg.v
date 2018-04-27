module IF_ID_Reg(
	input clk,
	input [31:0] in_instruction,
	input [31:0] in_pc_plus_four,
	output reg [31:0] instruction_out,
	output reg [31:0] pc_plus_four_out
);

always @(posedge clk)
begin
	instruction_out <= #10 in_instruction;
	pc_plus_four_out <= #10 in_pc_plus_four;
end

endmodule
