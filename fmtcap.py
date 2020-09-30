#from sys import stdin
import sys
import re

args = sys.argv
if len(args) > 1:
   param = args[1]
else:
   param = ""

#print("param:" + param)

#pattern = re.compile('^(.*?) ([^ ,]*).*? > ([^ ,]*).*? length ([^:]*):.*')
#patternIP = re.compile('^(.*?) ([^ ,]*).*? > ([^ ,]*).*? ethertype ([^ ]*) .*? length ([^:]*): ([^ ]*) > ([^ ]*): .*')
#patternEL = re.compile('^(.*?) ([^ ,]*).*? > ([^ ,]*).*? ethertype ([^ ]*) .*? length ([^:]*):.*')
patternIP = re.compile('^(.*?) ([^ ,]*).*? > ([^ ,]*).*? (ethertype )?([^, ]*).*? length ([^:]*): ([^ ]*) > ([^ ]*): .*')
patternEL = re.compile('^(.*?) ([^ ,]*).*? > ([^ ,]*).*? (ethertype )?([^, ]*).*? length ([^:]*):.*')
for line in sys.stdin:
    if line.startswith('\t'):
        continue
    line = line.replace( '\n' , '' )
    #str = pattern.sub(r'\1 \2 \3 \4', line)
    if line.find('ethertype IP') >=0:
        str = patternIP.sub(r'\1 \2 \3 \5 \6 \7 \8', line)
    else:
        str = patternEL.sub(r'\1 \2 \3 \5 \6', line)

    if param != "":
        print(str, "@@@", line)
    else:
        print(str)
