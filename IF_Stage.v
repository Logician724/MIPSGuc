module IF_Stage(
input clk,
input in_PCSrc,
input in_branch_address,
output [31:0] instruction_out,
output [31:0] pc_plus_four_out
);

reg [31:0] PC = 0;
reg [31:0] instruction_memory [0:4000]; //adjusted due to constraints by modelsim

integer i = 0;
initial
begin
for(i = 0; i < 4000; i = i + 1)
	instruction_memory[i] = 31'b0;
	
instruction_memory[0] = 32'b001000_00000_01001_0000000000000010;
end

assign pc_plus_four_out = PC + 4;
assign instruction_out = instruction_memory[PC];

always @(posedge clk)
	begin
		PC <= (in_PCSrc)? in_branch_address : pc_plus_four_out;
	end

endmodule
