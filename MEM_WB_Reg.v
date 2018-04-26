module MEM_WB_Reg(
    write_back_out,
    read_data_out,
    address_out,
    clk,
    write_back_in,
    read_data_in,
    address_in

);

input clk;
input write_back_in;
input [31:0] read_data_in, address_in;
output reg write_back_out;
output reg [31:0] read_data_out, address_out;

always @ (posedge clk)begin
    write_back_out <= write_back_in;
    read_data_out <= read_data_in;
    address_out <= address_in;
end

endmodule