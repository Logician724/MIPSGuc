module ALU(firstOperand, secondOperand, aluControlInput, shamt, aluResult, zero);

input signed [31:0] firstOperand, secondOperand;
input [4:0] shamt;
input [3:0] aluControlInput;

output zero;
output reg [31:0] aluResult;

assign zero = (firstOperand === secondOperand);

always @(firstOperand, secondOperand, aluControlInput, shamt)
begin
	case(aluControlInput)
		4'b0000: aluResult <= firstOperand & secondOperand; // and
		4'b0001: aluResult <= firstOperand | secondOperand; // or
		4'b0010: aluResult <= firstOperand + secondOperand; // add
		4'b0011: aluResult <= secondOperand << shamt; // sll
		4'b0100: aluResult <= secondOperand >> shamt; // srl
		4'b0110: aluResult <= firstOperand - secondOperand; // sub
		4'b0111: aluResult <= firstOperand < secondOperand; // slt
		4'b1011: aluResult <= $unsigned(firstOperand) < $unsigned(secondOperand); // sltu
		default: $display("ERROR in ALU Select"); // undefined operation
	endcase
end

endmodule
