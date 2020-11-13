
module Adder9bit ( input [7:0] A, B, 
						input Fn, 
						output [8:0] S);

logic c0,c1;
logic [7:0] BTemp;
logic A9, BTemp9;

assign BTemp = (B ^ {8{Fn}});
assign A9 = A[7]; 
assign BTemp9 = BTemp[7];
 
	adder4 AD0(.A(A[3:0]), .B(BTemp[3:0]), .cin(Fn), .S(S[3:0]), .cout(c0));
	adder4 AD1(.A(A[7:4]), .B(BTemp[7:4]), .cin(c0), .S(S[7:4]), .cout(c1));
	full_adder AD2(.x(A9), .y(BTemp9), .z(c1), .s(S[8]), .c());

endmodule

module adder4 (input [3:0] A, B,
					input cin,
					output cout,
					output [3:0] S);
	logic c0, c1, c2;
	
	full_adder FA0(.x(A[0]), .y(B[0]), .z(cin), .s(S[0]), .c(c0));
	full_adder FA1(.x(A[1]), .y(B[1]), .z(c0), .s(S[1]), .c(c1));
	full_adder FA2(.x(A[2]), .y(B[2]), .z(c1), .s(S[2]), .c(c2));
	full_adder FA3(.x(A[3]), .y(B[3]), .z(c2), .s(S[3]), .c(cout));
endmodule
	
	
module full_adder (input x, y, z,
	output s, c);
		
		assign s = x^y^z;
		assign c = (x&y)|(y&z)|(x&z);
		
endmodule

     
