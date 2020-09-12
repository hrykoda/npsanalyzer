#from sys import stdin
import sys
import re

args = sys.argv
if len(args) > 1:
   param = args[1]
else:
   param = ""

print("param:" + param)

#pattern = re.compile('^(.*?) ([^ ,]*).*? > ([^ ,]*).*? length ([^:]*):.*')
patternIP = re.compile('^(.*?) ([^ ,]*).*? > ([^ ,]*).*? ethertype ([^ ]*) .*? length ([^:]*): ([^ ]*) > ([^ ]*): .*')
patternEL = re.compile('^(.*?) ([^ ,]*).*? > ([^ ,]*).*? ethertype ([^ ]*) .*? length ([^:]*):.*')
for line in sys.stdin:
    line = line.replace( '\n' , '' )
    #str = pattern.sub(r'\1 \2 \3 \4', line)
    if line.find('ethertype IP') >=0:
        str = patternIP.sub(r'\1 \2 \3 \4 \5 \6 \7', line)
    else:
        str = patternEL.sub(r'\1 \2 \3 \4 \5', line)

    if param != "":
        print(str, "@@@", line)
    else:
        print(str)
