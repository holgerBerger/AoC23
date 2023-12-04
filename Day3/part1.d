// D solution for part1 that does not store all input data but just 2 lines


import std.stdio;
import std.ascii;
import std.algorithm;


class Number {
    int value;
    bool ispart;
    this(char c) { value=c-'0'; ispart=false; }
    void addDigit(char c) { value=value*10+c-'0'; }
}

struct Column {
    char c;
    bool isdigit;
    bool issymbol;
    Number number;
    this(bool digit, bool symbol) { this.c=' '; isdigit=digit; issymbol=symbol; number=null;}
    this(char c, bool digit, bool symbol) { this.c=c; isdigit=digit; issymbol=symbol; number=null;}
    this(char c, bool digit, bool symbol, ref Number number) { this.c=c; isdigit=digit; issymbol=symbol; this.number=number;}
}

class Symbolfinder {
    void addline(string line) {
        //stderr.writeln(">",line);

        if(firstline) init(line);

        char lastc = '.';
        Number curnumber;
        int col=1;  // we start at 1 to have a halo element
        foreach(c; line) {
            if (c=='.') 
                currentline[col] = Column(c, false, false);
            else if (isDigit(c)) {
                if(!isDigit(lastc)) { 
                    curnumber = new Number(c);
                    if (lastc!='.') {  // previous is symbol
                        currentline[col] = Column(c, true, true, curnumber);
                        curnumber.ispart = true;
                    } else {        // previous is not symbol
                        currentline[col] = Column(c, true, false, curnumber);
                    }
                } else {
                    curnumber.addDigit(c);
                    currentline[col] = Column(c, true, false, curnumber);
                }
                // check previous line for nearby symbols
                if(lastline[col-1].issymbol) curnumber.ispart = true;
                if(lastline[col+0].issymbol) curnumber.ispart = true;
                if(lastline[col+1].issymbol) curnumber.ispart = true;
            } else { // symbol
                currentline[col] = Column(c, false, true);
                if(isDigit(lastc)) curnumber.ispart=true; 
                // check previous line if there is a nearby number
                if(lastline[col-1].isdigit) lastline[col-1].number.ispart=true;
                if(lastline[col+0].isdigit) lastline[col+0].number.ispart=true; 
                if(lastline[col+1].isdigit) lastline[col+1].number.ispart=true;
            }
            lastc = c;
            col++;
        }

        // sum up numbers of line to discard
        bool lastisdigit=false;
        foreach(ref c; lastline) {
            if(c.isdigit) {
                if(!lastisdigit) {
                    if (c.number.ispart) {
                        checksum+=c.number.value; 
                    }
                }
                lastisdigit=true;
            } else {
                lastisdigit=false;
            }
        }

        for(int i=0; i<width; i++) {
            lastline[i] = currentline[i];
            currentline[i] = Column(false, false);
        }
    }

    // make a halo line to access
    private void init(string line) {
        firstline=false;
        checksum = 0;
        width = line.length+2;
        lastline.length = width;
        currentline.length = width;
        // init halo elements
        for(int i=0; i<line.length; i++) lastline[i] = Column(false, false);
        currentline[0] = Column(false, false);
        currentline[width-1]= Column(false, false);
    }

    this() {firstline=true;}

private:
    Column[] lastline;
    Column[] currentline;
    ulong width;
    int checksum;
    bool firstline;
}

void main() {
    Symbolfinder s = new Symbolfinder();
    foreach(line; stdin.byLine) {
        s.addline(cast(string)line);
    }
    s.addline("");
    stdout.writeln(s.checksum);
}




// tests, provided test does not cover all cases, second test is needed

unittest {
    string[] lines = [
                "467..114..",
                "...*......",
                "..35..633.",
                "......#...",
                "617*......",
                ".....+.58.",
                "..592.....",
                "......755.",
                "...$.*....",
                ".664.598.."
    ];

    Symbolfinder s = new Symbolfinder();
    foreach(line; lines) {
        s.addline(line);
    }
    s.addline("");
    assert(s.checksum==4361);
}

unittest {
    string[] lines = [
                ".....+/58.",
    ];

    Symbolfinder s = new Symbolfinder();
    foreach(line; lines) {
        s.addline(line);
    }
    s.addline(""); 
    assert(s.checksum==58);  
}