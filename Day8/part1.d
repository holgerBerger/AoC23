// D solution day8 part1, not using associative arrays, but a dense matrix
// lazy reading with regex

import std.stdio;
import std.regex;
import std.string;

struct Dir {
    short l;
    short r;
    debug string name;
}

short idtoint(string id) {    
    return cast(short)(((id[0]-'A')<<10) | ((id[1]-'A')<<5) | (id[2]-'A'));
}

void main() {
    string line;
    Dir[] map;
    short ZZZ = idtoint("ZZZ");
    map.length = ZZZ+1;

    auto re = regex(r"^(...) = \((...), (...)\)");
    string path = stdin.readln().chomp;
    while((line = stdin.readln()) !is null) {
        debug stdout.write(line);
        auto m = matchFirst(line, re);
        if (m) {
            auto idx = idtoint(m[1]); auto l = idtoint(m[2]); auto r = idtoint(m[3]);
            debug stdout.writefln("%d -> (%d, %d)\n", idx, l, r);
            map[idx].l = l;
            map[idx].r = r;
            debug map[idx].name = m[1];
        }
    }   

    short id = idtoint("AAA");
    int count = 0;
    do {
        foreach(c; path) {
            count++;
            debug stdout.write(c,"->");
            if (c=='L') id = map[id].l;
            else  id = map[id].r;
            debug stdout.writeln(id," [",map[id].name,"] ",ZZZ);
            if (id==ZZZ) break;
        }
        debug stdout.writeln("--- AGAIN ---");
    } while(id!=ZZZ);
    stdout.writeln(count);
}