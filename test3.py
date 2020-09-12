from sys import stdin
import re

pattern = re.compile('^.*? ([^ ,]*).*? > ([^ ,]*).*? length ([^:]*):.*')
#pattern = re.compile('^.*? ([^ ,]*).*? > ([^ ,]*).*')
#pattern = re.compile('^.*? ([^ ,]*).*')
for line in stdin:
    line = line.replace( '\n' , '' )
    str = pattern.sub(r'\1@\2@\3', line)
    #str = pattern.sub(r'\1@\2@', line)
    #str = pattern.sub(r'\1@', line)

    #sea = re.sub('( |,).*', '', re.sub('^.*? ', '', line))
    #dea = re.sub('( |,).*', '', re.sub('^.*? > ', '', line))
    #len = re.sub(':.*', '', re.sub('^.*? length ', '', line))
    print(str, "@@@", line)
