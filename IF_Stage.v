module IF_Stage(
input clk,
input in_PCSrc,
input [31:0] in_branch_address,
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
instruction_memory[1] = 32'b000000_00000_01001_00001_00000_000000;
instruction_memory[2] = 32'b001000_00000_01000_0000000000000100;
instruction_memory[3] = 32'b000000_00000_00000_0000000000000000;
end

assign pc_plus_four_out = PC + 4;
assign instruction_out = instruction_memory[PC/4];

always @(posedge clk)
	begin
		PC <= (in_PCSrc === 1)? in_branch_address : pc_plus_four_out;
	end

endmodule
