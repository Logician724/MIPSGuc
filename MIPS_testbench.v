module MIPS_testbench();

// the clock
reg CLK;
integer cycle_counter;

// instantiate the mips processor
MIPS mips(CLK);

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
$monitor("Cycle %d\n", cycle_counter,
//IF Stage Output
"IF/ID Stage Register:\n",
"PC+4=%d,", MIPS_testbench.mips.IF_ID_NEXT_INS_ADR,
"Instruction=%b\n", MIPS_testbench.mips.IF_ID_CUR_INS,
"ID/EX Stage Register:\n"
);
end

// stop after 1000ps
initial
begin
	#10000 $stop;
end


endmodule
