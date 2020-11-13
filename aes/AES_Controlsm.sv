module AES_Controlsm (
	input logic CLK, RESET, AES_START,
	output logic AES_DONE,
	output logic [3:0] counter,
	output logic [1:0] word_sl, step
);

enum logic[4:0]{WAIT, DONE, addroundkey, inverseshiftrow, invmixcolumns1, invmixcolumns2, invmixcolumns3,
invmixcolumns4, invsubbytes, HOLD} current, next;

logic [3:0] countnext;
logic load_message;

always_ff@(posedge CLK) begin
	if(RESET) begin
		current <= WAIT;
		counter <= 4'd0;
		load_message<=1'b1;
	end
	else if(AES_START && load_message) begin
		current <= next;
		counter <= countnext;
		load_message<=1'b0;
	end
	else if(AES_START && ~load_message) begin
		current <= next;
		counter <= countnext;
	end
	else if(~AES_START && ~load_message) begin
		current <= next;
		counter <= countnext;
	end
end
	
	always_comb
		begin
		next = current;
		
		unique case (current)
		WAIT: if(AES_START)
					begin
						next = addroundkey;
					end
				else begin
						next = WAIT;
					end
		addroundkey:if(counter == 4'd10) begin
						next = DONE;
					end
					else if(counter == 4'd00) begin
						next = inverseshiftrow;
					end
					else begin 
						next = invmixcolumns1;
					end
		inverseshiftrow: next = invsubbytes;
		invsubbytes: next = addroundkey;
		invmixcolumns1: next = invmixcolumns2;
		invmixcolumns2: next = invmixcolumns3;
		invmixcolumns3: next = invmixcolumns4;
		invmixcolumns4: next = inverseshiftrow;
		DONE: if(AES_START) begin
					next = DONE;
				end
				else begin
					next = WAIT;
				end
		endcase
		end
		
	always_comb begin
		countnext = counter;
		AES_DONE = 1'b0;
		word_sl = 2'bZZ;
		step = 2'bZZ;
		case(current)
			WAIT: begin
						AES_DONE = 1'b0;
						countnext = 1'b0;
					end
		addroundkey:
			begin
				if(counter != 4'd10) begin
					countnext = counter + 4'd1;
				end
				step = 2'b00;
			end
		inverseshiftrow: step = 2'b01;
		invsubbytes: step = 2'b10;
		invmixcolumns1: 
			begin
				step = 2'b11;
				word_sl = 2'b00;
			end
		invmixcolumns2: 
			begin
				step = 2'b11;
				word_sl = 2'b01;
			end
		invmixcolumns3: 
			begin
				step = 2'b11;
				word_sl = 2'b10;
			end
		invmixcolumns4: 
			begin
				step = 2'b11;
				word_sl = 2'b11;
			end
		DONE: AES_DONE = 1'b1;
		endcase
	end
	
		
endmodule
