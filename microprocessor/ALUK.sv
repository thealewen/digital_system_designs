module ALUKa(
	input logic [15:0] A, B,
	input logic [1:0] select,
	output logic [15:0] S
);

always_comb
	begin
		case(select)
			2'b00 : S = A+B;
			2'b01 : S = A&B;
			2'b10 : S = ~A;
			2'b11 : S = A;
		endcase
	end
endmodule
