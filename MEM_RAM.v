module(
    read_data,
    mem_write,
    mem_read,
    address,
    write_data
);

input mem_read;
input mem_write;
input [31:0] address;
input [31:0] write_data;
output reg [31:0] read_data;
reg [4294967296:0] ram [7:0];

always@(mem_read,mem_write,address,write_data)begin
    if(mem_read)begin
        read_data = {ram[address],ram[address+1],ram[address+2],ram[address+3]}
    end

    if(mem_write)begin
    {ram[address],ram[address+1],ram[address+2],ram[address+3]} = write_data;
    end
    
end


endmodule