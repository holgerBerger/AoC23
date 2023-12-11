// D solution da11 part2

import std.stdio;
import std.algorithm;
import std.math;

struct Galaxy {
    long x,y;
}

Galaxy[] galaxies;
long[] xs;

void parseline(string line, ref int y) {
    bool empty=true;
    for(int x=0; x<line.length; x++) {
        if (line[x]=='#') {
            empty = false;
            galaxies~=Galaxy(x,y);
            xs~=x;
        } 
    }
    if (empty) y+=1_000_000; else y++;
}

void main() {
    string line;
    int y;
    while((line=stdin.readln) !is null) {
        parseline(line, y);
    }
    xs.sort();
    debug stdout.writeln(galaxies, xs);
    for(int x=1; x<xs.length; x++) {
        if (xs[x]-xs[x-1]>1) {
            foreach(ref g; galaxies) {
                if (g.x>=xs[x]) g.x+=1_000_000-1;
            }
            for(int xx=x; xx<xs.length; xx++) xs[xx]+=1_000_000-1;
        }
    }
    debug stdout.writeln(galaxies);

    long sum;
    foreach(g1; galaxies) 
        foreach(g2; galaxies) {
            sum+=abs(g2.x-g1.x) + abs(g2.y-g1.y);
        }
    stdout.writeln(sum/2);
}