module EX_MEM_Reg (clk, RegWrite_in, MemWrite_in, MemRead_in, MemToReg_in, pc_in, 
	zero_in, aluResult_in, rt_in, writebackDestination_in, load_mode_in, branch_in,
	RegWrite_out, MemWrite_out, MemRead_out, MemToReg_out, pc_out,
	zero_out, aluResult_out, rt_out, writebackDestination_out, load_mode_out, branch_out);

input clk, zero_in, RegWrite_in, MemWrite_in, MemRead_in, MemToReg_in, branch_in;
input [1:0] load_mode_in;
input [4:0] writebackDestination_in;
input [31:0] aluResult_in, rt_in, pc_in;

output reg zero_out, RegWrite_out, MemWrite_out, MemRead_out, MemToReg_out, branch_out;
output reg [1:0] load_mode_out;
output reg [4:0] writebackDestination_out;
output reg [31:0] aluResult_out, rt_out, pc_out;

always @(posedge clk)
begin
	zero_out <= zero_in;
	writebackDestination_out <= writebackDestination_in;
	aluResult_out <= aluResult_in;
	rt_out <= rt_in;
	pc_out <= pc_in;
	
	// control signals passed from decode stage to mem stage
	RegWrite_out <= RegWrite_in;
	MemWrite_out <= MemWrite_in;
	MemRead_out <= MemRead_in;
	MemToReg_out <= MemToReg_in;
	load_mode_out <= load_mode_in;
	branch_out <= branch_in;

end

endmodule
