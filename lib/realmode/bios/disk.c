#include "bios.h"


int teste_readsector(){
	segment_t seg = ds;
	char buf[512];
	
	unsigned char *offset = &buf;
	unsigned char sectors_count = 1;
	unsigned char drive = 0x00;
	unsigned char cylinder = 0;
	unsigned char head = 0;
	unsigned char sector = 1;
	int res;

	return res;
	
}

int disk_readsector_linearly(segment_t segment,
							 unsigned char *offset,unsigned char drive,
							 unsigned int linear_sector)
{
/*	extern int disk_readsector(segment_t segment,
						   unsigned char *offset,unsigned char sectors_count,
						   unsigned char drive,unsigned char cylinder,
						   unsigned char head,unsigned char sector);
*/
	unsigned char sector,cylinder,head;
	cylinder = (linear_sector/36);
	head = ((linear_sector)%36)/18;
	sector = (((linear_sector)%36)%18);
	return disk_readsector(segment,offset,1,drive,cylinder,head,sector);
}
