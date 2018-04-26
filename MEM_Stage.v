module MEM_Stage(
     pc_src,
     read_data,
     mem_to_reg,
     reg_write_out,
     address_out,
     clk,
     in_mem_to_reg,
     in_address,
     in_write_data,
     in_mem_write,
     in_reg_write,
     in_mem_read,
     in_load_mode,
     in_zero,
     in_branch
);
input clk;
input in_mem_read;
input in_mem_write;
input in_reg_write;
input in_mem_to_reg;
input in_zero;
input in_branch;
input [1:0] in_load_mode;
output reg_write_out;
output pc_src;
output [31:0] read_data, address_out;
output reg mem_to_reg;
input [31:0] in_address;
input [31:0] in_write_data;
reg mem_read, mem_write, reg_write, branch, zero;
reg [1:0] load_mode;
reg [31:0] address, write_data;


always@(in_write_data) #5 write_data = in_write_data ;
always@(in_address) #5  address = in_address ;
always@(in_mem_read) #5 mem_read = in_mem_read ;
always@(in_mem_write) #5 mem_write = in_mem_write ;
always@(in_load_mode) #5 load_mode = in_load_mode;
always@(in_reg_write) #5 reg_write = in_reg_write;
always@(in_mem_to_reg) #5 mem_to_reg = in_mem_to_reg;
always@(in_branch) #5 branch = in_branch;
always@(in_zero) #5 zero = in_zero;
wire [31:0] read_memory_out;

and(pc_src,zero,branch);

MEM_Data_Memory mem_ram
    (read_memory_out,
    mem_write,
    mem_read,
    load_mode,
    address,
    write_data
    );

MEM_WB_Reg mem_wb_reg
    (reg_write_out,
    read_data,
    address_out,
    clk,
    reg_write,
    read_memory_out,
    address
    );

endmodule
