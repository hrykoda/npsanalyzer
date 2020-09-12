import re

while True:
    try:
        line = input()
        sea = re.sub('( |,).*', '', re.sub('^.*? ', '', line))
        print(sea, "@@@", line)
    except EOFError:
        break
