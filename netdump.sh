#/bin/bash

# <参考URL>
# tcpdumpでキャプチャファイルを定期的にローテートさせる方法
# https://www.checksite.jp/tcpdump-rotate-option/
#
# <ファイル一覧コマンド>
# ls --full-time capture/*

# 固定値設定
CAPDIR=capture
IF=eth0
ROTATE=600

# 変数設定
CAPUSER=`id -un`
TS=`date "+%Y%m%d_%H%M%S"`

# ディレクトリ作成（なければ）
mkdir -p ${CAPDIR}

# キャプチャ取得
#sudo tcpdump -i ${IF} -e > ${CAPDIR}/${IF}-${TS}.txt
sudo tcpdump -i ${IF} -Z ${CAPUSER} -G ${ROTATE} -w ${CAPDIR}/netdump-${IF}-${TS}-%y%m%d_%H%M%S.cap &
