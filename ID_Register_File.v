// extended_bits refer to the ouput of the extender
module ID_Register_File(// Input
                        clk, 
                        instruction, 
                        write_data, 
                        write_register, 
                        RegWrite,
                        load_mode,
                        registers_input,
                        // Output
                        read_data1, 
                        read_data2, 
                        extended_bits);

// INPUT 
input clk;
input [31:0] instruction;
input [31:0] write_data;
input [5:0] write_register;
input [1:0] load_mode;
input RegWrite;
input [31:0] registers_input;

// OUTPUT
output reg [31:0] read_data1;
output reg [31:0] read_data2;
output reg [31:0] extended_bits;

reg [31:0] registers [31:0];


integer i;
initial
begin
  for(i = 0; i < 32; i = i + 1)
    registers[i] = 32'b0;
  registers[29] = 32'd2147483648;
end

always @(*)
begin
  read_data1 <= registers[instruction[25:21]];
  read_data2 <= registers[instruction[20:16]];
  extended_bits <= instruction[15] ? 16'hffff + instruction[15:0] : 16'b0 + instruction[15:0];
end

always @(posedge clk)
begin
  if(RegWrite && write_register != 5'b00_000) begin
    case(load_mode)
      // Normal load
      2'b00 : registers[write_register] = write_data;
      // Load halfword
      2'b10 : registers[write_register] = write_data[15] ? 16'd0 + write_data[15:0] : 16'd0 + write_data[15:0];
      // Load halfword unsigned
      2'b01 : registers[write_register] = 16'd0 + write_data[15:0];
    endcase
  end
end

endmodule