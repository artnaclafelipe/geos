#ifndef BIOS_H_
#define BIOS_H_

/*some colors for use on video functions*/
#define COLOR_BLACK 	0x00
#define COLOR_BLUE		0x01
#define COLOR_GREEN		0x02
#define COLOR_CYAN		0x03
#define COLOR_RED		0x04
#define COLOR_MAGENTA	0x05
#define COLOR_BROWN		0x06
#define COLOR_LIGHTGRAY	0x07
#define COLOR_DARKGRAY	0x08
#define COLOR_LIGHTBLUE	0x09
#define COLOR_LIGHTGREEN	0x0A
#define COLOR_LIGHTCYAN		0x0B
#define COLOR_LIGHTRED		0x0C
#define COLOR_LIGHTMAGENTA		0x0D
#define COLOR_YELLOW	0x0E
#define COLOR_WHITE	0x0F

/*relative to bios video functions*/	
extern void putc_withcolor(char c,unsigned char color);
void 		putc(char c);
extern unsigned char getCurrentVideoPage();
extern void 		 setCurrentVideoPage(unsigned char page);
extern void 		 setCursorPosition(unsigned char row,unsigned char column);
extern unsigned char getCursorRow();
extern unsigned char getCursorColumn();
void 				 prints(char *str);
void instr_numericformat(unsigned int number,char *where_tosave_convertion);
/*relative to bios keyboard functions*/	

/*relative to bios disk functions*/	
typedef enum {ds=0,es=1,cs=2,ss=3}segment_t;

extern int disk_reset(unsigned char drive);
extern int disk_statusof_lastoperation_drive(unsigned char drive);
extern int disk_readsector(segment_t segment,
						   unsigned char *offset,unsigned char sectors_count,
						   unsigned char drive,unsigned char cylinder,
						   unsigned char head,unsigned char sector);
int disk_readsector_linearly(segment_t segment,
							 unsigned char *offset,unsigned char drive,
							 unsigned int linear_sector);

#endif