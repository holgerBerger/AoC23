#!/usr/bin/python3

# simple quick and dirty python solution, for verification

import sys

digits = {  "1":1, "2":2, "3":3, "4":4, "5":5, "6":6, "7":7, "8":8, "9":9, 
        "one":1, "two":2, "three":3, "four":4, "five":5, "six":6, "seven":7, "eight":8, "nine":9 }

sum=0
for line in sys.stdin.readlines():
    firstpos=len(line)
    lastpos=-1
    for w in digits:
        pos=line.find(w)
        if pos!=-1:
            if pos<firstpos:
                firstpos=pos
                fdigit=digits[w]
        pos=line.rfind(w)
        if pos!=-1:
            if pos>lastpos:
                lastpos=pos
                ldigit=digits[w]
    sum+=fdigit*10+ldigit        
print("sum:",sum)
