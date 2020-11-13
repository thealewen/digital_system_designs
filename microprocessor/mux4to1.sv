module mux4to1(
	input logic[1:0] select,
	input logic [15:0] din0, din1, din2, din3,
	output logic [15:0] out
);

always_comb
	begin
		unique case (select)
			2'b00: out = din0;
			2'b01: out = din1;
			2'b10: out = din2;
			2'b11: out = din3;
		endcase
	end
	
endmodule

module tri_mux4to1(
	input logic[3:0] select,
	input logic [15:0] din0, din1, din2, din3,
	output logic [15:0] out
);

always_comb
	begin
		unique case (select)
			4'b0001: out = din0;
			4'b0010: out = din1;
			4'b0100: out = din2;
			4'b1000: out = din3;
		endcase
	end
	
endmodule
