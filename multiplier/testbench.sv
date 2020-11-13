module testbench();

timeunit 10ns;

timeprecision 1ns;

logic Clk = 0;
logic Reset_h, ClearA_LoadB_h, Run_h;
logic [7:0] Din;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4; 
logic [7:0] AVal, BVal;
//logic [12:0] Ans;
integer error = 0;

logic [7:0] ans_1a, ans_2a;

multiplier multiplier1(.Clk(Clk), .ClearA_LoadB_h(ClearA_LoadB_h), .Run_h(Run_h), .Reset_h(Reset_h), 
						.Din(Din), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .AVal(AVal), .BVal(BVal));

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

initial begin : RESET
Reset_h = 1;
#2 Reset_h = 0;
#4 Reset_h = 1;
end

always begin: TEST_VECTORS
//Reset_h = 1;
//Reset_h = 0;
//Reset_h = 1;		
ClearA_LoadB_h = 1;
Run_h = 1;
Din = 8'b11111110;
//#2 Reset_h = 1;
#3 ClearA_LoadB_h = 0;	
#3 ClearA_LoadB_h = 1;

#3 Din = 8'b00000111;	

#3 Run_h = 0;	// Toggle Execute
   
#20 Run_h = 1;

/*
Reset_ai = 0;
Reset_ai = 1;
#20 Run_ai = 0;
#20 ClearA_LoadB_ai = 1'b1;
Din = 8'b11110101;
ClearA_LoadB_ai = 1'b0;
Din = 8'b00000111;
Run_ai = 1;*/
/*
//#10 Reset_ai = 1'b1;
#3 ClearA_LoadB_ai = 1'b0;
#3 ClearA_LoadB_ai = 1'b1;
#30 Din = 8'h06; //This is 6;
#40 ClearA_LoadB_ai = 1'b0;
#50 Din = 8'b11110101; //This is -11
#55 Run_ai = 1'b1;
#100 ans_1a = 8'b10111110;
#110 if(BVal != ans_1a)
			error++;
#120	Run_ai = 1'b0;
#110 ClearA_LoadB_ai = 1'b0;
#110 ClearA_LoadB_ai = 1'b1;
#130 Din = 8'hFA; //This is -6;
#140 ClearA_LoadB_ai = 1'b0;
#150 Din = 8'b00001011; //This is 11
#155 Run_ai = 1'b1;
#210 if(BVal != ans_1a)
			error++;
#220	Run_ai = 1'b0;
#310 ClearA_LoadB_ai = 1'b0;
#315 ClearA_LoadB_ai = 1'b1;
#330 Din = 8'h06; //This is 6;
#340 ClearA_LoadB_ai = 1'b0;
#350 Din = 8'b00001011; //This is 11
#355 Run_ai = 1'b1;
#400 ans_2a = 8'b01000010;
#410 if(BVal != ans_2a)
			error++;
#420	Run_ai = 1'b0;
#510 ClearA_LoadB_ai = 1'b0;
#510 ClearA_LoadB_ai = 1'b1;
#530 Din = 8'hFA; //This is -6;
#540 ClearA_LoadB_ai = 1'b0;
#550 Din = 8'b11110101; //This is 11
#555 Run_ai = 1'b1;
#610 if(BVal != ans_2a)
			error++;

//#50 ClearA_LoadB_h = 1;
*/
end

endmodule 


