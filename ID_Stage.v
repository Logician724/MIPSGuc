module ID_Stage(input clk,
                input [5:0] delay_write_register,
                input [31:0] delay_write_data,
                input delay_in_RegWrite,
                input [31:0] delay_instruction,
                input [31:0] delay_in_new_pc_value,
                input [31:0] register_input,
                output [4:0] instr_bits_15_11,
                output [4:0] instr_bits_20_16,
                output [31:0] extended_bits,
                output [31:0] read_data1,
                output [31:0] read_data2,
                output [31:0] new_pc_value,
                output RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Branch,
                output [1:0] load_mode,
                output [2:0] ALUOp);


wire [31:0] extendedBitsFromFile;
wire [31:0] read_data1_FromFile;
wire [31:0] read_data2_FromFile;
wire RegDstFromCtrl, RegWriteFromCtrl, ALUSrcFromCtrl, MemWriteFromCtrl, MemReadFromCtrl, MemToRegFromCtrl, BranchFromCtrl; 
wire [1:0] load_modeFromCtrl;
wire [2:0] ALUOpFromCtrl;

// delay variables
reg [5:0] write_register;
reg [31:0] write_data, instruction, in_new_pc_value;
reg in_RegWrite;

always @(delay_in_new_pc_value) #5 in_new_pc_value = delay_in_new_pc_value;
always @(delay_in_RegWrite) #5 in_RegWrite = delay_in_RegWrite;
always @(delay_instruction) #5 instruction = delay_instruction;
always @(delay_write_data) #5 write_data = delay_write_data;
always @(delay_write_register) #5 write_register = delay_write_register;

ID_EX_Reg StageRegister(// INPUT
                        clk, 
                        instruction[15:11], 
                        instruction[20:16],  
                        extendedBitsFromFile, 
                        read_data1_FromFile, 
                        read_data2_FromFile, 
                        in_new_pc_value,
                        RegDstFromCtrl, 
                        RegWriteFromCtrl,
                        ALUSrcFromCtrl,
                        MemWriteFromCtrl,
                        MemReadFromCtrl,
                        MemToRegFromCtrl,
                        BranchFromCtrl,
                        load_modeFromCtrl,
                        ALUOpFromCtrl,
                        // OUTPUT 
                        instr_bits_15_11, 
                        instr_bits_20_16, 
                        extended_bits, 
                        read_data1, 
                        read_data2, 
                        new_pc_value, 
                        RegDst, 
                        RegWrite, 
                        ALUSrc,  
                        MemWrite, 
                        MemRead, 
                        MemToReg, 
                        Branch, 
                        load_mode,
                        ALUOp);

ID_Register_File Registers(// INPUT
                           clk, 
                           instruction, 
                           write_data, 
                           write_register, 
                           in_RegWrite,
                           register_input, 
                           // OUTPUT
                           extendedBitsFromFile, 
                           read_data1_FromFile, 
                           read_data2_FromFile );


ID_Control_Unit Control(instruction[31:26],
                        // OUTPUT
                        RegDstFromCtrl, 
                        RegWriteFromCtrl,
                        ALUSrcFromCtrl,
                        ALUOpFromCtrl,
                        MemWriteFromCtrl,
                        MemReadFromCtrl,
                        MemToRegFromCtrl,
                        BranchFromCtrl,
                        load_modeFromCtrl);

endmodule