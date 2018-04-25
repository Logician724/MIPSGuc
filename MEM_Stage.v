module MEM_Stage(
     read_data,
     clk,
     in_address,
     in_write_data,
     in_mem_write,
     in_mem_read
);
input clk;
input in_mem_read;
input in_mem_write;
output reg [31:0] read_data;
input [31:0] in_address;
input [31:0] in_write_data;
reg mem_read, mem_write;
reg [31:0] address, write_data;



always@(in_write_data) #5 in_write_data = write_data;
always@(in_address) #5 in_address = address;
always@(in_mem_read) #5 in_mem_read = mem_read;
always@(in_mem_write) #5 in_mem_write = mem_write;