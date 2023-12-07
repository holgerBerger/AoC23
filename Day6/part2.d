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
import std.string;


void main() {
	auto total_time = stdin.readln.filter!(a=>a!=' ').array.split(':')[1].chomp.to!double;
	auto distance = stdin.readln.filter!(a=>a!= ' ').array.split(':')[1].chomp.to!double;
	stdout.writeln(total_time, " ", distance);
	long t1=to!long(ceil(((total_time + sqrt(total_time*total_time - 4*distance) )  / 2.0)-1));
	long t2=to!long(floor(((total_time - sqrt(total_time*total_time - 4*distance) )  / 2.0)+1));
	auto solution=t1-t2+1;
	stdout.writeln(solution);
}
