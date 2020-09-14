#from sys import stdin
import sys
import re

args = sys.argv
if len(args) > 1:
   param = args[1]
else:
   param = ""

#print("param:" + param)

edict = dict()
for line in sys.stdin:
    line = line.replace( '\n' , '' )
    array = line.split(' ')
    tim = array[0]
    esa = array[1]
    eda = array[2]
    ety = array[3]
    eln = int(array[4])

    if len(args) > 1:
        src = esa
        dst = eda
    else:
        if ety == 'IPv4':
            isa = array[5]
            ida = array[6]
            isas = isa.split('.')
            idas = ida.split('.')
            #print(type(isas))
            if len(isas) == 4:
                src = esa + " " + isas[0] + "."  + isas[1] + "." + isas[2] + "." + isas[3] + " -"
            elif len(isas[4]) == 5:
                src = esa + " " + isas[0] + "."  + isas[1] + "." + isas[2] + "." + isas[3] + " *"
            else:
                src = esa + " " + isas[0] + "."  + isas[1] + "." + isas[2] + "." + isas[3] + " " + isas[4]
            if len(idas) == 4:
                dst = eda + " " + idas[0] + "."  + idas[1] + "." + idas[2] + "." + idas[3] + " -"
            elif len(idas[4]) == 5:
                dst = eda + " " + idas[0] + "."  + idas[1] + "." + idas[2] + "." + idas[3] + " *"
            else:
                dst = eda + " " + idas[0] + "."  + idas[1] + "." + idas[2] + "." + idas[3] + " " + idas[4]
        elif ety == 'IPv6':
            isa = array[5]
            ida = array[6]
            isas = isa.split('.')
            idas = ida.split('.')
            if len(isas) == 1:
                src = esa + " " + isas[0] + " -"
            elif len(isas[1]) == 5:
                src = esa + " " + isas[0] + " *"
            else:
                src = esa + " " + isas[0] + " " + isas[1]
            if len(idas) == 1:
                dst = eda + " " + idas[0] + " -"
            elif len(idas[1]) == 5:
                dst = eda + " " + idas[0] + " *"
            else:
                dst = eda + " " + idas[0] + " " + idas[1]
        else:
            src = esa + " - -"
            dst = eda + " - -"

    if eda != 'ff:ff:ff:ff:ff:ff':
        if src not in edict.keys():
            edict[src] = [0, 0, 0, 0]
        if dst not in edict.keys():
            edict[dst] = [0, 0, 0, 0]
        edict[src][0] += 1
        edict[dst][1] += 1
        edict[src][2] += eln
        edict[dst][3] += eln

for e in edict:
    print(e, edict[e][0], edict[e][1], edict[e][2], edict[e][3])
