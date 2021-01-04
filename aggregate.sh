#!/bin/bash
scriptDir=$(cd `dirname $0`; pwd)
scriptName=$(basename $0)
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

GWMAC=84:af:ec:f5:36:9f
GWIP=192.168.11.1
RDIR=/home/pi
CDIR=${RDIR}/capture
FDIR=${RDIR}/fmtcap
ADIR=${RDIR}/aggrdata
LYMD=`date "+%Y%m%d" -d "1 days ago"`
SYMD=${LYMD:2:6}
LY_M=${LYMD:0:4}/${LYMD:4:2}

writelog() {
    TS=$(date "+%Y/%m/%d %H:%M:%S")
    echo "${TS} ${scriptName} $@" | tee -a ${ADIR}/tmp/aggregate-${LYMD}.log
}

cd ${RDIR}
mkdir -p ${ADIR}/tmp
rm ${ADIR}/tmp/*

writelog "START"

df -k > ${ADIR}/tmp/df-before-${LYMD}.txt

npsanalyzer/fmtcap.sh capture 2>&1 | tee -a ${ADIR}/tmp/aggregate-${LYMD}.log

wget https://www.cman.jp/network/support/go_access.cgi -q -O - | grep "<th>あなたのIPアドレス<br>" | sed -E 's/.*<p>(.*)<\/p>.*/\1/' > ${ADIR}/tmp/ip-${LYMD}.txt

writelog '# fmtcap/netdump-*-'${SYMD}'_*.cap.txt '$(ls fmtcap/netdump-*-${SYMD}_*.cap.txt | wc -l)
writelog "## srcdst-${SYMD}.txt"
npsanalyzer/srcdst.sh fmtcap/netdump-*-${SYMD}_*.cap.txt > ${ADIR}/tmp/srcdst-${SYMD}.txt

writelog "## macsrcdst-${SYMD}.txt"
npsanalyzer/macsrcdst.sh fmtcap/netdump-*-${SYMD}_*.cap.txt > ${ADIR}/tmp/macsrcdst-${SYMD}.txt

writelog "## ipmac-${SYMD}.txt"
npsanalyzer/ipmac.sh fmtcap/netdump-*-${SYMD}_*.cap.txt > ${ADIR}/tmp/ipmac-${SYMD}.txt

writelog "## mac-${SYMD}.txt"
npsanalyzer/mac.sh fmtcap/netdump-*-${SYMD}_*.cap.txt > ${ADIR}/tmp/mac-${SYMD}.txt

writelog "## end"

df -k > ${ADIR}/tmp/df-after-${LYMD}.txt

writelog "END"

zip -j ${ADIR}/aggregate-${LYMD}.zip ${ADIR}/tmp/*
aws s3 cp ${ADIR}/aggregate-${LYMD}.zip s3://h-oda-npsanalizer/aggregate/${LY_M}/aggregate-${LYMD}.zip
