// D solution day8 part1, not using associative arrays, but a dense matrix
// lazy reading with regex, final result with LCM

import std.stdio;
import std.regex;
import std.string;
import std.algorithm;
import std.conv;

struct Mapentry {
    string id;
    string l;
    string r;
    bool z;
}

struct Dir {
    short l;
    short r;
    bool z;
}

long euclid(long a, long b) {
    while(b!=0) {
        auto m = a % b;
        a = b;
        b = m;
    }
    return a;
}

unittest {
    assert(euclid(6,9)==3);
}

void main() {
    string line;
    Mapentry[] map;
    Dir[] compactmap;
    short[] starts;
    int[] zs;
    short[string] name2id;
    string[short] id2name;  // unused

    // read map
    auto re = regex(r"^(...) = \((...), (...)\)");
    string path = stdin.readln().chomp;
    short pos=0;
    while((line = stdin.readln()) !is null) {
        debug stdout.write(line);
        auto m = matchFirst(line, re);
        if (m) {
            if (m[1][2]=='A') { 
                starts~=pos;
            }
            if (m[1][2]=='Z') { 
                map ~= Mapentry(m[1], m[2], m[3], true);
            } else {
                map ~= Mapentry(m[1], m[2], m[3], false);
            }
            name2id[m[1]] = pos;
            id2name[pos] = m[1]; // unused
            pos++;
        }
    }   
    debug stdout.writeln(pos, " ", starts);

    // compact map
    compactmap.length = pos;
    foreach(e; map) {
        compactmap[name2id[e.id]] = Dir(name2id[e.l], name2id[e.r], e.z);
        debug stdout.writefln("%d : (%d, %d) %b", name2id[e.id], name2id[e.l], name2id[e.r], e.z);
    }

    // search for all start positions
    foreach(s; starts) {
        auto p = s;
        int count=0;
        OUTER: while(true) {
            foreach(c; path) {
                count++;
                debug stdout.writef("%c : %d -> ", c , p);
                if (c=='L') p = compactmap[p].l;
                else  p = compactmap[p].r;

                debug stdout.writefln("%d", p);

                if (compactmap[p].z) {
                    stdout.writefln("%d z=%d [%d]", s, count, p);
                    zs~=count;
                    break OUTER;
                }
            }        
        }


    }
    stdout.writeln(zs);

    long z1 = zs[0];
    long z2;
    long kgv;
    for(int i=1; i<zs.length; i++) {
        z2 = zs[i];
        kgv = (z1*z2)/euclid(z1,z2);
        z1 = kgv;
    }
    stdout.writeln(kgv);
}
