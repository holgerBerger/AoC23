// D solution for part2, using a small ringbuffer to keep track of card copies
// data touched only once, no large arrays

import std.stdio;
import std.ascii;
import std.algorithm;

int[] future = [1]; // ringbuffer, first cards exists once
int fbase;          // base index in ring buffer

// get a number from line, return 0 for |
@safe nothrow int getnumber(ref int pos, ref char[] line) {
    int number;
    char c;
    while(!isDigit(line[pos]) && line[pos]!='|') pos++;
    if (line[pos]=='|' ) return 0;

    while(isDigit(c=line[pos])) {
        number=number*10+c-'0';
        pos++;
    }
    return number;
}

@safe nothrow int getpoints(char[] line) {
    int pos=0;
    char lc,c;
    int copies, number,cardnr,hits;
    bool[int] numbers;
    int maxhits;

    copies=future[fbase++];  // this is how often this card exists

    line ~= " |";   //  add termination at end of line

    cardnr = getnumber(pos, line);
    
    maxhits=1;
    // winner numbers
    while((number=getnumber(pos, line))!=0) {
        maxhits++;
        numbers[number]=true;    
    }

    // in first pass here, we allocate the ring buffer, we now know how many hits there might be
    if (future.length==1) {
        future.length = maxhits;
        for(int i=0; i<maxhits; i++)
            future[i]=1;
    }

    // skip |
    pos++;

    // numbers
    while((number=getnumber(pos, line))!=0) {
        if (number in numbers) hits++;
    }
    
    if (fbase==maxhits) fbase-=maxhits; // wrap the base pointer
    for(int i=0; i<hits; i++)
        future[(fbase+i)%maxhits]+=copies;  // add the copies for next cards
    future[(fbase+maxhits-1)%maxhits] = 1;  // the end of ringbuffer is filled with 1

    return copies;
}

void main() {
    stdout.writeln(stdin.byLine.map!getpoints.sum);
}

unittest {
    string[] lines = [
        "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
        "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
        "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
        "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
        "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
        "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
    ];
    assert(lines.map!(a=>cast(char[]) a).map!getpoints.sum==30);
}
