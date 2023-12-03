// AoC day1, C, touch each input byte only once
#include <ctype.h>
#include <stdio.h>
#include <string.h>

char* digits[] = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};
int wordpos[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };

int match_in_word(int c) {
	int match=0;
	for(int cw=0; cw<9; cw++) {
		if (digits[cw][wordpos[cw]]==c) wordpos[cw]++;
		else {
			if(digits[cw][0]==c) 
				wordpos[cw]=1;
			else
				wordpos[cw]=0;
		}
		if (digits[cw][wordpos[cw]]==0) {
			wordpos[cw]=0;
			match=cw+1;
		}
	}
	return match;
}

int main(void) {
	int ldig, fdig = -1;
	int c, sum = 0;
	int wd;
	
	while ((c=fgetc(stdin))!=EOF) {
		if (wd=match_in_word(c)) {
			ldig=wd;
			if (fdig==-1) fdig=ldig;
		}
		if (isdigit(c)) {
			ldig=c-'0';
			if (fdig==-1) fdig=ldig;
		} else if (c=='\n') {
			sum += 10*fdig + ldig;
			fdig = -1;
			memset(wordpos, 0, 9*sizeof(int));
		}
	} 
	printf("sum=%d\n", sum);
}
