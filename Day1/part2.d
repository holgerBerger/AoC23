import std.stdio;
import std.algorithm;
import std.string;

int[string] numbers;

int sumnums(string line) {
	long lpos=-1, fpos=line.length;
	int ldigit, fdigit;
	foreach(n; numbers.byKey) {
		auto pos = line.indexOf(n);
		if (pos!=-1 && pos < fpos) {
			fpos=pos; fdigit=numbers[n];
		}
		pos = line.lastIndexOf(n);
		if (pos!=-1 && pos > lpos) {
			lpos=pos; ldigit=numbers[n];
		}
	}
	return fdigit*10+ldigit;
}

void main()
{
	numbers = [ "1":1, "2":2, "3":3, "4":4, "5":5, "6":6, "7":7, "8":8, "9":9, 
        "one":1, "two":2, "three":3, "four":4, "five":5, "six":6, "seven":7, "eight":8, "nine":9 ];
	stdout.writeln("sum: ", stdin.byLine.map!(a=>cast(string)a).map!sumnums.sum());
}
