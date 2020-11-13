module testbench();

timeunit 10ns;

timeprecision 1ns;

logic	Clk, Run, Continue, OE, WE;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;
logic [9:0] SW;
logic [15:0] PC, IR, MAR, MDR, Data, R0, R1, R2, R3, R4, R5, R6, R7;
logic [4:0] State;

slc3_testtop slc3_testtop0(.*);

assign IR = testbench.slc3_testtop0.slc.IR;
assign PC = testbench.slc3_testtop0.slc.PC_output;
assign MAR = testbench.slc3_testtop0.slc.MAR;
assign MDR = testbench.slc3_testtop0.slc.MDR;
assign State = testbench.slc3_testtop0.slc.state_controller.State;
assign Data = testbench.slc3_testtop0.slc.MDR_In;
assign OE = testbench.slc3_testtop0.slc.OE;
assign WE = testbench.slc3_testtop0.slc.WE;
assign R0 = testbench.slc3_testtop0.slc.d0.eightbysixteenreg.regfile[0];
assign R1 = testbench.slc3_testtop0.slc.d0.eightbysixteenreg.regfile[1];
assign R2 = testbench.slc3_testtop0.slc.d0.eightbysixteenreg.regfile[2];
assign R3 = testbench.slc3_testtop0.slc.d0.eightbysixteenreg.regfile[3];
assign R4 = testbench.slc3_testtop0.slc.d0.eightbysixteenreg.regfile[4];
assign R5 = testbench.slc3_testtop0.slc.d0.eightbysixteenreg.regfile[5];
assign R6 = testbench.slc3_testtop0.slc.d0.eightbysixteenreg.regfile[6];
assign R7 = testbench.slc3_testtop0.slc.d0.eightbysixteenreg.regfile[7];

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin : CLOCK_INITIALIZATION
Clk = 0;
end

always begin : TEST_VECTORS
Run = 0;
Continue = 0;
#5;
Continue = 1;
#5;
SW = 10'b0000110001;
Run = 1;
#160;
Run =1;
Continue=0;
#10;
Run = 0;
Continue = 1;
#15;
Run = 0;
Continue = 1;
#15;
Run = 0;
Continue = 1;
#15;
Run = 1;
Continue = 0;
#15;
Run = 1;
#13;
Run = 1;
Continue = 0;
#15;
Run = 0;
Continue = 1;
#15;
Run = 1;
Continue = 0;
#15;
Run = 0;
Continue = 1;
#300;
Run = 1;
Continue = 0;
#300;
Run = 1;
Continue = 0;
#300;
Run = 1;
Continue = 0;
#300;
Run = 1;
Continue = 0;
#300;
Run = 1;
Continue = 0;
#300;
Run = 1;
Continue = 0;
end

endmodule
