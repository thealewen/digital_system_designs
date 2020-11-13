module nzpreg(
	input Reset, Load, Load_Ben, Clk,
	input [2:0] NZP,
	input [15:0] buslogic,
	
	output logic n, z, p, BEN
);

	logic tempN, tempP, tempZ;
	
	always_ff @ (posedge Clk)
	begin 
		if(Reset) begin
			BEN <=1'b0;
			n<=0;
			z<=0;
			p<=0;
		end
		
		else if(Load_Ben) begin
			if ((NZP[2]&n==1'b1)||(NZP[1]&z==1'b1)||(NZP[0]&p == 1'b1))
				BEN <= 1;
			else
				BEN <= 0;
		end
		if(Load) begin
			n <= tempN;
			z <= tempZ;
			p <= tempP;
		end
	end
	
	/*always_ff @ (posedge Clk)
	begin
		if(Reset)
			BEN<=0;
		else if (Load_Ben) begin
			if(NZP && {n, z, p} == 3'b000) 
				BEN <= 0;
			else 
				BEN <= 1;
		end
	end*/
	
	always_comb begin
			if(buslogic[15]==1) begin
				tempN=1'b1;
				tempZ=1'b0;
				tempP=1'b0;
			end
			else if(buslogic[15:0]==16'h0000) begin
				tempN=1'b0;
				tempZ=1'b1;
				tempP=1'b0;
			end
			else begin
				tempN=1'b0;
				tempZ=1'b0;
				tempP=1'b1;
			end
	end
endmodule
