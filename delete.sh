#!/bin/bash

RDIR=/home/pi
CDIR=${RDIR}/capture
FDIR=${RDIR}/fmtcap
ADIR=${RDIR}/aggrdata
DEL_BEFORE=3

echo start
df -h

find ${CDIR} -type f -daystart -mtime +${DEL_BEFORE} -delete
find ${FDIR} -type f -daystart -mtime +${DEL_BEFORE} -delete
find ${ADIR} -type f -daystart -mtime +${DEL_BEFORE} -delete

echo end
df -h
