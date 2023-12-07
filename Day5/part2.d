// D solution part 2, not storing mappings, operating on intervals/ranges


import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.array;
import std.ascii;

struct Range {
    long start;
    long len;
}

void compare_ranges(in ref long[] mapping, ref Range[] numbers, in int i, ref bool[long] done) {
    auto ms=mapping[1];
    auto me=mapping[1]+mapping[2]-1;
    auto cr = numbers[i];
    auto orig = numbers[i];

    if ((cr.start>=ms) && ((cr.start+cr.len-1)<=me)) { // complete inside
        debug stdout.writeln(" inside ", cr, " ", ms,"-",me);
        numbers[i].start -= (mapping[1] - mapping[0]);
        done[i] = true;
    } else if ((cr.start>=ms) && (cr.start<=me) && (cr.start+cr.len-1)>me) {  // end outside
        debug stdout.writeln(" end outside ", cr, " ", ms,"-",me);
        numbers[i].start -= (mapping[1] - mapping[0]);
        numbers[i].len = me-orig.start+1;
        numbers ~= Range(me+1, orig.start+orig.len-me-1);
        done[i] = true;
    } else if ((cr.start<ms) && (cr.start+cr.len-1)>=ms && (cr.start+cr.len-1)<=me) { // start outside
        debug stdout.writeln(" start outside ", cr, " ", ms,"-",me);         
        numbers[i].start = ms-(mapping[1] - mapping[0]);
        numbers[i].len = orig.start+orig.len-ms;
        numbers ~= Range(orig.start, ms-orig.start); 
        done[i] = true;
    }
}


void main() {
    Range[] numbers;
    Range[] seeds;
    bool[long] done;
    bool start=true;
    foreach(line; stdin.byLine) {
        if(start && line.startsWith("seeds:")) {
            auto pairs = line.split(':')[1][1..$].split(' ').map!(a=>to!long(a)).array;
            for (int i=0; i<pairs.length; i+=2) {
                seeds ~= Range(pairs[i], pairs[i+1]);
            }
            numbers = seeds.dup;
            start=false;
            debug stdout.writeln("start: ",numbers); 
        } else if (line.length==0 || !isDigit(line[0])) {
            debug stdout.writeln(line);
            done = null;
        } else {
            auto mapping = line.split(' ').map!(a=>to!long(a)).array;
            debug stdout.writeln("mapping: ", mapping);
            auto ol = numbers.length;
            debug stdout.writeln("before: ", numbers); 
            for(int i=0; i<ol; i++) {
                if (!(i in done)) {
                    compare_ranges(mapping, numbers, i, done);
                }
            }
            debug stdout.writeln("after :", numbers); 
        }
    }    
    debug{
        stdout.writeln();
        stdout.writeln(numbers);  
    }

    auto sorted_numbers = numbers.sort!((x,y)=>(x.start < y.start));

    stdout.writeln(numbers[0].start);

    debug {
        foreach(n; sorted_numbers)
            stdout.writeln(n.start, " ", n.len, " -> ", n.orig.start, " ", n.orig.len);
    }
}

/* 

    mapstart ------ end
        rstart -- end

    mapstart ------ end
        rstart -----------end

    mapstart ------- end
  rstart ----- end

*/

unittest {
    //M       4 5
    //N     3-4
    //>   2 3
    long[] mapping = [2, 4, 2];
    Range[] numbers = [Range(3,2)];
    bool[long] done = [0:false];
    compare_ranges(mapping, numbers, 0, done);
    //stdout.writeln(numbers, done);
    assert(numbers == [Range(2, 1, null), Range(3, 1, null)]);

    //M       4 5
    //N     3-4
    //>     3     6
    mapping = [6, 4, 2];
    numbers = [Range(3,2)];
    done = [0:false];
    compare_ranges(mapping, numbers, 0, done);
    //stdout.writeln(numbers, done);
    assert(numbers == [Range(6, 1, null), Range(3, 1, null)]);

    //M     3 4 5 6
    //N     3-4
    //> 1 2
    mapping = [1, 3, 4];
    numbers = [Range(3,2)];
    done = [0:false];
    compare_ranges(mapping, numbers, 0, done);
    //stdout.writeln(numbers, done);
    assert(numbers == [Range(1, 2, null)]);

    //M     3 4 5 6
    //N         5-6
    //>     3 4
    mapping = [1, 3, 4];
    numbers = [Range(5,2)];
    done = [0:false];
    compare_ranges(mapping, numbers, 0, done);
    //stdout.writeln(numbers, done);
    assert(numbers == [Range(3, 2, null)]);

    //M     3 4 5 6
    //N           6-7
    //>       4     7
    mapping = [1, 3, 4];
    numbers = [Range(6,2)];
    done = [0:false];
    compare_ranges(mapping, numbers, 0, done);
    //stdout.writeln(numbers, done);
    assert(numbers == [Range(4, 1, null), Range(7, 1, null)]);
}
