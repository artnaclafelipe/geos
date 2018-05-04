#include "bios.h"

void prints(char *str){
	for(;(*str!=0);str++)putc((*str));
}

void putc(char c){
	putc_withcolor(c,COLOR_LIGHTGRAY);
}

void instr_numericformat(unsigned int number,char *where_tosave_convertion){
		unsigned char  number_processed_total=0;
		char	       digits[20];
        unsigned char  number_processed = 0;
        unsigned int  division = number;
        unsigned int  division_rest = (division % 10);

        register i=0;
        for(;i<20;i++)digits[i]=0;

        do{
                division_rest+=48;
                digits[number_processed]=division_rest;
                number_processed++;
                division = (division/10);
                division_rest = (division%10);                                
        }while(division!=0);

        number_processed_total=number_processed;
       	number_processed--;
       	i=0;
        while(i<number_processed_total){
                *(where_tosave_convertion+i)=digits[number_processed];
                --number_processed;
	               ++i;
	   }
            
}