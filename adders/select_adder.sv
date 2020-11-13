module select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     S,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

         logic C1, C2, C3, Cout;

      fourbitsa FRA0(.x(A[3:0]), .y(B[3:0]), .cin(0), .s(S[3:0]), .cout(c1));
      fourbitsa FRA1(.x(A[7:4]), .y(B[7:4]), .cin(c1), .s(S[7:4]), .cout(c2));
      fourbitsa FRA2(.x(A[11:8]), .y(B[11:8]), .cin(c2), .s(S[11:8]), .cout(c3));
      fourbitsa FRA3(.x(A[15:12]), .y(B[15:12]), .cin(c3), .s(S[15:12]), .cout(Cout));
            assign CO = Cout;

endmodule

module fourbitsa(
input [3:0] x,
input [3:0] y,
input cin,
output logic [3:0] s,
output logic cout
);

  logic c00, c01, c10, c11, c20, c21, cout0, cout1;
    logic [3:0] s0, s1;

         fadder fa0(.x(x[0]), .y(y[0]), .cin(1'b0), . s(s0[0]), .cout(c00));
         fadder fa1(.x(x[1]), .y(y[1]), .cin(c00), .s(s0[1]), .cout(c10));
         fadder fa2(.x(x[2]), .y(y[2]), .cin(c10), .s(s0[2]), .cout(c20));
         fadder fa3(.x(x[3]), .y(y[3]), .cin(c20), .s(s0[3]), .cout(cout0));

			fadder fa01(.x(x[0]), .y(y[0]), .cin(1'b1), . s(s1[0]), .cout(c01));
			fadder fa11(.x(x[1]), .y(y[1]), .cin(c01), .s(s1[1]), .cout(c11));
			fadder fa21(.x(x[2]), .y(y[2]), .cin(c11), .s(s1[2]), .cout(c21));
			fadder fa31(.x(x[3]), .y(y[3]), .cin(c21), .s(s1[3]), .cout(cout1));

      always_comb
			begin
			  if (cin == 1'b0)
				begin
						s = s0;
						cout = cout0;
				end
			  else
				begin
						s = s1;
						cout = cout1;
				end
			end

    endmodule

 module fadder (input x, y, cin,
	output s, cout);
		
		assign s = x^y^cin;
		assign cout = (x&y)|(y&cin)|(x&cin);
		
		endmodule