// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng and Manav Agrawal

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x40; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here

	/*volatile unsigned int *LED_PIO = (unsigned int*)0x40;
	volatile unsigned int *SW = (unsigned int*)0x60;
	volatile unsigned int *BUTTON = (unsigned int*)0x80;
	int flag = 0;

	while( (1+1)!=3){
		if(*BUTTON == 1 && flag == 0){
			*LED_PIO += *SW;
			flag = 1;
		}
		if(*BUTTON == 3) flag = 0;
	}
	return 1;*/
}
