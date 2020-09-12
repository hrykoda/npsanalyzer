from sys import stdin
import re

for line in stdin:
    line = line.replace( '\n' , '' )
    sea = re.sub('( |,).*', '', re.sub('^.*? ', '', line))
    dea = re.sub('( |,).*', '', re.sub('^.*? > ', '', line))
    len = re.sub(':.*', '', re.sub('^.*? length ', '', line))
    print(sea, dea, len, "@@@", line)
