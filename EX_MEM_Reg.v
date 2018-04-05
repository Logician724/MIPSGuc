module EX_MEM_Reg (clk, WB_in, M_in, pc_in, zero_in, aluResult_in, rt_in, writebackDestination_in,
	WB_out, M_out, pc_out, zero_out, aluResult_out, rt_out, writebackDestination_out);

input clk, zero_in;
input [4:0] writebackDestination_in;
input [31:0] aluResult_in, rt_in, pc_in;
// TODO define what WB_in and M_in are and how many bits they take
input WB_in, M_in;

output reg zero_out;
output reg [4:0] writebackDestination_out;
output reg [31:0] aluResult_out, rt_out, pc_out;
// TODO define what WB_out and M_out are and how many bits they take
output reg WB_out, M_out;

always @(posedge clk)
begin
	zero_out <= zero_in;
	writebackDestination_out <= writebackDestination_in;
	aluResult_out <= aluResult_in;
	rt_out <= rt_in;
	pc_out <= pc_in;
	
	// TODO define what WB_out and M_out are and how many bits they take
	WB_out <= WB_in;
	M_out <= M_in;
end

endmodule
