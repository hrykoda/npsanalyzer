#!/bin/bash

# <前提条件>
# python3コマンドが実行できること

scriptDir=$(cd `dirname $0`; pwd)
scriptName=$(basename $0)
FMTDIR=fmtcap
PATH=/usr/sbin:$PATH

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
    # 件数カウント
    tcnt=`find ${TARGET} -name "*.cap" | while read f; do
        fname=$(basename ${f})
        if [ ${f} -nt ${FMTDIR}/${fname}.txt ]; then
            echo 1
        fi
    done | wc -l`
    writelog "target count: ${tcnt}"
    # フォーマット処理
    cnt=0
    find ${TARGET} -name "*.cap" | while read f; do
        fname=$(basename ${f})
        if [ ${f} -nt ${FMTDIR}/${fname}.txt ]; then
            cnt=$((cnt + 1))
            sz=$(ls -l ${f} | awk '{print $5}')
            writelog "${cnt}/${tcnt} ${sz} ${f} > ${FMTDIR}/${fname}.txt"
            tcpdump -r ${f} -en | python3 ${scriptDir}/fmtcap.py > ${FMTDIR}/${fname}.tmp
            test ${PIPESTATUS[0]} -a ${PIPESTATUS[1]}; ret=$?
            if [ ${ret} ]; then
                mv ${FMTDIR}/${fname}.tmp ${FMTDIR}/${fname}.txt
            fi
        fi
    done
    writelog "end"

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
