module MEM_RAM(
    read_data,
    mem_write,
    mem_read,
    address,
    write_data
);

input mem_read;
input mem_write;
input [1:0] load_mode;
input [31:0] address;
input [31:0] write_data;
output reg [31:0] read_data;
reg [4294967296:0] ram [7:0];

always@(mem_read,mem_write,address,write_data)begin
    if(mem_read && load_mode == 2'b00)begin
        case(load_mode)
        2'b00: 
            read_data = {
            ram[address],
            ram[address + 1],
            ram[address + 2],
            ram[address + 3]
            };
        2'b01:
            read_data = {
            {16{ram[address][7]}},
            ram[address],
            ram[address + 1]
            };
        2'b10:
        read_data = {
            16'b0,
            ram[address],
            ram[address + 1]
            };
        default: $display("Error in MEM_RAM");
    end
        
    if(mem_write)begin
    {
        ram[address],
        ram[address+1],
        ram[address+2],
        ram[address+3]} = write_data;
    end

end


endmodule