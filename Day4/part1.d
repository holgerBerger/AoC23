// straight forward part 1 solution, all manual parsing

import std.stdio;
import std.ascii;
import std.algorithm;

int getpoints(char[] line) {
    int pos=0;
    char lc,c;
    int value, number;
    bool[int] numbers;

    line ~= " |";

    while(line[pos]!=':') pos++; pos++;
    
    while((c=line[++pos])!='|') {
        if (isDigit(c)) number=number*10+c-'0';
        else {
            if(number>0) numbers[number]=true;
            number=0;
        }    
    }

    while((c=line[++pos])!='|') {
        if (isDigit(c)) number=number*10+c-'0';
        else {
            if(number>0) {
                if (number in numbers) 
                    (value==0) ? (value=1) : (value*=2); 
                number=0;
            }
        }    
    }
    
    return value;
}

void main() {
    stdout.writeln(stdin.byLine.map!getpoints.sum);
}

