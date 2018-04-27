module ID_Control_Unit(OP_CODE, 
                       // Outputs
                       RegDst, 
                       RegWrite,
                       ALUSrc,
                       ALUOp,
                       MemWrite,
                       MemRead,
                       MemToReg,
                       Branch,
                       load_mode);

input [5:0] OP_CODE;
output reg RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Branch;
output reg [1:0] load_mode;
output reg [2:0] ALUOp;


always @(OP_CODE)
begin
  // Default most common values
  RegWrite <= 1;
  ALUSrc <= 0;
  MemWrite <= 0;
  MemRead <= 0;
  MemToReg <= 0;
  load_mode <= 2'b00;
  Branch <= 0;

  case(OP_CODE)
    // R-Type
    6'b000_000:
        begin
          RegDst <= 1;
          ALUOp <= 3'b100;
        end
    // ADD-Immediate
    6'b001_000:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b000;
        end
    // LW, LH, LHU
    6'b100_111:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b000;
          MemRead <= 1;
          MemToReg <= 1;
        end
    6'b100_001:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b000;
          MemRead <= 1;
          MemToReg <= 1;
          load_mode <= 2'b01;
        end
    6'b100_101:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b000;
          MemRead <= 1;
          MemToReg <= 1;
          load_mode <= 2'b10;
        end
    // SW
    6'b101_011:
        begin
          RegWrite <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b000;
          MemWrite <= 1;
        end
    // BEQ
    6'b000_100:
        begin
          RegWrite <= 0;
          ALUOp <= 3'b001;
          Branch <= 1;
        end
    // AND-immediate
    6'b001_100:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b011;
        end
    // OR-immediate
    6'b001_101:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b010;
        end
    default:
        begin
          RegDst <= 0;
          RegWrite <= 0;
          ALUOp <= 3'b000;
        end
    endcase
end

endmodule
