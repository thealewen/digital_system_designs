module lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     S,
    output  logic           CO
);

    /* Carry Lookahead Adder 
	 * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
      logic [4:0] C;
      logic [3:0] G, P;

      assign C[0] = 0;

      fourbitcla RA0(.x(A[3:0]), .y(B[3:0]), .cin(C[0]), .s(S[3:0]), .gg(G[0]), .pg(P[0])); 
		assign C[1] = G[0] | P[0]&C[0];
		
      fourbitcla RA1(.x(A[7:4]), .y(B[7:4]), .cin(C[1]), .s(S[7:4]), .gg(G[1]), .pg(P[1]));
		assign C[2] = G[1] | P[1]&C[1];
		
      fourbitcla RA2(.x(A[11:8]), .y(B[11:8]), .cin(C[2]), .s(S[11:8]), .gg(G[2]), .pg(P[2]));
		assign C[3] = G[2] | P[2]&C[2];
		
		
      fourbitcla RA3(.x(A[15:12]), .y(B[15:12]), .cin(C[3]), .s(S[15:12]), .gg(G[3]), .pg(P[3]));
		assign C[4] = G[3] | P[3]&C[3];
		
		assign CO = C[4];


endmodule

module fourbitcla
(
  input [3:0] x,
  input [3:0] y,
  input cin,
  output logic [3:0] s,
  output logic gg, pg //Generate and propagate signal
);

  logic [4:0] C;
  logic [3:0] G, P;

  always_comb begin
    for(int i = 0 ; i<4; i=i+1) begin
      G[i] = x[i] & y[i];
      P[i] = x[i] ^ y[i];
    end
    C[0] = cin;
    for(int i = 1 ; i<4; i=i+1) begin
      C[i] = G[i-1] | (P[i-1] & C[i-1]);
    end
  end

	adder a0(.x(x[0]), .y(y[0]), .cin(C[0]), .s(s[0]));
	adder a1(.x(x[1]), .y(y[1]), .cin(C[1]), .s(s[1]));
	adder a2(.x(x[2]), .y(y[2]), .cin(C[2]), .s(s[2]));
	adder a3(.x(x[3]), .y(y[3]), .cin(C[3]), .s(s[3]));
	assign pg = (P[3]&P[2]&P[1]&P[0]); //This is the propagate signal
	assign gg = (G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1])); //This is the generate signal

endmodule

module adder
(
 input x,
input y,
input cin,
output logic s
);
	assign s = x ^ y ^ cin;
endmodule