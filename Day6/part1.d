/*

	distance = (total_time - hold_time) * hold_time 
	diatance = total_time*holdtime - hold_time^2
	hold_time^2 - total_time*holdtime + distance = 0
	ht1_2 = (total_time +/- sqrt(total_time*total_time - 4*distance) )  / 2

 */

import std.stdio;
import std.array;
import std.conv;
import std.math;
import std.algorithm;


void main() {
	auto times = stdin.readln.split(':')[1].split().map!(to!float).array;
	auto distances = stdin.readln.split(':')[1].split().map!(to!float).array;
	long solution = 1;
	for(int i=0; i<times.length; i++) {
		auto total_time = times[i];
		auto distance = distances[i];
		int t1=to!int(ceil(((total_time + sqrt(total_time*total_time - 4*distance) )  / 2.0)-1));
		int t2=to!int(floor(((total_time - sqrt(total_time*total_time - 4*distance) )  / 2.0)+1));
		solution*=t1-t2+1;
	}
	stdout.writeln(solution);
}
