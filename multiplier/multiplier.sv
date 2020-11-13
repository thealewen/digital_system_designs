//This lab was created by Manav Agrawal (manava3) and Alex Wen (acwen2)

module multiplier(input logic Clk, ClearA_LoadB_h, Run_h, Reset_h, 
						input logic [7:0] Din,
						//output logic M, D, //This will go to LEDs for testing the debugging
						output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4,
						output logic [7:0] AVal, BVal
						);
						
		logic addornot, fn, Shift_en, Clear_load, Mthbit, XtoA, clrA, ResetSwitch;
		logic Reset, Run, ClearA_LoadB;
		logic bitB;
		logic [8:0] sumA;
		logic [7:0] A, B;
		
		sync s1(.Clk(Clk), .d(~Reset_h), .q(Reset));
		sync s2(.Clk(Clk), .d(~Run_h), .q(Run));
		sync s3(.Clk(Clk), .d(~ClearA_LoadB_h), .q(ClearA_LoadB));
		
		
		control control1(
			.Clk(Clk), 
			.ClearA_LoadB(ClearA_LoadB), 
			.ResetSwitch(ResetSwitch),
			.Reset(Reset),
			.clrA(clrA),
			.Run(Run), .M(Mthbit),
			.Add(addornot), 
			.Fn(fn), 
			.Shift_En(Shift_en), 
			.Clr_Ld(Clear_load)
		);
		
		Adder9bit adderStoA(
			.A(A), 
			.B(Din[7:0]), 
			.Fn(fn), 
			//.CO(), 
			.S(sumA[8:0])
		);
		
		x_ff regX(
		.Clk(Clk), 
		.Reset(Clear_load | ResetSwitch|clrA), 
		.Load(addornot),
		.D(sumA[8]),
		.Data_Out(XtoA)
		);
		
		reg_8 regA(
			.Clk(Clk), .Reset(ResetSwitch|Clear_load|clrA), .Load(addornot), .Shift_In(XtoA), .Shift_En(Shift_en),
			.D(sumA[7:0]),
			.Shift_Out(bitB),
			.Data_Out(A[7:0])
		);
		
		reg_8 regB(
			.Clk(Clk), .Reset(ResetSwitch), .Load(Clear_load), .Shift_In(bitB), .Shift_En(Shift_en),
			.D(Din[7:0]),
			.Shift_Out(Mthbit),
			.Data_Out(B[7:0])
		);
		
		always_comb
			begin	
				AVal = A;
				BVal = B;
			end
						
		HexDriver		AHex0 (
								.In0(A[3:0]),
								.Out0(HEX2) );
				
		HexDriver		AHex1 (
								.In0(A[7:4]),
								.Out0(HEX3) );
								
		HexDriver		BHex0 (
								.In0(B[3:0]),
								.Out0(HEX0) );
								
		HexDriver		BHex1 (
								.In0(B[7:4]),
								.Out0(HEX1) );
		HexDriver      XReg (
								.In0({3'b0, XtoA}),
								.Out0(HEX4) );
								
endmodule