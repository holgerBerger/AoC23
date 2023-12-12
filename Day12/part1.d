// D horrible inefficient solution part1
// does in put in around 3 minutes

import std.stdio;
import std.algorithm;
import std.conv;
import std.array;
import std.string;

long count;


bool valid(in char[] spr, in int[] record) {
    if (canFind(spr,'?')) return false;
    int group=0;
    int cl=0;
    foreach(c; spr) {
        if (c=='#') {
            cl++;
            if (group>=record.length) return false;
            if (cl>record[group]) return false;
        } else {
            if (cl>0) {
                if (cl<record[group]) return false;
                group++;          
            }
            cl=0;
        }
    }
    if (cl>0) {
        if (cl<record[group]) return false;
        group++;
    }
    if (group<record.length) return false;
    return true;
}

unittest{
    assert(valid("?##.", [2])==false);
    assert(valid(".##.", [2])==true);
    assert(valid(".###.", [2])==false);
    assert(valid(".#.#.", [1,1])==true);
    assert(valid(".#.#", [1,1])==true);
    assert(valid(".#.###.#", [1,3,1])==true);
    assert(valid(".#.###.#", [1,3])==false);
    assert(valid(".#.###.#", [1,3,1,1])==false);
}

void backtrack(in char[] spr, in ref int[] record, in int start) {
    debug stdout.writeln("   ",spr," ",start);
    if (start>spr.length || !canFind(spr,'?')) {
        debug stdout.writeln("  ",spr," ",start, " ", record," ",valid(spr, record));
        if (valid(spr, record)) {
                count++;
        }
    }
    for(int pos=start; pos<spr.length; pos++) {
        if (spr[pos]=='?') {
            auto candidate = spr.dup;
            candidate[pos]='#';
            backtrack(candidate, record, pos+1);
            candidate[pos]='.';
            backtrack(candidate, record, pos+1);
        } 
    }
}

void parse(int nr, string line) {
    auto sp=line.split();
    auto spr= sp[0];
    auto record = sp[1].split(',').map!(a=> to!int(a)).array;

    stdout.writefln("%4.4d %s",nr, spr);

    backtrack(cast(const char[])spr, record, 0);
}

void main() {
    string line;
    count=0;
    int nr;
    while((line=stdin.readln)!is null) {
        parse(nr++, line);
    }
    stdout.writeln(count);

}
