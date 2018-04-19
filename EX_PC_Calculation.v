module EX_PC_Calculation(PC_in, offset, PC_out);

input [31:0] PC_in;
input [31:0] offset;

output [31:0] PC_out;


assign PC_out = PC_in + (offset << 2);

endmodule
