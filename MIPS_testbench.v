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

// monitor the cycle counter
initial
begin
$monitor("Cycle %d ", cycle_counter);
end

// instantiate the mips processor
MIPS mips(CLK);

// stop after 1000ps
initial
begin
	#1000 $stop;
end


endmodule
