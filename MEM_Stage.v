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
    input [4:0] in_write_back_destination
    output pc_src,
    output [31:0] read_data,
    output reg mem_to_reg,
    output reg_write_out,
    output [31:0] address_out,
    output [4:0] write_back_destination_out,
);

reg mem_read, mem_write, reg_write, branch, zero;
reg [1:0] load_mode;
reg [4:0] write_back_destination;
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
always@(in_write_back_destination) #5 write_back_destination = in_write_back_destination;

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
    (write_back_destination_out,
    reg_write_out,
    read_data,
    address_out,
    clk,
    write_back_destination_in,
    reg_write,
    read_memory_out,
    address
    );

endmodule
