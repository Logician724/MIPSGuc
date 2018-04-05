module ALU(firstOperand, secondOperand, aluControlInput, aluResult, shamt, zero);

input signed [31:0] firstOperand, secondOperand;
input [4:0] shamt;
input [3:0] aluControlInput;

output reg zero;
output reg [31:0] aluResult;

always @(firstOperand, secondOperand)
begin
	if(firstOperand == secondOperand)
		zero = 1;
	else
		zero = 0;
end

always @(firstOperand, secondOperand, aluControlInput, shamt)
begin
	case(aluControlInput)
		4'b0000: aluResult = firstOperand & secondOperand;
		4'b0001: aluResult = firstOperand | secondOperand;
		4'b0010: aluResult = firstOperand + secondOperand;
		4'b0011: aluResult = secondOperand << shamt;
		4'b0100: aluResult = secondOperand >> shamt;
		4'b0110: aluResult = firstOperand - secondOperand;
		4'b0111: aluResult = firstOperand < secondOperand;
		4'b1011: aluResult = $unsigned(firstOperand) < $unsigned(secondOperand);
		4'b1100: aluResult = ~ (firstOperand | secondOperand);
		default: $display("ERROR in ALU Select");
	endcase
end

endmodule
