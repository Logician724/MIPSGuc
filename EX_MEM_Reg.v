module EX_MEM_Reg (
input clk,
input RegWrite_in, 
input MemWrite_in, 
input MemRead_in, 
input MemToReg_in, 
input [31:0] pc_in, 
input zero_in, 
input [31:0] aluResult_in, 
input [31:0] rt_in, 
input [4:0] writebackDestination_in,
input [1:0] load_mode_in,
input branch_in,
output reg RegWrite_out,
output reg MemWrite_out,
output reg MemRead_out,
output reg MemToReg_out,
output reg [31:0] pc_out,
output reg zero_out,
output reg [31:0] aluResult_out,
output reg [31:0] rt_out,
output reg [4:0] writebackDestination_out,
output reg [1:0] load_mode_out,
output reg branch_out);

always @(posedge clk)
begin
	zero_out <= #10 zero_in;
	writebackDestination_out <= #10 writebackDestination_in;
	aluResult_out <= #10 aluResult_in;
	rt_out <= #10 rt_in;
	pc_out <= #10 pc_in;
	
	// control signals passed from decode stage to mem stage
	RegWrite_out <= #10 RegWrite_in;
	MemWrite_out <= #10 MemWrite_in;
	MemRead_out <= #10 MemRead_in;
	MemToReg_out <= #10 MemToReg_in;
	load_mode_out <= #10 load_mode_in;
	branch_out <= #10 branch_in;

end

endmodule
