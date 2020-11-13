module testbench();

timeunit 10ns;

timeprecision 1ns;

logic CLK;
logic RESET;/*
logic AES_START;
logic AES_DONE;
logic [127:0] AES_KEY;
logic [127:0] AES_MSG_ENC;
logic [127:0] AES_MSG_DEC;*/

logic AVL_READ;					// Avalon-MM Read
logic AVL_WRITE;					// Avalon-MM Write
logic AVL_CS;					// Avalon-MM Chip Select
logic [3:0] AVL_BYTE_EN;		// Avalon-MM Byte Enable
logic [3:0] AVL_ADDR;			// Avalon-MM Address
logic [31:0] AVL_WRITEDATA;	// Avalon-MM Write Data
logic [31:0] AVL_READDATA;
logic [31:0] EXPORT_DATA;

//AES aes0(.*);
avalon_aes_interface aai0(.*);

always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin : CLOCK_INITIALIZATION
CLK = 0;
end
/*
always begin : TEST_VECTORS
#2 RESET = 0;
#2 RESET = 1;
#2 RESET = 0;
AES_START = 0;
#2;
AES_KEY = 128'h000102030405060708090a0b0c0d0e0f;
#100;
AES_START = 1;
AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
#10000;
end*/

always begin : TEST_VECTORS
AVL_CS = 1'b1;
AVL_BYTE_EN = 4'b1111;
#2 RESET = 0;
#2 RESET = 1;
#2 RESET = 0;
#2;
AVL_WRITE = 1'b1;
AVL_READDATA = 1'b1;
#2;
AVL_ADDR = 4'b0000;
AVL_WRITEDATA = 32'h00010203;
#5;
AVL_ADDR = 4'b0001;
AVL_WRITEDATA = 32'h04050607;
#5;
AVL_ADDR = 4'b0010;
AVL_WRITEDATA = 32'h08090a0b;
#5;
AVL_ADDR = 4'b0011;
AVL_WRITEDATA = 32'h0c0d0e0f;
#5;
AVL_ADDR = 4'b0100;
AVL_WRITEDATA = 32'hdaec3055;
#5;
AVL_ADDR = 4'b0101;
AVL_WRITEDATA = 32'hdf058e1c;
#5;
AVL_ADDR = 4'b0110;
AVL_WRITEDATA = 32'h39e814ea;
#5;
AVL_ADDR = 4'b0111;
AVL_WRITEDATA = 32'h76f6747e;
#5;
AVL_ADDR = 4'b1110;
AVL_WRITEDATA = 32'h00000001;
#500;
AVL_WRITE = 1'b0;
AVL_READ = 1'b1;
AVL_ADDR = 4'b1000;
#5;
AVL_READ = 1'b1;
AVL_ADDR = 4'b1001;
#10000;
end

endmodule
