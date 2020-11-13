module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic           CO,
	 output  logic[15:0]     S //Sum
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic c0, c1, c2;
		adder4 AD0 (.A (A[3:0]), .B (B[3:0]), .c_in (0), .S (S[3:0]), .c_out (c0));
		adder4 AD1 (.A (A[7:4]), .B (B[7:4]), .c_in (c0), .S (S[7:4]), .c_out (c1));
		adder4 AD2 (.A (A[11:8]), .B (B[11:8]), .c_in (c1), .S (S[11:8]), .c_out (c2));
		adder4 AD3 (.A (A[15:12]), .B (B[15:12]), .c_in (c2), .S (S[15:12]), .c_out (CO));
endmodule

/*
This module is just taken from the practise from the guide. That was only for 2-bit adder, this was extended to 4 4 bit-adder.
If we just used full_adder, we needed FA0 to FA15 therefore we just divided intro module adder2 and full_adder.
*/

module adder4 (input [3:0] A, B,
	input c_in,
	output [3:0] S,
	output c_out);
		
		logic c0, c1, c2;
		full_adder FA0 (.x (A[0]), .y (B[0]), .z (c_in), .s (S[0]), .c (c0));
		full_adder FA1 (.x (A[1]), .y (B[1]), .z (c0), .s (S[1]), .c (c1));
		full_adder FA2 (.x (A[2]), .y (B[2]), .z (c1), .s (S[2]), .c (c2));
		full_adder FA3 (.x (A[3]), .y (B[3]), .z (c2), .s (S[3]), .c (c_out));

endmodule

module full_adder (input x, y, z,
	output s, c);
		
		assign s = x^y^z;
		assign c = (x&y)|(y&z)|(x&z);
		
		endmodule
     
