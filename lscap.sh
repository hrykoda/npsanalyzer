#!/bin/bash

# パラメータを省略したら、captureディレクトリを表示する
# captureディレクトリ以外を表示する場合はパラメータで指定する

CAPDIR=capture

OPT=$@
if [ $# -eq 0 ]; then
    OPT=${CAPDIR}
fi

ls --full-time ${OPT}
