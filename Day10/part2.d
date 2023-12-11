// D quickndirty day10 part2 
// this was pain... "ANY tile that isn't part of the main loop can count as being enclosed by the loop."

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

    char[][] area = new char[][](field.length, field[0].length);
    area[starty][startx] = '*';

    while((x!=startx) || (y!=starty)) {
        debug stdout.writeln(x," ", y, field[y][x]);
        auto p = field[y][x];
        area[y][x] = '*';

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

    int sum;
    int latent;
    for(int yy=1; yy<area.length; yy++) {
        int count=0;
	bool inside=false;
        for(int xx=1; xx< area[yy].length; xx++) {
            auto c=area[yy][xx];
            if (c=='*' && field[yy][xx].n) inside=!inside;
	    if (c!='*' && inside) sum++;
            if (c=='*') stdout.write('*'); else stdout.write('.');
            
        }
        stdout.writeln(" ", sum);
    }
    stdout.writeln(sum);
}
