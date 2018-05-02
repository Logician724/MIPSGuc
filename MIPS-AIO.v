module ALU_Control(aluOp, funct, aluControlInput);

// TODO finalize the codes used for aluOp
input [2:0] aluOp;
input [5:0] funct;

output reg [3:0] aluControlInput;

always @(aluOp, funct)
begin
	// R-type
	if(aluOp == 3'b100)
		begin
			case(funct)
				6'b100000: aluControlInput <= 4'b0010; // add
				6'b100010: aluControlInput <= 4'b0110; // sub
				6'b100100: aluControlInput <= 4'b0000; // and
				6'b100101: aluControlInput <= 4'b0001; // or
				6'b000000: aluControlInput <= 4'b0011; // sll
				6'b000010: aluControlInput <= 4'b0100; // srl
				6'b101010: aluControlInput <= 4'b0111; // slt
				6'b101011: aluControlInput <= 4'b1011; // sltu
			endcase
		end
	// non-R-type
	else
		begin
			case(aluOp)
				3'b000: aluControlInput <= 4'b0010; // sw, lw, addi, lhu, lh
				3'b001: aluControlInput <= 4'b0110; // beq
				3'b010: aluControlInput <= 4'b0001; // ori
				3'b011: aluControlInput <= 4'b0000; // andi
			endcase
		end
end

endmodule

module ALU(firstOperand, secondOperand, aluControlInput, shamt, aluResult, zero);

input signed [31:0] firstOperand, secondOperand;
input [4:0] shamt;
input [3:0] aluControlInput;

output zero;
output reg [31:0] aluResult;

assign zero = (firstOperand === secondOperand);

always @(firstOperand, secondOperand, aluControlInput, shamt)
begin
	case(aluControlInput)
		4'b0000: aluResult <= firstOperand & secondOperand; // and
		4'b0001: aluResult <= firstOperand | secondOperand; // or
		4'b0010: aluResult <= firstOperand + secondOperand; // add
		4'b0011: aluResult <= secondOperand << shamt; // sll
		4'b0100: aluResult <= secondOperand >> shamt; // srl
		4'b0110: aluResult <= firstOperand - secondOperand; // sub
		4'b0111: aluResult <= firstOperand < secondOperand; // slt
		4'b1011: aluResult <= $unsigned(firstOperand) < $unsigned(secondOperand); // sltu
		default: aluResult <= 0; // undefined operation
	endcase
end

endmodule

module EX_MEM_Reg (
input clk,
input RegWrite_in, 
input MemWrite_in, 
input MemRead_in, 
input MemToReg_in, 
input [31:0] pc_in, 
input zero_in, 
input [31:0] aluResult_in, 
input [31:0] rt_in, 
input [4:0] writebackDestination_in,
input [1:0] load_mode_in,
input branch_in,
output reg RegWrite_out,
output reg MemWrite_out,
output reg MemRead_out,
output reg MemToReg_out,
output reg [31:0] pc_out,
output reg zero_out,
output reg [31:0] aluResult_out,
output reg [31:0] rt_out,
output reg [4:0] writebackDestination_out,
output reg [1:0] load_mode_out,
output reg branch_out);

always @(posedge clk)
begin
	zero_out <= zero_in;
	writebackDestination_out <= writebackDestination_in;
	aluResult_out <= aluResult_in;
	rt_out <= rt_in;
	pc_out <= pc_in;
	
	// control signals passed from decode stage to mem stage
	RegWrite_out <= RegWrite_in;
	MemWrite_out <= MemWrite_in;
	MemRead_out <= MemRead_in;
	MemToReg_out <= MemToReg_in;
	load_mode_out <= load_mode_in;
	branch_out <= branch_in;

end

endmodule

module EX_PC_Calculation(PC_in, offset, PC_out);

input [31:0] PC_in;
input [31:0] offset;

output [31:0] PC_out;


assign PC_out = PC_in + (offset << 2);

endmodule

module EX_Stage(
	input clk,
	input in_RegDst,
	input in_RegWrite,
	input in_ALUSrc,
	input in_MemWrite,
	input in_MemRead,
	input in_MemToReg,
	input [2:0] in_ALUOp,
	input [4:0] in_instr_bits_15_11,
	input [4:0] in_instr_bits_20_16,
	input [31:0] in_extended_bits,
	input [31:0] in_read_data1,
	input [31:0] in_read_data2,
	input [31:0] in_new_pc_value,
	input [1:0] in_load_mode,
	input in_branch,
	output zero_out,
	output RegWrite_out,
	output MemWrite_out,
	output MemRead_out,
	output MemToReg_out,
	output [1:0] load_mode_out,
	output [4:0] writebackDestination_out,
	output [31:0] aluResult_out,
	output [31:0] rt_out,
	output [31:0] pc_out,
	output branch_out
);

// multiplexer before ALU
wire [31:0] second_alu_input;
assign second_alu_input = (in_ALUSrc === 1)? in_extended_bits : in_read_data2;

// passing signals on
assign RegWrite_out = in_RegWrite;
assign MemWrite_out = in_MemWrite;
assign MemRead_out = in_MemRead;
assign MemToReg_out = in_MemToReg;
assign branch_out = in_branch;
assign load_mode_out = in_load_mode;
assign rt_out = in_read_data2;

// ALU Control
wire [3:0] aluControlInput;
ALU_Control alu_control(in_ALUOp, in_extended_bits[5:0], aluControlInput);

// ALU
ALU alu (in_read_data1, second_alu_input, aluControlInput, in_extended_bits[10:6], aluResult_out, zero_out);

// PC calculation unit
EX_PC_Calculation pc_calculator(in_new_pc_value, in_extended_bits, pc_out);

// multiplexer for write_back_destination
assign writebackDestination_out = (in_RegDst === 1)? in_instr_bits_15_11 : in_instr_bits_20_16;

endmodule

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
  MemToReg <= 1;
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
    6'b100_011:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b000;
          MemRead <= 1;
          MemToReg <= 0;
        end
    6'b100_001:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b000;
          MemRead <= 1;
          MemToReg <= 0;
          load_mode <= 2'b01;
        end
    6'b100_101:
        begin
          RegDst <= 0;
          ALUSrc <= 1;
          ALUOp <= 3'b000;
          MemRead <= 1;
          MemToReg <= 0;
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
  load_mode <= in_load_mode;
  Branch <= in_Branch;
end

endmodule

// extended_bits refer to the ouput of the extender
module ID_Register_File(// Input
                        clk, 
                        instruction, 
                        write_data, 
                        write_register, 
                        RegWrite,
                        // Output
                        read_data1, 
                        read_data2, 
                        extended_bits);

// INPUT 
input clk;
input [31:0] instruction;
input [31:0] write_data;
input [4:0] write_register;
input RegWrite;

// OUTPUT
output [31:0] read_data1;
output [31:0] read_data2;
output [31:0] extended_bits;

reg [31:0] registers [31:0];


integer i;
initial
begin
  for(i = 0; i < 32; i = i + 1)
    registers[i] = 32'b0;
  registers[29] = 32'd4000;
end

assign read_data1 = registers[instruction[25:21]];
assign read_data2 = registers[instruction[20:16]];
assign extended_bits = $signed(instruction[15:0]);


always @(posedge clk)
begin
  if((RegWrite === 1) && (write_register !== 5'b0))
	begin
		registers[write_register] <= write_data;
	end
end

endmodule

module ID_Stage(
    input clk,
    input [4:0] in_write_register,
    input [31:0] in_write_data,
    input in_RegWrite,
    input [31:0] in_instruction,
    input [31:0] in_new_pc_value,
    output [4:0] instr_bits_15_11_out,
    output [4:0] instr_bits_20_16_out,
    output [31:0] extended_bits_out,
    output [31:0] read_data1_out,
    output [31:0] read_data2_out,
    output [31:0] new_pc_value_out,
    output RegDst_out,
    output RegWrite_out,
    output ALUSrc_out,
    output MemWrite_out,
    output MemRead_out,
    output MemToReg_out,
    output Branch_out,
    output [1:0] load_mode_out,
    output [2:0] ALUOp_out
);

assign instr_bits_15_11_out = in_instruction[15:11];
assign instr_bits_20_16_out = in_instruction[20:16];
assign new_pc_value_out = in_new_pc_value;

ID_Register_File Registers(// INPUT
                           clk, 
                           in_instruction, 
                           in_write_data, 
                           in_write_register, 
                           in_RegWrite,
                           // OUTPUT
                           read_data1_out, 
                           read_data2_out,
			   extended_bits_out);


ID_Control_Unit Control(// INPUT
			in_instruction[31:26],
                        // OUTPUT
                        RegDst_out, 
                        RegWrite_out,
                        ALUSrc_out,
                        ALUOp_out,
                        MemWrite_out,
                        MemRead_out,
                        MemToReg_out,
                        Branch_out,
                        load_mode_out);

endmodule

module IF_ID_Reg(
	input clk,
	input [31:0] in_instruction,
	input [31:0] in_pc_plus_four,
	output reg [31:0] instruction_out,
	output reg [31:0] pc_plus_four_out
);

always @(posedge clk)
begin
	instruction_out <= in_instruction;
	pc_plus_four_out <= in_pc_plus_four;
end

endmodule

module IF_Stage(
input clk,
input in_PCSrc,
input [31:0] in_branch_address,
output [31:0] instruction_out,
output [31:0] pc_plus_four_out
);

reg [31:0] PC = 0;
reg [31:0] instruction_memory [0:3999]; //adjusted due to constraints by modelsim

integer i = 0;
initial
begin
for(i = 0; i < 4000; i = i + 1)
	instruction_memory[i] = 31'b0;
end

assign pc_plus_four_out = PC + 4;
assign instruction_out = instruction_memory[PC/4];

always @(posedge clk)
	begin
		PC <= ((in_PCSrc === 1)? in_branch_address : pc_plus_four_out);
	end

endmodule

module MEM_Data_Memory(
    read_data,
    mem_write,
    mem_read,
    load_mode,
    address,
    write_data
);

input mem_read;
input mem_write;
input [1:0] load_mode;
input [31:0] address;
input [31:0] write_data;
output reg [31:0] read_data;
reg [7:0] ram  [0:3999]; //adjusted due to constraints by modelsim

integer i = 0;
initial
begin
 for(i = 0; i < 4000; i = i + 1)
	ram[i] <= 8'b0;
end

always@(mem_read,mem_write,address,write_data)begin
    if(mem_read === 1)begin
        case(load_mode)
        2'b00: 
            read_data <= {
            ram[address],
            ram[address + 1],
            ram[address + 2],
            ram[address + 3]
            };
        2'b01:
            read_data <= {
            {16{ram[address][7]}},
            ram[address],
            ram[address + 1]
            };
        2'b10:
        read_data <= {
            16'b0,
            ram[address],
            ram[address + 1]
            };
        default: $display("Error in MEM_Data_Memory");
        endcase
    end
        
    if(mem_write === 1)
	begin
	{
	ram[address],
        ram[address+1],
        ram[address+2],
        ram[address+3]} <= write_data;
	end
end

endmodule

module MEM_Stage(
    input clk,
    input in_mem_to_reg,
    input [31:0] in_address,
    input [31:0] in_write_data,
    input in_mem_write,
    input in_reg_write,
    input in_mem_read,
    input [1:0] in_load_mode,
    input in_zero,
    input in_branch,
    input [4:0] in_write_back_destination,
    output pc_src_out,
    output [31:0] read_data_out,
    output mem_to_reg_out,
    output reg_write_out,
    output [31:0] address_out,
    output [4:0] write_back_destination_out
);

wire [31:0] read_memory_out;

and( pc_src_out, in_zero, in_branch);

assign mem_to_reg_out = in_mem_to_reg;
assign address_out = in_address;
assign reg_write_out = in_reg_write;
assign write_back_destination_out = in_write_back_destination;

MEM_Data_Memory mem_ram
    (
    // OUTPUT
    read_data_out,
    // INPUT
    in_mem_write,
    in_mem_read,
    in_load_mode,
    in_address,
    in_write_data
    );

endmodule

module MEM_WB_Reg(
    input clk,
    input [4:0] write_back_destination_in,
    input reg_write_in,
    input [31:0] read_data_in,
    input [31:0] address_in,
    input mem_to_reg_in,
    output reg [4:0] write_back_destination_out,
    output reg reg_write_out,
    output reg [31:0] read_data_out,
    output reg [31:0] address_out,
    output reg mem_to_reg_out
);

always @ (posedge clk)
begin
    reg_write_out <= reg_write_in;
    read_data_out <= read_data_in;
    address_out <= address_in;
    write_back_destination_out <= write_back_destination_in;
    mem_to_reg_out <= mem_to_reg_in;
end

endmodule

module WB_Stage(
    input in_mem_to_reg,
    input in_reg_write,
    input [4:0] in_write_back_destination,
    input [31:0] in_address,
    input [31:0] in_read_data,
    output [31:0] write_data_out,
    output reg_write_out,
    output [4:0] write_back_destination_out
);

assign write_data_out = (in_mem_to_reg === 1)? in_address : in_read_data;
assign reg_write_out = in_reg_write;
assign write_back_destination_out = in_write_back_destination;

endmodule

module MIPS(
    input clk
);

// --- IF Wires --- //
wire IF_PCSrc;
wire [31:0] IF_branch_address;
wire [31:0] instruction_IF;
wire [31:0]  pc_plus_four_IF;
// --- END IF Wires --- //

// --- ID Wires --- //
wire [4:0] ID_write_register;
wire [31:0] ID_write_data;
wire ID_RegWrite;
wire [31:0] ID_instruction;
wire [31:0] ID_new_pc_value;
wire [4:0]  instr_bits_15_11_ID;
wire [4:0]  instr_bits_20_16_ID;
wire [31:0]  extended_bits_ID;
wire [31:0]  read_data1_ID;
wire [31:0]  read_data2_ID;
wire [31:0]  new_pc_value_ID;
wire  RegDst_ID;
wire  RegWrite_ID;
wire  ALUSrc_ID;
wire  MemWrite_ID;
wire  MemRead_ID;
wire  MemToReg_ID;
wire  Branch_ID;
wire [1:0]  load_mode_ID;
wire [2:0]  ALUOp_ID;
// --- END ID Wires --- //

// --- EX Wires --- //
wire EX_RegDst;
wire EX_RegWrite;
wire EX_ALUSrc;
wire EX_MemWrite;
wire EX_MemRead;
wire EX_MemToReg;
wire [2:0] EX_ALUOp;
wire [4:0] EX_instr_bits_15_11;
wire [4:0] EX_instr_bits_20_16;
wire [31:0] EX_extended_bits;
wire [31:0] EX_read_data1;
wire [31:0] EX_read_data2;
wire [31:0] EX_new_pc_value;
wire [1:0] EX_load_mode;
wire EX_branch;
wire  zero_EX;
wire  RegWrite_EX;
wire  MemWrite_EX;
wire  MemRead_EX;
wire  MemToReg_EX;
wire [1:0]  load_mode_EX;
wire [4:0]  writebackDestination_EX;
wire [31:0]  aluResult_EX;
wire [31:0]  rt_EX;
wire [31:0]  pc_EX;
wire branch_EX;
// --- END EX Wires --- //

// --- MEM Wires --- //
wire MEM_mem_to_reg;
wire [31:0] MEM_address;
wire [31:0] MEM_write_data;
wire MEM_mem_write;
wire MEM_reg_write;
wire MEM_mem_read;
wire [1:0] MEM_load_mode;
wire MEM_zero;
wire MEM_branch;
wire [4:0] MEM_write_back_destination;
wire [31:0]   read_data_MEM;
wire  mem_to_reg_MEM;
wire  reg_write_MEM;
wire [31:0]  address_MEM;
wire [4:0]  write_back_destination_MEM;
// --- END MEM Wires --- //

// --- WB Wires --- //
wire WB_mem_to_reg;
wire WB_reg_write;
wire [4:0] WB_write_back_destination;
wire [31:0] WB_address;
wire [31:0] WB_read_data;
// --- END WB Wires --- //


// --- IF Stage --- //
IF_Stage IF_Stage_Module(
clk,
IF_PCSrc,
IF_branch_address,
instruction_IF,
pc_plus_four_IF
);
// --- END IF Stage --- //

// --- IF/ID Pipeline Register --- //
IF_ID_Reg IF_ID_Pipeline_Register(
	clk,
	instruction_IF,
	pc_plus_four_IF,
	ID_instruction,
	ID_new_pc_value
);
// --- END IF/ID Pipeline Register --- //

// --- ID Stage --- //
ID_Stage ID_Stage_Module(
	clk,
	ID_write_register,
	ID_write_data,
	ID_RegWrite,
	ID_instruction,
	ID_new_pc_value,
	instr_bits_15_11_ID,
	instr_bits_20_16_ID,
	extended_bits_ID,
	read_data1_ID,
	read_data2_ID,
	new_pc_value_ID,
	RegDst_ID,
	RegWrite_ID,
	ALUSrc_ID,
	MemWrite_ID,
	MemRead_ID,
	MemToReg_ID,
	Branch_ID,
	load_mode_ID,
	ALUOp_ID
);
// --- END ID Stage -- //

// --- ID/EX Pipeline Register --- //
ID_EX_Reg ID_EX_Pipeline_Register(
	clk, 
	instr_bits_15_11_ID,
	instr_bits_20_16_ID,
	extended_bits_ID,
	read_data1_ID,
	read_data2_ID,
	new_pc_value_ID,
	RegDst_ID,
	RegWrite_ID,
	ALUSrc_ID,
	MemWrite_ID,
	MemRead_ID,
	MemToReg_ID,
	Branch_ID,
	load_mode_ID,
	ALUOp_ID,
	EX_instr_bits_15_11,
	EX_instr_bits_20_16,
	EX_extended_bits,
	EX_read_data1,
	EX_read_data2,
	EX_new_pc_value,
	EX_RegDst,
	EX_RegWrite,
	EX_ALUSrc,
	EX_MemWrite,
	EX_MemRead,
	EX_MemToReg,
	EX_branch,
	EX_load_mode,
	EX_ALUOp
);
// --- END ID/EX Pipeline Register --- //

// --- EX Stage --- //
EX_Stage EX_Stage_Module(
	clk,
	EX_RegDst,
	EX_RegWrite,
	EX_ALUSrc,
	EX_MemWrite,
	EX_MemRead,
	EX_MemToReg,
	EX_ALUOp,
	EX_instr_bits_15_11,
	EX_instr_bits_20_16,
	EX_extended_bits,
	EX_read_data1,
	EX_read_data2,
	EX_new_pc_value,
	EX_load_mode,
	EX_branch,
	zero_EX,
	RegWrite_EX,
	MemWrite_EX,
	MemRead_EX,
	MemToReg_EX,
	load_mode_EX,
	writebackDestination_EX,
	aluResult_EX,
	rt_EX,
	pc_EX,
	branch_EX
);
// --- END EX Stage --- //

// --- EX/MEM Pipeline Register --- //
EX_MEM_Reg EX_MEM_Pipeline_Register(
	clk,
	RegWrite_EX, 
	MemWrite_EX, 
	MemRead_EX, 
	MemToReg_EX, 
	pc_EX, 
	zero_EX, 
	aluResult_EX, 
	rt_EX, 
	writebackDestination_EX,
	load_mode_EX,
	branch_EX,
	MEM_reg_write,
	MEM_mem_write,
	MEM_mem_read,
	MEM_mem_to_reg,
	IF_branch_address,
	MEM_zero,
	MEM_address,
	MEM_write_data,
	MEM_write_back_destination,
	MEM_load_mode,
	MEM_branch
);
// --- END EX/MEM Pipeline Register --- //

// --- MEM Stage --- //
MEM_Stage MEM_Stage_Module(
	clk,
	MEM_mem_to_reg,
	MEM_address,
	MEM_write_data,
	MEM_mem_write,
	MEM_reg_write,
	MEM_mem_read,
	MEM_load_mode,
	MEM_zero,
	MEM_branch,
	MEM_write_back_destination,
	IF_PCSrc,
	read_data_MEM,
	mem_to_reg_MEM,
	reg_write_MEM,
	address_MEM,
	write_back_destination_MEM
);
// --- END MEM Stage --- //

// --- MEM/WB Pipeline Register --- //
MEM_WB_Reg MEM_WB_Pipeline_Register(
	clk,
	write_back_destination_MEM,
	reg_write_MEM,
	read_data_MEM,
	address_MEM,
	mem_to_reg_MEM,
	WB_write_back_destination,
	WB_reg_write,
	WB_read_data,
	WB_address,
	WB_mem_to_reg
);
// --- END MEM/WB Pipeline Register --- //

// --- WB Stage --- //
WB_Stage WB_Stage_Module(
	WB_mem_to_reg,
	WB_reg_write,
	WB_write_back_destination,
	WB_address,
	WB_read_data,
	ID_write_data,
	ID_RegWrite,
	ID_write_register
);
// --- END WB Stage --- //

endmodule

module MIPS_testbench();

// the clock
reg clk;
integer cycle_counter;
integer i = 0;

// instantiate the mips processor
MIPS mips(clk);

// get the clock working
initial 
begin
	// branch
	MIPS_testbench.mips.ID_Stage_Module.Registers.registers[29] <= 3999;
	mips.IF_Stage_Module.instruction_memory[0] <= 32'h2010_001f;
    mips.IF_Stage_Module.instruction_memory[1] <= 32'h2011_ffe0;
    mips.IF_Stage_Module.instruction_memory[5] <= 32'h0211_9020;
    mips.IF_Stage_Module.instruction_memory[6] <= 32'h0230_9822;
    mips.IF_Stage_Module.instruction_memory[7] <= 32'hafb1_0000;
    mips.IF_Stage_Module.instruction_memory[8] <= 32'h8fb4_0000;
    mips.IF_Stage_Module.instruction_memory[9] <= 32'h87b5_0000;
    mips.IF_Stage_Module.instruction_memory[10] <= 32'h97b6_0000;
    mips.IF_Stage_Module.instruction_memory[11] <= 32'h0211_b824;
    mips.IF_Stage_Module.instruction_memory[12] <= 32'h0211_4025;
    mips.IF_Stage_Module.instruction_memory[13] <= 32'h0010_4840;
    mips.IF_Stage_Module.instruction_memory[14] <= 32'h0010_5082;
    mips.IF_Stage_Module.instruction_memory[15] <= 32'h320b_0003;
    mips.IF_Stage_Module.instruction_memory[16] <= 32'h360c_0003;
    mips.IF_Stage_Module.instruction_memory[17] <= 32'h1295_0001;
    mips.IF_Stage_Module.instruction_memory[18] <= 32'h200d_0001;
    mips.IF_Stage_Module.instruction_memory[19] <= 32'h0211_702a;
    mips.IF_Stage_Module.instruction_memory[20] <= 32'h0211_782b;
    mips.IF_Stage_Module.instruction_memory[21] <= 32'hafb0_0000;
    mips.IF_Stage_Module.instruction_memory[22] <= 32'hafb1_fffc;
    mips.IF_Stage_Module.instruction_memory[23] <= 32'hafb2_fff8;
    mips.IF_Stage_Module.instruction_memory[24] <= 32'hafb3_fff4;
    mips.IF_Stage_Module.instruction_memory[25] <= 32'hafb4_fff0;
    mips.IF_Stage_Module.instruction_memory[26] <= 32'hafb5_ffec;
    mips.IF_Stage_Module.instruction_memory[27] <= 32'hafb6_ffe8;
    mips.IF_Stage_Module.instruction_memory[28] <= 32'hafb7_ffe4;
    mips.IF_Stage_Module.instruction_memory[29] <= 32'hafa8_ffe0;
    mips.IF_Stage_Module.instruction_memory[30] <= 32'hafa9_ffdc;
    mips.IF_Stage_Module.instruction_memory[31] <= 32'hafaa_ffd8;
    mips.IF_Stage_Module.instruction_memory[32] <= 32'hafab_ffd4;
    mips.IF_Stage_Module.instruction_memory[33] <= 32'hafac_ffd0;
    mips.IF_Stage_Module.instruction_memory[34] <= 32'hafad_ffcc;
    mips.IF_Stage_Module.instruction_memory[35] <= 32'hafae_ffc8;
    mips.IF_Stage_Module.instruction_memory[36] <= 32'hafaf_ffc4;
    cycle_counter <= 0;
	clk <= 1;
	forever 
	begin
		#100 clk <= ~clk;
	end
end

// incrememnt cycle counter at each positive edge
always @(posedge clk) cycle_counter <= cycle_counter + 1;

// stop after program ends
initial
begin
	#20000
    $display("s0 Expected: 00000000000000000000000000011111, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[16]);
	$display("s1 Expected: 11111111111111111111111111100000, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[17]);
	$display("s2 Expected: 11111111111111111111111111111111, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[18]);
	$display("s3 Expected: 11111111111111111111111111000001, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[19]);
	$display("s4 Expected: 11111111111111111111111111100000, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[20]);
	$display("s5 Expected: 11111111111111111111111111100000, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[21]);
	$display("s6 Expected: 00000000000000001111111111100000, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[22]);
	$display("s7 Expected: 00000000000000000000000000000000, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[23]);
	$display("t0 Expected: 11111111111111111111111111111111, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[8]);
	$display("t1 Expected: 00000000000000000000000000111110, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[9]);
	$display("t2 Expected: 00000000000000000000000000000111, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[10]);
	$display("t3 Expected: 00000000000000000000000000000011, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[11]);
	$display("t4 Expected: 00000000000000000000000000011111, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[12]);
	$display("t5 Expected: 00000000000000000000000000000000, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[13]);
	$display("t6 Expected: 00000000000000000000000000000000, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[14]);
	$display("t7 Expected: 00000000000000000000000000000001, Actual: %b", MIPS_testbench.mips.ID_Stage_Module.Registers.registers[15]);
	for(i = 0; i < 16; i = i + 1)
	    $display("%d: %b", i, mips.IF_Stage_Module.instruction_memory[i]);
	$stop;
end

endmodule