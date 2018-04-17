// extended_bits refer to the ouput of the extender
module ID_Register_File(instruction, write_data, write_register, RegWrite, read_data1, read_data2, extended_bits);

input [31:0] instruction;
input [31:0] write_data;
input [31:0] write_register;
input RegWrite;
output reg [31:0] read_data1;
output reg [31:0] read_data2;
output reg [31:0] extended_bits;

reg [31:0] registers [31:0];

// QUESTION: is this sufficient as an always list
always @(instruction or RegWrite or write_data or write_register)
begin
  read_data1 <= registers[instruction[25:21]];
  read_data2 <= registers[instruction[20:16]];
  extended_bits <= 16'b0 + instruction[15:0];
  if(RegWrite) begin
    registers[write_register] = write_data;
  end
end

endmodule