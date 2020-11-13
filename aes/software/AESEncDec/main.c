/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000000;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */

void subBytes(unsigned char* state){
	for(int i = 0; i<16; i++){
			state[i] = aes_sbox[(unsigned char)state[i]];
	}
}

void shiftRow(unsigned char* state){
	for(int i = 0; i<4; i++){
		if(i==1){
			unsigned char temp = state[1];
			for(int j = 0; j<3; j++){
				state[4*j+1] = state[4*(j+1)+1];
			}
			state[13] = temp;
		}
		if(i ==2){
			unsigned char tempSecF = state[2];
			unsigned char tempSecS = state[6];
			for(int j = 0; j<2; j++) state[4*j+2] = state[4*(j+2)+2];
			state[10] = tempSecF;
			state[14] = tempSecS;
		}
		if(i == 3){
			unsigned char temp = state[15];
			for(int j = 3; j>0; j--) state[(4*j)+3] = state[4*(j-1)+3];
			state[3] = temp;
		}
	}
}

void mixColumns(unsigned char* tem){
	unsigned char temp[4][4];
	unsigned char state[4][4];
	for(int i = 0; i<4; i++){
		for(int j = 0; j<4; j++){
			temp[i][j] = tem[4*j+i];
		}
	}
	for(int i = 0; i<4; i++){
		if(i==0){
			for(int j = 0; j<4; j++){
				state[0][j] = gf_mul[(unsigned char)temp[0][j]][0] ^ gf_mul[(unsigned char)temp[1][j]][1] ^ temp[2][j] ^ temp[3][j];
			}
		}
		if(i==1){
			for(int j = 0; j<4; j++){
				state[1][j] = temp[0][j] ^ gf_mul[(unsigned char)temp[1][j]][0] ^ gf_mul[(unsigned char)temp[2][j]][1] ^ temp[3][j];
			}
		}
		if(i==2){
			for(int j = 0; j<4; j++){
				state[2][j] = temp[0][j] ^ temp[1][j] ^ gf_mul[(unsigned char)temp[2][j]][0] ^ gf_mul[(unsigned char)temp[3][j]][1];
			}
		}
		if(i == 3){
			for(int j = 0; j<4; j++){
				state[3][j] = gf_mul[(unsigned char)temp[0][j]][1]^ temp[1][j] ^ temp[2][j] ^ gf_mul[(unsigned char)temp[3][j]][0];
			}
		}

	}
		for(int i = 0; i<4; i++){
			for(int j = 0; j<4; j++){
				tem[4*j+i] = state[i][j];
			}
		}
}

void keyExpansion(unsigned char keyText[][44]){
	for(int j = 4; j<44; j++){
		if(j%4 == 0){
			unsigned char temp = keyText[0][j-1];
			for(int i = 0; i<3; i++) keyText[i][j] = keyText[i+1][j-1];
			keyText[3][j] = temp;

			for(int i = 0; i<4; i++){
				//printf(" %x ", keyText[i][j]);
				keyText[i][j] = aes_sbox[keyText[i][j]];
			}
			//printf(" %x, %x, %x, %x ", keyText[0][j], keyText[1][j], keyText[2][j], keyText[3][j] );

			for(int i = 0; i<4; i++){
				if(i == 0) keyText[i][j] = keyText[i][j] ^ (unsigned char)(Rcon[j/4]>>24) ^ keyText[i][j-4];
				else keyText[i][j] = keyText[i][j] ^ keyText[i][j-4];
			}
		}
		else for(int i = 0; i<4; i++) keyText[i][j] = keyText[i][j-1] ^ keyText[i][j-4];
	}
}

void addRoundKey(char* state, char* word){
	for(int i = 0; i<16; i++){
		state[i] = state[i]^word[i];
	}
}

char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

void printState(unsigned char keyText[][44]){
	for(int i = 0; i<4; i++){
		for(int j = 0; j<4; j++){
			printf(" %x ", (unsigned char)keyText[i][j]);
		}
		printf("\n");
	}
}

void printKeys(unsigned char keyText[][44]){
	for(int i = 0; i<4; i++){
		for(int j = 0; j<44; j++){
			printf(" %x ", (unsigned char)keyText[i][j]);
		}
		printf("\n");
	}
}

void printWord(char *word){
	for(int j = 0; j<4; j++){
		for(int i = 0; i<4; i++){
			printf(" %x ", (unsigned char) word[j + 4*i]);
		}
		printf("\n");
	}
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function

	//char state[4][4];
	unsigned char keyText[4][44];
	char initKey[16];
	/*for(int i = 0; i<4; i++){
		for(int j = 0; j<4; j++){
		state[i][j] = charsToHex(msg_ascii[2*(j+(4*i))], msg_ascii[2*(j+(4*i))+1]);
		printf("%c%c ", msg_ascii[2*(j+(4*i))], msg_ascii[2*(j+(4*i))+1]);
		keyText[i][j] = charsToHex(key_ascii[j+(4*i)], key_ascii[j+(4*i)+1]);
		}
	}*/
	//ece298dcece298dcece298dcece298dc
	//000102030405060708090a0b0c0d0e0f
	char state[16];
	for(int i = 0; i<16; i++){
		state[i] = charsToHex(msg_ascii[2*i], msg_ascii[2*i+1]);
		initKey[i] = charsToHex(key_ascii[2*i], key_ascii[2*i+1]);
	}
	//printf("State \n");
	//printWord(state);
	//printWord(initKey);

	for(int i = 0; i<4; i++){
		for(int j = 0; j<4; j++) {
			keyText[i][j] = initKey[4*j+i];
		}
	}
	//printf("Big Array 4x4\n");
	keyExpansion(keyText);
	//printKeys(keyText);
	char word[16];
	for(int k = 0; k<16; k++) word[k] = keyText[k%4][k/4];
	//printf("Key \n");
	//printWord(word);
	addRoundKey(state, word);
	for(int i = 1; i<10; i++){
		subBytes(state);
			//printf("State \n");
			//printWord(state);
		shiftRow(state);
			//printf("State \n");
			//printWord(state);
		mixColumns(state);
			//printf("State \n");
			//printWord(state);
		for(int k = 0; k<16; k++) word[k] = keyText[k%4][4*i + k/4];
		//printf("Key \n");
		//printWord(word);
		addRoundKey(state, word);
		//printf("State \n");
		//printWord(state);
	}
	subBytes(state);
	shiftRow(state);
	for(int k = 0; k<16; k++) word[k] = keyText[k%4][40 + k/4];
	addRoundKey(state, word);
	//printWord(state);
	//printWord(word);
	//out = state;*/
	for(int i = 0; i<4; i++){
		msg_enc[i] = ((unsigned char)state[i*4]<<24)+ ((unsigned char)state[i*4+1]<<16)+((unsigned char)state[i*4+2]<<8)+((unsigned char)state[i*4+3]);
		key[i] = (initKey[i*4]<<24)+ (initKey[i*4+1]<<16)+(initKey[i*4+2]<<8)+(initKey[i*4+3]);
	}
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
	/*printf("%08x", AES_PTR[15]);
	AES_PTR[4] = msg_enc[0];
	AES_PTR[5] = msg_enc[1];
	AES_PTR[6] = msg_enc[2];
	AES_PTR[7] = msg_enc[3];
	AES_PTR[14] = 0x00000001;

	printf("%08x", AES_PTR[15]);
	while(AES_PTR[15]==0x00000000);
	AES_PTR[14] = 0x00000000;
	printf("Reached here");
	msg_dec[0] = AES_PTR[8];
	msg_dec[1] = AES_PTR[9];
	msg_dec[2] = AES_PTR[10];
	msg_dec[3] = AES_PTR[11];
	for(int i = 0; i<=15; i++){
			printf("%08x", AES_PTR[i]);
			printf("\n");
	}*/
	while (AES_PTR[15] == 0x00000000) {}
	msg_dec[0] = AES_PTR[8];
	msg_dec[1] = AES_PTR[9];
	msg_dec[2] = AES_PTR[10];
	msg_dec[3] = AES_PTR[11];
	AES_PTR[14] = 0x000000000;
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main(){
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	/*AES_PTR[10] = 0xDEADBEEF;
	printf("%x", AES_PTR[10]);
	if (AES_PTR[10] != 0xDEADBEEF){
		printf("Error!");
	}*/
	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);

			printf("\nEncrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			AES_PTR[0] = key[0];
			AES_PTR[1] = key[1];
			AES_PTR[2] = key[2];
			AES_PTR[3] = key[3];
			AES_PTR[4] = msg_enc[0];
			AES_PTR[5] = msg_enc[1];
			AES_PTR[6] = msg_enc[2];
			AES_PTR[7] = msg_enc[3];
			AES_PTR[14] = 0x000000001;
			printf("\n");
			decrypt(msg_enc, msg_dec, key);

			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
