module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

logic [15:0][31:0] avalon_aes_interface;
logic AES_START, AES_DONE;
logic [127:0] decryptedmessage;
//logic [31:0] dataToWrite;
/*int lowerBound = 0, upperBound = 0;

always_comb
	begin
		dataToWrite = {(AVL_WRITEDATA[31:24])&({8{AVL_BYTE_EN[3]}}), (AVL_WRITEDATA[23:16])&({8{AVL_BYTE_EN[2]}}), (AVL_WRITEDATA[15:8])&({8{AVL_BYTE_EN[1]}}), (AVL_WRITEDATA[7:0])&({8{AVL_BYTE_EN[3]}})};
		
		case(AVL_BYTE_EN)
			4'b1111 : begin
						upperBound = 31;
						lowerBound = 0;
						end
			4'b1100 : begin
						upperBound = 31;
						lowerBound = 16;
						end
			4'b0011 : begin
						upperBound = 15;
						lowerBound = 0;
						end
			4'b1000 : begin
						upperBound = 31;
						lowerBound = 24;
						end
			4'b0100 : begin
						upperBound = 23;
						lowerBound = 16;
						end
			4'b0010 : begin
						upperBound = 15;
						lowerBound = 8;
						end
			4'b0001 : begin
						upperBound = 7;
						lowerBound = 0;
						end
		endcase
	end*/

always_ff @ (posedge CLK)
	begin 
						
		if(RESET)
			for(int i = 0; i<15; i++) begin
				avalon_aes_interface[i]<= 32'h00000000;
			end
		else if(AVL_WRITE && AVL_CS)
		begin
			/*case(AVL_ADDR)
				4'b0000 : avalon_aes_interface[0][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b0001 : avalon_aes_interface[1][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b0010 : avalon_aes_interface[2][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b0011 : avalon_aes_interface[3][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b0100 : avalon_aes_interface[4][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b0101 : avalon_aes_interface[5][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b0110 : avalon_aes_interface[6][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b0111 : avalon_aes_interface[7][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b1000 : avalon_aes_interface[8][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b1001 : avalon_aes_interface[9][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b1010 : avalon_aes_interface[10][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b1011 : avalon_aes_interface[11][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b1100 : avalon_aes_interface[12][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b1101 : avalon_aes_interface[13][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b1110 : avalon_aes_interface[14][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
				4'b1111 : avalon_aes_interface[15][upperBound:lowerBound] <= dataToWrite[upperBound:lowerBound];
			endcase*/
			if(AVL_BYTE_EN[3])
			begin
				avalon_aes_interface[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
			end
			if(AVL_BYTE_EN[2])
			begin
				avalon_aes_interface[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
			end
			if(AVL_BYTE_EN[1])
			begin
				avalon_aes_interface[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
			end
			if(AVL_BYTE_EN[0])
			begin
				avalon_aes_interface[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
			end
			
		end
		else if(AES_DONE == 1'b1) begin
			avalon_aes_interface[15][0] <= 1'b1; 
			avalon_aes_interface[11] <= decryptedmessage[31:0];
			avalon_aes_interface[10] <= decryptedmessage[63:32];
			avalon_aes_interface[9] <= decryptedmessage[95:64];
			avalon_aes_interface[8] <= decryptedmessage[127:96];
		end

	end

always_comb
	begin
		if(AVL_CS == 1'b1)
		begin
			case(AVL_ADDR)
				4'b0000 : AVL_READDATA = avalon_aes_interface[0];
				4'b0001 : AVL_READDATA = avalon_aes_interface[1];
				4'b0010 : AVL_READDATA = avalon_aes_interface[2];
				4'b0011 : AVL_READDATA = avalon_aes_interface[3];
				4'b0100 : AVL_READDATA = avalon_aes_interface[4];
				4'b0101 : AVL_READDATA = avalon_aes_interface[5];
				4'b0110 : AVL_READDATA = avalon_aes_interface[6];
				4'b0111 : AVL_READDATA = avalon_aes_interface[7];
				4'b1000 : AVL_READDATA = avalon_aes_interface[8];
				4'b1001 : AVL_READDATA = avalon_aes_interface[9];
				4'b1010 : AVL_READDATA = avalon_aes_interface[10];
				4'b1011 : AVL_READDATA = avalon_aes_interface[11];
				4'b1100 : AVL_READDATA = avalon_aes_interface[12];
				4'b1101 : AVL_READDATA = avalon_aes_interface[13];
				4'b1110 : AVL_READDATA = avalon_aes_interface[14];
				4'b1111 : AVL_READDATA = avalon_aes_interface[15];
			endcase 
		end
		else 
		begin
			AVL_READDATA = 32'hxxxxxxxx;
		end
	end
	assign EXPORT_DATA[31:16] = avalon_aes_interface[0][31:16];
	assign EXPORT_DATA[7:0] = avalon_aes_interface[3][7:0];
	
	AES aes_decryption(
	.CLK(CLK),
	.RESET(RESET),
	.AES_START(avalon_aes_interface[14][0]),
	.AES_DONE(AES_DONE),
	.AES_KEY({avalon_aes_interface[0], avalon_aes_interface[1], avalon_aes_interface[2], avalon_aes_interface[3]}),
	.AES_MSG_ENC({avalon_aes_interface[4], avalon_aes_interface[5], avalon_aes_interface[6], avalon_aes_interface[7]}),
	.AES_MSG_DEC(decryptedmessage)
	);
endmodule
