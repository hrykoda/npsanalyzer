#!/bin/bash

# <前提条件>
# python3コマンドが実行できること
scriptDir=$(cd `dirname $0`; pwd)

cat $@ | python3 ${scriptDir}/ipmac.py
