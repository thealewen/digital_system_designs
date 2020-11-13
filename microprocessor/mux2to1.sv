module mux2to1(
	input logic select,
	input logic [15:0] din0, din1,
	output logic [15:0] out
);

always_comb
	begin
		unique case (select)
			1'b0: out = din0;
			1'b1: out = din1;
		endcase
	end
	
endmodule

module mux2to13(
	input logic select,
	input logic [2:0] din0, din1,
	output logic [2:0] out
);

always_comb
	begin
		unique case (select)
			1'b0: out = din0;
			1'b1: out = din1;
		endcase
	end
	
endmodule
