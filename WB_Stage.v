module WB_Stage(
    input in_mem_to_reg,
    input in_reg_write,
    input [4:0] in_write_back_destination,
    input [31:0] in_address,
    input [31:0] in_read_data,
    output reg [31:0] wb_out,
    output reg reg_write_out,
    output reg [4:0] write_back_destination_out
);

reg [31:0] address, read_data;
reg mem_to_reg;

// initialization
initial
begin
address <= 0;
read_data <= 0;
mem_to_reg <= 0;
reg_write_out <= 0;
write_back_destination_out <= 0;
end

// delay
always@(in_address)  #5 address = in_address;
always@(in_read_data) #5 read_data = in_read_data;
always@(in_mem_to_reg) #5 mem_to_reg = in_mem_to_reg;
always@(in_reg_write) #5 reg_write_out = in_reg_write;
always@(in_write_back_destination) #5 write_back_destination_out = in_write_back_destination;

always@(address, read_data, mem_to_reg) begin
    if(mem_to_reg)begin
        wb_out = read_data;
    end else begin
        wb_out = address;
    end
end

endmodule
