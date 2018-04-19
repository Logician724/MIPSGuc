module ID_Stage(input clk,
                input [5:0] write_register,
                input [31:0] write_data,
                input in_RegWrite,
                input [1:0] in_load_mode,
                input [31:0] instruction,
                input [31:0] in_new_pc_value,
                output reg [4:0] instr_bits_15_11,
                output reg [4:0] instr_bits_20_16,
                output reg [31:0] extended_bits,
                output reg [31:0] read_data1,
                output reg [31:0] read_data2,
                output reg [31:0] new_pc_value,
                output reg RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Branch,
                output reg [1:0] load_mode,
                output reg [2:0] ALUOp);



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

wire [31:0] extendedBitsFromFile;
wire [31:0] read_data1_FromFile;
wire [31:0] read_data2_FromFile;

ID_Register_File Registers(// INPUT
                           clk, 
                           instruction, 
                           write_data, 
                           write_register, 
                           in_RegWrite, 
                           in_load_mode,
                           // OUTPUT
                           extendedBitsFromFile, 
                           read_data1_FromFile, 
                           read_data2_FromFile );

wire RegDstFromCtrl, RegWriteFromCtrl, ALUSrcFromCtrl, MemWriteFromCtrl, MemReadFromCtrl, MemToRegFromCtrl, BranchFromCtrl; 
wire [1:0] load_modeFromCtrl;
wire [2:0] ALUOpFromCtrl;

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