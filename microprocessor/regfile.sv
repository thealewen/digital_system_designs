module regfile(
	input logic ldreg, Reset, Clk,
	input logic [2:0] drmux, sr1mux, sr2input,
	input logic [15:0] bus,
	output logic [15:0] sr1, sr2
);


logic [7:0][15:0] regfile;

always_ff @ (posedge Clk)
	begin 
						
		if(Reset)
			for(int i = 0; i<8; i++) begin
				regfile[i]<= 16'h0000;
			end
		else if(ldreg)
			case(drmux)
				3'b000 : regfile[0] <= bus;
				3'b001 : regfile[1] <= bus;
				3'b010 : regfile[2] <= bus;
				3'b011 : regfile[3] <= bus;
				3'b100 : regfile[4] <= bus;
				3'b101 : regfile[5] <= bus;
				3'b110 : regfile[6] <= bus;
				3'b111 : regfile[7] <= bus;
			endcase
	end

always_comb
	begin 
		case(sr1mux)
			3'b000 : sr1 = regfile[0];
			3'b001 : sr1 = regfile[1];
			3'b010 : sr1 = regfile[2];
			3'b011 : sr1 = regfile[3];
			3'b100 : sr1 = regfile[4];
			3'b101 : sr1 = regfile[5];
			3'b110 : sr1 = regfile[6];
			3'b111 : sr1 = regfile[7];
		endcase
		
		case(sr2input)
			3'b000 : sr2 = regfile[0];
			3'b001 : sr2 = regfile[1];
			3'b010 : sr2 = regfile[2];
			3'b011 : sr2 = regfile[3];
			3'b100 : sr2 = regfile[4];
			3'b101 : sr2 = regfile[5];
			3'b110 : sr2 = regfile[6];
			3'b111 : sr2 = regfile[7];
		endcase
	end	
endmodule
