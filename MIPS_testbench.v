module MIPS_testbench();

// the clock
reg CLK;
integer cycle_counter;

// get the clock working
initial 
begin
	cycle_counter = 0;
	CLK = 0;
	forever 
	begin
		#100 CLK = ~CLK;
	end
end

// incrememnt cycle counter at each positive edge
always @(posedge CLK) cycle_counter = cycle_counter + 1;

// instantiate the mips processor
MIPS mips(CLK);

// monitor the cycle counter
initial
begin
$monitor("Cycle %d %d", cycle_counter, MIPS_testbench.mips.EX_MEM_aluResult_out);
end

// stop after 1000ps
initial
begin
	#10000 $stop;
end


endmodule
