module reg_8( input Clk, Reset, Load, Shift_In, Shift_En,
					input [7:0] D,
					output logic Shift_Out,
					output logic [7:0] Data_Out);
					
					always_ff @ (posedge Clk or posedge Reset)
					begin 
						
						if(Reset)
							Data_Out <= 8'b00000000;
							
						else if(Load)
							Data_Out <= D;
							
						else if(Shift_En)
							Data_Out <= {Shift_In, Data_Out[7:1]};
						
							
					end
					
					assign Shift_Out = Data_Out[0];
					
endmodule

module x_ff(input Clk, Reset, Load,
			input D,
			output logic Data_Out);
			logic din; 
			
			always_ff @ (posedge Clk)
			begin
				Data_Out <= din;
			end
			
			always_comb begin 
				if(Reset)
					din = 1'b0;
				else if(Load)
					din = D;
				else
					din = Data_Out;
			end 
endmodule
