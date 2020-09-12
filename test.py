from sys import stdin
import re

pattern = re.compile('^.*? ([^ ,]*).*? > ([^ ,]*).*? length ([^:]*):.*')
for line in stdin:
    line = line.replace( '\n' , '' )
    str = pattern.sub(r'\1 \2 \3', line)
    #print(str, "@@@", line)
    print(str)
