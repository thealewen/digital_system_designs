/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

logic [1407:0] KeySchedule;
logic [127:0] shiftin, shiftout, stateTerm, invsubbytes_output, stateInput, addoutput;
logic [31:0] inmix, outmix;
logic [15:0] ques[8:0];
logic [15:0] ans[8:0];
logic [3:0] counter;
logic [1:0] step, word_sl;
logic load_message;


KeyExpansion key_schedule(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KeySchedule));
InvShiftRows invshiftrow(.data_in(stateInput), .data_out(shiftout));

//InvSubBytes inv_sub[15:0] (ques, ans);	 

InvSubBytes lowpos0(.clk(CLK), .in(stateInput[7:0]), .out(invsubbytes_output[7:0]));
InvSubBytes lowpos1(.clk(CLK), .in(stateInput[15:8]), .out(invsubbytes_output[15:8]));
InvSubBytes lowpos2(.clk(CLK), .in(stateInput[23:16]), .out(invsubbytes_output[23:16]));
InvSubBytes lowpos3(.clk(CLK), .in(stateInput[31:24]), .out(invsubbytes_output[31:24]));
InvSubBytes lowpos4(.clk(CLK), .in(stateInput[39:32]), .out(invsubbytes_output[39:32]));
InvSubBytes lowpos5(.clk(CLK), .in(stateInput[47:40]), .out(invsubbytes_output[47:40]));
InvSubBytes lowpos6(.clk(CLK), .in(stateInput[55:48]), .out(invsubbytes_output[55:48]));
InvSubBytes lowpos7(.clk(CLK), .in(stateInput[63:56]), .out(invsubbytes_output[63:56]));
InvSubBytes lowpos8(.clk(CLK), .in(stateInput[71:64]), .out(invsubbytes_output[71:64]));
InvSubBytes lowpos9(.clk(CLK), .in(stateInput[79:72]), .out(invsubbytes_output[79:72]));
InvSubBytes lowpos10(.clk(CLK), .in(stateInput[87:80]), .out(invsubbytes_output[87:80]));
InvSubBytes lowpos11(.clk(CLK), .in(stateInput[95:88]), .out(invsubbytes_output[95:88]));
InvSubBytes lowpos12(.clk(CLK), .in(stateInput[103:96]), .out(invsubbytes_output[103:96]));
InvSubBytes lowpos13(.clk(CLK), .in(stateInput[111:104]), .out(invsubbytes_output[111:104]));
InvSubBytes lowpos14(.clk(CLK), .in(stateInput[119:112]), .out(invsubbytes_output[119:112]));
InvSubBytes lowpos15(.clk(CLK), .in(stateInput[127:120]), .out(invsubbytes_output[127:120]));

AddRoundKey addr1(.State(stateInput[127:0]), .KeyExp(KeySchedule), .Round(counter), .data_out(addoutput));
always_comb begin
	stateTerm = stateInput;
	unique case(step)
		2'b00: stateTerm = addoutput;
		2'b01: stateTerm = shiftout;
		2'b10: stateTerm = invsubbytes_output;
		2'b11: begin
					unique case(word_sl)
					2'b00: stateTerm[31:0] = outmix;
					2'b01: stateTerm[63:32] = outmix;
					2'b10: stateTerm[95:64] = outmix;
					2'b11: stateTerm[127:96] = outmix;
					endcase 
			end
	endcase
	unique case(word_sl)
		2'b00: inmix = stateInput[31:0];
		2'b01: inmix = stateInput[63:32];
		2'b10: inmix = stateInput[95:64];
		2'b11: inmix = stateInput[127:96];
	endcase
end

InvMixColumns invmix(.in(inmix), .out(outmix));


AES_Controlsm state_machine(.*); 

always_ff @(posedge CLK) begin
	if(RESET) begin
		stateInput <= 128'd0;
		load_message <= 1'b1;
	end
	else if(AES_START && load_message) begin
		stateInput <= AES_MSG_ENC;
		load_message <=1'b0;
	end
	else if(AES_START && ~load_message) begin
		stateInput <= stateTerm;
		load_message <=1'b0;
		AES_MSG_DEC<=stateTerm;

	end
	else if(~AES_START) begin
		stateInput<=stateTerm;
		AES_MSG_DEC<=stateTerm;
	end
	else begin
		stateInput <= 128'd0;
	end
end
	
endmodule
