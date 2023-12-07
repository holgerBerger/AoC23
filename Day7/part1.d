// D solition Day7 part1

import std.stdio;
import std.algorithm;
import std.array;
import std.conv;

short[dchar] cardmap = [ 'A': 14, 'K': 13, 'Q':12, 'J':11, 'T':10, '9': 9, '8':8, '7':7, '6':6, '5':5, '4':4, '3':3, '2':2];

alias Hand = short[5];

struct Handsbid {
    Hand hand;
    Handtype type;
    int bid;
}

enum Handtype { FIVE=8, FOUR=7, FULL=6, THREE=5, TWOPAIR=4, ONEPAIR=3, HIGH=2, NONE=1};

Handtype gettype(Hand hand) {
    short[short] counter;
    foreach(c; hand) if (c in counter) counter[c]++; else counter[c]=1;
    auto v =  counter.byValue.array.sort.reverse.array;
    if (v[0] == 5) return Handtype.FIVE;
    if (v[0] == 4) return Handtype.FOUR;
    if (v[0] == 3 && v[1] == 2) return Handtype.FULL;
    if (v[0] == 3) return Handtype.THREE;
    if (v[0] == 2 && v[1] == 2) return Handtype.TWOPAIR;
    if (v[0] == 2) return Handtype.ONEPAIR;
    if (v == [1,1,1,1,1]) return Handtype.HIGH;
    return Handtype.NONE;
}

Handsbid parse(const char[] line) {
    auto sp = line.split();
    short[5] hand = sp[0].map!(a=>cardmap[a]).array;
    return Handsbid(hand, gettype(hand), to!int(sp[1]));
}

pure bool handcomp(in Handsbid a, in Handsbid b) {
    if (a.type < b.type) return true;
    if (a.type > b.type) return false;
    for(int i=0; i<5; i++) {
        if (a.hand[i] < b.hand[i]) return true;
        if (a.hand[i] > b.hand[i]) return false;
    }
    assert(0);
}

void main() {
    auto handsbid = stdin.byLine.map!parse.array.sort!(handcomp);
    long winning;
    //stdout.writeln(handsbid);
    for(int i=0; i<handsbid.length; i++) winning+=(i+1)*handsbid[i].bid;
    stdout.writeln(winning);
}