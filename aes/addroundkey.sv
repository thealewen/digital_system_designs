module AddRoundKey(
	input logic [127:0] State,
	input logic [1407:0] KeyExp,
	input logic [3:0] Round,
	output logic [127:0] data_out
);

always_comb
begin
//data_out = State ^ KeyExp[1407-(128*Round):1280-(128*Round)];
	case(Round)
		4'b0000: data_out = State ^ KeyExp[127:0];
		4'b0001: data_out = State ^ KeyExp[255:128];
		4'b0010: data_out = State ^ KeyExp[383:256];
		4'b0011: data_out = State ^ KeyExp[511:384];
		4'b0100: data_out = State ^ KeyExp[639:512];
		4'b0101: data_out = State ^ KeyExp[767:640];
		4'b0110: data_out = State ^ KeyExp[895:768];
		4'b0111: data_out = State ^ KeyExp[1023:896];
		4'b1000: data_out = State ^ KeyExp[1151:1024];
		4'b1001: data_out = State ^ KeyExp[1279:1152];
		4'b1010: data_out = State ^ KeyExp[1407:1280];
		default: data_out = State;
	endcase
end

endmodule
