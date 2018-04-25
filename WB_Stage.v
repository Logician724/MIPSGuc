module WB_Stage(
    wb_out,
    in_mem_to_reg,
    in_address,
    in_read_data);
input in_mem_to_reg;
input [31:0] in_address,in_read_data;
reg [31:0] address, read_data;
reg mem_to_reg;
output reg [31:0] wb_out;

always@(in_address)  #5 address = in_address;
always@(in_read_data) #5 read_data = in_read_data;
always@(in_mem_to_reg) #5 mem_to_reg = in_mem_to_reg;

always@(address, read_data, mem_to_reg) begin
    if(mem_to_reg)begin
        wb_out = in_read_data;
    end else begin
        wb_out = in_address;
    end
end

endmodule