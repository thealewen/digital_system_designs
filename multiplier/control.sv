module control (input  Clk, Reset, ClearA_LoadB, Run, M,
                output logic Shift_En, Clr_Ld, Add, Fn, ResetSwitch, clrA);
					
enum logic [4:0] {Hold, S1, S2, S3, S4, S5, S6, S7, S8, M1, M2, M3, M4, M5, M6, M7, M8, restart, ClearXA_LoadB, InitialS, Finished} curr_state, next_state;

always_ff @ (posedge Clk or posedge Reset)  
    begin
        if (Reset)
            curr_state = restart;
        else 
            curr_state = next_state;
    end
	 
always_comb
begin
	next_state = curr_state;
	
	unique case (curr_state)
		restart:			next_state = Hold;
		ClearXA_LoadB: 	next_state = Hold;
		Hold: 	if(Run)
						next_state = InitialS;
					else if(ClearA_LoadB)
						next_state = ClearXA_LoadB;
						
		InitialS: 	next_state = M1;
			M1:	next_state = S1;
			S1 : 	next_state = M2;
			M2:	next_state = S2;
			S2 :   next_state = M3;
			M3:	next_state = S3;
			S3:   next_state = M4;
			M4:	next_state = S4;
			S4:   next_state = M5;
			M5:	next_state = S5;
			S5:   next_state = M6;
			M6:	next_state = S6;
			S6:   next_state = M7;
			M7:	next_state = S7;
			S7:   next_state = M8;
			M8:	next_state = S8;
			S8: 	next_state = Finished;
		Finished :	if(~Run) next_state = Hold;
	endcase

end

always_comb
begin 
	case (curr_state)
		restart:
			begin
				Shift_En = 1'b0;
				Clr_Ld = 1'b0;
				
				ResetSwitch = 1'b1;
				
				Add = 1'b0;
				Fn = 1'b0;
				clrA = 1'b0;
			end
		ClearXA_LoadB:
			begin
				Add = 1'b0;
				Fn = 1'b0;
				clrA = 1'b0;
				ResetSwitch = 1'b0;
				Shift_En = 1'b0;
				Clr_Ld = 1'b1;
				
			end
		
		M1, M2, M3, M4, M5, M6, M7:
			begin
				ResetSwitch = 1'b0;
				Shift_En = 1'b0;
				Clr_Ld = 1'b0;
				Fn = 1'b0;
				clrA = 1'b0;
				
				if(M)
					Add = 1'b1;
				else
					Add = 1'b0;
			end
		
		M8:
			begin
				ResetSwitch = 1'b0;
				Shift_En = 1'b0;
				Clr_Ld = 1'b0;
				Fn = M;
				clrA = 1'b0;
				
				if(M)
					Add = 1'b1;
				else
					Add = 1'b0;
			end
			
		S1, S2, S3, S4, S5, S6, S7, S8:
			begin
			
				Shift_En = 1'b1;
				Clr_Ld = 1'b0;
				Fn = 1'b0;
				ResetSwitch = 1'b0;
				
				Add = 1'b0;
				clrA = 1'b0;
			end
			
		InitialS:
			begin
				Clr_Ld = 1'b0;
				Add = 1'b0;
				Fn = 1'b0;
				clrA = 1'b1;
				ResetSwitch = 1'b0;
				Shift_En = 1'b0;
				
			end
		Hold:
			begin
				ResetSwitch = 1'b0;
				Shift_En = 1'b0;
				Clr_Ld = 1'b0;
				Add = 1'b0;
				Fn = 1'b0;
				clrA = 1'b0;
			end
		Finished:
			begin
				clrA = 1'b0;
				ResetSwitch = 1'b0;
				Shift_En = 1'b0;
				Fn = 1'b0;
				Clr_Ld = 1'b0;
				Add = 1'b0;
			end
			
		default:
			begin
				Clr_Ld = 1'b0;
				Add = 1'b0;
				Fn = 1'b0;
				clrA= 1'b0;
				ResetSwitch = 1'b0;
				Shift_En = 1'b0;
			end
	endcase
end
endmodule	