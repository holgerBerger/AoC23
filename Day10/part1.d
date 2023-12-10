// D quickndirty day10 part1 

import std.stdio;
import std.string;

struct Point {
    bool   n; 
    bool w, e;
    bool   s;
    char c;
}

Point[][] field;
int startx;
int starty;

Point[] createLine(string line, int y) {
    Point[] points;
    points~=Point(false, false, false, false, '.');
    int x=1;
    foreach(c; line) {
        switch (c) {
            case 'F': points~=Point(false, false, true, true, c); break;
            case '7': points~=Point(false, true, false, true, c); break;
            case 'L': points~=Point(true, false, true, false, c); break;
            case 'J': points~=Point(true, true, false, false, c); break;
            case '|': points~=Point(true, false, false, true, c); break;
            case '-': points~=Point(false, true, true, false, c); break;
            case '.': points~=Point(false, false, false, false, c); break;
            case 'S': points~=Point(false, false, false, false, c); startx=x; starty=y; break;
            default: assert(0);
        }
        x++;
    }
    points~=Point(false, false, false, false, '.');
    return points;
}

void main() {
    string line;
    int x=0;
    int y=1;
    while((line=stdin.readln()) !is null)  {
        if (y==1) {
            Point[] l;
            foreach(c; line) l~=Point();
            field~=l;
        }
        field ~= createLine(line.chomp,y);
        y++;
    }
    field~=field[0].dup;

    debug stdout.writeln(field, "\n",startx, starty);

    int length=1;
    x=startx;
    y=starty;
    char dir;
    if (field[y][x+1].w) { x++; dir='e';}
    else if (field[y][x-1].e) { x--; dir='w';}
    else if (field[y-1][x].s) { y--; dir='n';}
    else if (field[y+1][x].n) { y++; dir='s';}
    else assert(0);

    while((x!=startx) || (y!=starty)) {
        debug stdout.writeln(x," ", y, field[y][x]);
        auto p = field[y][x];

        if (dir=='s') {
            if (p.w) {x--; dir='w';}
            else if (p.e) {x++; dir='e';}
            else if (p.s) {y++; dir='s';}
            else assert(0);
        } else if (dir=='n') {
            if (p.w) {x--; dir='w';}
            else if (p.e) {x++; dir='e';}
            else if (p.n) {y--; dir='n';}
            else assert(0);
        } else if (dir=='e') {
            if (p.e) {x++; dir='e';}
            else if (p.s) {y++; dir='s';}
            else if (p.n) {y--; dir='n';}
            else assert(0);
        } else if (dir=='w') {
            if (p.w) {x--; dir='w';}
            else if (p.s) {y++; dir='s';}
            else if (p.n) {y--; dir='n';}
            else assert(0);
        } else {
            assert(0);
        }
        length++;
        debug stdout.writeln(">>",dir);
    }
    stdout.writeln(length/2);

}