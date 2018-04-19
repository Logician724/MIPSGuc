module ID_EX_Reg(input clk, 
                 input [4:0] in_instr_bits_15_11,
                 input [4:0] in_instr_bits_20_16,
                 input [31:0] in_extended_bits,
                 input [31:0] in_read_data1,
                 input [31:0] in_read_data2,
                 input [31:0] in_new_pc_value,
                 input in_RegDst, in_RegWrite, in_ALUSrc, in_MemWrite, in_MemRead, in_MemToReg, in_PCSrc,
                 input [2:0] in_ALUOp,
                 output reg [4:0] instr_bits_15_11,
                 output reg [4:0] instr_bits_20_16,
                 output reg [31:0] extended_bits,
                 output reg [31:0] read_data1,
                 output reg [31:0] read_data2,
                 output reg [31:0] new_pc_value,
                 output reg RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, PCSrc,
                 output reg [2:0] ALUOp);

always @(posedge clk)
begin
  instr_bits_15_11 <= in_instr_bits_15_11;
  instr_bits_20_16 <= in_instr_bits_20_16;
  extended_bits <= in_extended_bits;
  read_data1 <= in_read_data1;
  read_data2 <= in_read_data2;
  new_pc_value <= in_new_pc_value;
  RegDst <= in_RegDst;
  RegWrite <= in_RegWrite;
  ALUSrc <= in_ALUSrc;
  ALUOp <= in_ALUOp;
  MemWrite <= in_MemWrite;
  MemRead <= in_MemRead;
  MemToReg <= in_MemToReg;
  PCSrc <= in_PCSrc;
end
endmodule
