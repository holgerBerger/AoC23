// touch each input byte only once
#include <ctype.h>
#include <stdio.h>

int main(void) {
	int fdig = -1, ldig;
	int c, sum = 0;
	
	while ((c=fgetc(stdin))!=EOF) {
		if (isdigit(c)) {
			ldig=c-'0';
			if (fdig==-1) fdig=ldig;
		} else if (c=='\n') {
			sum += 10*fdig + ldig;
			fdig = -1;
		}
	} 
	printf("sum=%d\n", sum);
}
