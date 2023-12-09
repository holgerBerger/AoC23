
import std.stdio;
import std.conv;
import std.string;
import std.algorithm;
import std.array;

int derive(int[] series) {
    bool allzero=true;
    int d;
    int[] differences;
    differences.length = series.length-1;

    debug stdout.writeln("in: ",series);

    for(int i=1; i<series.length; i++) {
        d = series[i] - series[i-1];
        differences[i-1] = d;
        if (d!=0) allzero = false;
    }
    if (allzero) return 0;
    return differences[$-1]+derive(differences);
}

int firstderive(int[] series) {
    return series[$-1]+derive(series[0..$]);
}

void main() {
    stdout.writeln(stdin.byLine.map!(a=> a.split.map!(a=>a.to!int).array.firstderive).sum);
}