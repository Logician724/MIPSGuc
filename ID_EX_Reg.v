module ID_EX_Reg(input clk, 
                 input [4:0] in_instr_bits_15_11,
                 input [4:0] in_instr_bits_20_16,
                 input [31:0] in_extended_bits,
                 input [31:0] in_read_data1,
                 input [31:0] in_read_data2,
                 input [31:0] in_new_pc_value,
                 input in_RegDst, in_RegWrite, in_ALUSrc, in_MemWrite, in_MemRead, in_MemToReg, in_Branch,
                 input [1:0] in_load_mode,
                 input [2:0] in_ALUOp,
                 output reg [4:0] instr_bits_15_11,
                 output reg [4:0] instr_bits_20_16,
                 output reg [31:0] extended_bits,
                 output reg [31:0] read_data1,
                 output reg [31:0] read_data2,
                 output reg [31:0] new_pc_value,
                 output reg RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Branch,
                 output reg [1:0] load_mode,
                 output reg [2:0] ALUOp);

always @(posedge clk)
begin
  instr_bits_15_11 <= #10 in_instr_bits_15_11;
  instr_bits_20_16 <= #10 in_instr_bits_20_16;
  extended_bits <= #10 in_extended_bits;
  read_data1 <= #10 in_read_data1;
  read_data2 <= #10 in_read_data2;
  new_pc_value <= #10 in_new_pc_value;
  RegDst <= #10 in_RegDst;
  RegWrite <= #10 in_RegWrite;
  ALUSrc <= #10 in_ALUSrc;
  ALUOp <= #10 in_ALUOp;
  MemWrite <= #10 in_MemWrite;
  MemRead <= #10 in_MemRead;
  MemToReg <= #10 in_MemToReg;
  load_mode <= #10 in_load_mode;
  Branch <= #10 in_Branch;
end

endmodule
