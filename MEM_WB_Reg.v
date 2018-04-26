module MEM_WB_Reg(
    reg_write_out,
    read_data_out,
    address_out,
    clk,
    reg_write_in,
    read_data_in,
    address_in

);

input clk;
input reg_write_in;
input [31:0] read_data_in, address_in;
output reg reg_write_out;
output reg [31:0] read_data_out, address_out;

always @ (posedge clk)begin
    reg_write_out <= reg_write_in;
    read_data_out <= read_data_in;
    address_out <= address_in;
end

endmodule