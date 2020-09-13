#!/bin/bash

# <前提条件>
# python3コマンドが実行できること

scriptDir=$(cd `dirname $0`; pwd)
scriptName=$(basename $0)
FMTDIR=fmtcap

usage() {
    if [ "$1" != "" ]; then
        echo $1 1>&2
    fi
    echo "USAGE: $0 <file|dir> [debug]" 1>&2
}

writelog() {
    TS=$(date "+%Y/%m/%d %H:%M:%S")
    echo "${TS} ${scriptName} $@" 1>&2
}

if [ $# -eq 0 ]; then
    usage
    exit 2
fi

TARGET=$1
OPT=$2 # デバッグ用。任意の文字を指定すると、キャプチャの全行を出力する。

if [ -f ${TARGET} ]; then
    writelog "FILE: ${TARGET}"
    tcpdump -r ${TARGET} -en | python3 ${scriptDir}/fmtcap.py ${OPT}
elif [ -d ${TARGET} ]; then
    writelog "DIR: ${TARGET}"
    mkdir -p ${FMTDIR}
    max=`find ${TARGET} -name "*.cap" | wc -l`
    cnt=0
    find ${TARGET} -name "*.cap" | while read f; do
        cnt=$((cnt + 1))
        fname=`basename ${f}`
        writelog "${cnt}/${max} ${f} > ${FMTDIR}/${fname}.txt"
        tcpdump -r ${f} -en | python3 ${scriptDir}/fmtcap.py > ${FMTDIR}/${fname}.txt
        test ${PIPESTATUS[0]} -a ${PIPESTATUS[1]}; ret=$?
        if [ ${ret} ]; then
            mv ${f} ${f}.fin
        fi
    done

    # .finファイル名を戻す場合、以下のコマンドを実行
    #find ${TARGET} -name "*.cap.fin" | while read f; do
    #    fname=${f%.*}
    #    echo ${f} ${fname}
    #    mv ${f} ${fname}
    #done
else
    usage "${TARGET}: Not found."
    exit 3
fi
