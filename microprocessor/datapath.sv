module datapath(
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED, Clk, Reset,
	input logic GatePC, GateMDR, GateALU, GateMARMUX, //These are for all the gates
	input logic SR2MUX, ADDR1MUX, SR1MUX, DRMUX,
	input logic  MIO_EN,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic [15:0] MDR_In,
	output logic [15:0] MAR, MDR, IR, PC_output,
	output logic [9:0] LED,  
	output logic BEN
	);
	
	logic [15:0] Bus, PCMux_out, IR_out, MDR_out, MDR_input, addr2mux_out, addr1mux_out, sr2mux_out, ALU_SR1_input, ALUK_out, ALU_SR2mux_input;
	logic [2:0] drmux_out, sr1mux_out;
	
	/*
	4 Tri-state notation 
	0001: GatePC (0)
	0010: GateMARMUX (1)
	0100: GatMDR (2)
	1000: GateALU (3)
	*/
	
	tri_mux4to1 gate(
	.select({GateALU, GateMDR, GateMARMUX, GatePC}),
	.din0(PC_output),
	.din1(addr2mux_out + addr1mux_out),//Marmux),
	.din2(MDR_out),
	.din3(ALUK_out),//ALU),
	.out(Bus)
	);

	reg_16 PC(
	.Clk(Clk), .Reset(Reset), .Load(LD_PC),
	.D(PCMux_out), .Data_Out(PC_output)
	);
	
	mux4to1 pcmux(
	.select(PCMUX),
	.din0(PC_output + 1'b1),
	.din1(addr2mux_out + addr1mux_out),//arithmetic logic unit),
	.din2(Bus),
	.din3(),//We don't need this),
	.out(PCMux_out)
	);
	
	reg_16 IR_reg(
	.Clk(Clk),
	.Reset(Reset),
	.Load(LD_IR),
	.D(Bus),
	.Data_Out(IR_out)
	);
	
	reg_16 MAR_reg(
	.Clk(Clk),
	.Reset(Reset),
	.Load(LD_MAR),
	.D(Bus),
	.Data_Out(MAR)
	);
	
	reg_16 MDR_reg(
	.Clk(Clk),
	.Reset(Reset),
	.Load(LD_MDR),
	.D(MDR_input),
	.Data_Out(MDR_out)
	);
	
	mux2to1 mio(
	.select(MIO_EN),
	.din0(Bus),
	.din1(MDR_In),
	.out(MDR_input)
	);
	
	mux4to1 addr2mux(
	.select(ADDR2MUX),
	.din0(16'h0000),
	.din1({{10{IR_out[5]}}, IR_out[5:0]}),
	//16'(signed'(IR[5:0]))
	.din2({{7{IR_out[8]}}, IR_out[8:0]}),
	.din3({{5{IR_out[10]}}, IR_out[10:0]}),
	.out(addr2mux_out)
	);
	
	mux2to1 addr1mux(
	.select(ADDR1MUX),
	.din0(PC_output),
	.din1(ALU_SR1_input),
	.out(addr1mux_out)
	);
	
	mux2to1 sr2mux(
	.select(SR2MUX),
	.din0(ALU_SR2mux_input),
	.din1({{11{IR_out[4]}}, IR_out[4:0]}),
	.out(sr2mux_out)
	);
	
	ALUKa aluk1(
	.select(ALUK),
	.A(ALU_SR1_input),
	.B(sr2mux_out),
	.S(ALUK_out)
	);
	
	mux2to13 drmux(
	.select(DRMUX),
	.din0(IR_out[11:9]),
	.din1(3'b111),
	.out(drmux_out)
	);
	
	mux2to13 sr1mux(
	.select(SR1MUX),
	.din0(IR_out[11:9]),
	.din1(IR_out[8:6]),
	.out(sr1mux_out)
	);
	
	nzpreg nzpben(
	.Reset(Reset), .Load(LD_CC), .Clk(Clk),
	.NZP(IR_out[11:9]),
	.buslogic(Bus),
	.Load_Ben(LD_BEN),
	.n(), .z(), .p(), .BEN(BEN)
	);
	
	regfile eightbysixteenreg(
		.ldreg(LD_REG), .Reset(Reset), .Clk(Clk),
		.drmux(drmux_out), .sr1mux(sr1mux_out), .sr2input(IR_out[2:0]),
		.bus(Bus),
		.sr1(ALU_SR1_input), .sr2(ALU_SR2mux_input)
	);

	always_comb
		begin
		IR = IR_out;
		MDR = MDR_out;
		end
	assign LED[9:0] = IR_out[9:0];
	
	endmodule