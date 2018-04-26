module MEM_Stage(
     read_data,
     mem_to_reg,
     write_back_out,
     address_out,
     clk,
     in_mem_to_reg,
     in_address,
     in_write_data,
     in_mem_write,
     in_write_back,
     in_mem_read,
     in_load_mode
);
input clk;
input in_mem_read;
input in_mem_write;
input in_write_back;
input in_mem_to_reg;
input [1:0] in_load_mode;
output write_back_out;
output [31:0] read_data, address_out;
output reg mem_to_reg;
input [31:0] in_address;
input [31:0] in_write_data;
reg mem_read, mem_write, write_back;
reg [1:0] load_mode;
reg [31:0] address, write_data;


always@(in_write_data) #5 write_data = in_write_data ;
always@(in_address) #5  address = in_address ;
always@(in_mem_read) #5 mem_read = in_mem_read ;
always@(in_mem_write) #5 mem_write = in_mem_write ;
always@(in_load_mode) #5 load_mode = in_load_mode;
always@(in_write_back) #5 write_back = in_write_back;
always@(in_mem_to_reg) #5 mem_to_reg = in_mem_to_reg;
wire [31:0] read_memory_out;

MEM_Data_Memory mem_ram
    (read_memory_out,
    mem_write,
    mem_read,
    address,
    write_data
    );

MEM_WB_Reg mem_wb_reg
    (write_back_out,
    read_data,
    address_out,
    clk,
    write_back,
    read_memory_out,
    address
    );

endmodule