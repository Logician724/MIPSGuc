module MEM_WB_Reg(
    write_back_destination_out,
    reg_write_out,
    read_data_out,
    address_out,
    clk,
    write_back_destination_in,
    reg_write_in,
    read_data_in,
    address_in
);

input clk;
input reg_write_in;
input [31:0] read_data_in, address_in;
input [4:0] write_back_destination_in;
output reg reg_write_out;
output reg [4:0] write_back_destination_out;
output reg [31:0] read_data_out, address_out;

always @ (posedge clk)begin
    reg_write_out <= reg_write_in;
    read_data_out <= read_data_in;
    address_out <= address_in;
    write_back_destination_out <= write_back_destination_in;
end

endmodule