// D solution part1 not storing mapping
import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.array;
import std.ascii;

void main() {
    long[] numbers;
    bool[long] done;
    bool start=true;
    foreach(line; stdin.byLine) {
        if(start && line.startsWith("seeds:")) {
            numbers = line.split(':')[1][1..$].split(' ').map!(a=>to!long(a)).array;
            start=false;
        } else if (line.length==0 || !isDigit(line[0])) {
            done = null;
        } else {
            auto mapping = line.split(' ').map!(a=>to!long(a)).array;
            for(int i=0; i<numbers.length; i++) {
                long n = numbers[i];
                if (!(i in done) && n>=mapping[1] && n<mapping[1]+mapping[2]) {
                    numbers[i] -= (mapping[1] - mapping[0]);
                    done[i] = true; 
                }
            }
        }
    }    
    stdout.writeln(numbers.minElement);   
}
