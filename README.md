# npsanalyzer
Network Packet Size Analyzer

# home/piで作業
git clone https://github.com/hrykoda/npsanalyzer.git

# 準備
sudo cp npsanalyzer/netdump.service /etc/systemd/system/
sudo systemctl daemon-reload

# 起動、停止確認
sudo systemctl start netdump
sudo systemctl status netdump
sudo systemctl stop netdump

# 自動起動登録、解除
sudo systemctl enable systemd-networkd-wait-online
sudo systemctl enable netdump
sudo systemctl is-enabled netdump
sudo systemctl disable netdump

# フォーマット変換
npsanalyzer/fmtcap.sh capture

# 集計
SYMD=YYMMDD
ADIR=aggrdata
(
echo '# fmtcap/netdump-*-'${SYMD}'_*.cap.txt '$(ls fmtcap/netdump-*-${SYMD}_*.cap.txt | wc -l)
echo -n "## srcdst-${SYMD}.txt"
time npsanalyzer/srcdst.sh fmtcap/netdump-*-${SYMD}_*.cap.txt > ${ADIR}/srcdst-${SYMD}.txt
echo -n "## macsrcdst-${SYMD}.txt"
time npsanalyzer/macsrcdst.sh fmtcap/netdump-*-${SYMD}_*.cap.txt > ${ADIR}/macsrcdst-${SYMD}.txt
echo -n "## ipmac-${SYMD}.txt"
time npsanalyzer/ipmac.sh fmtcap/netdump-*-${SYMD}_*.cap.txt > ${ADIR}/ipmac-${SYMD}.txt
echo -n "## mac-${SYMD}.txt"
time npsanalyzer/mac.sh fmtcap/netdump-*-${SYMD}_*.cap.txt > ${ADIR}/mac-${SYMD}.txt
)

# GWのMACアドレス, IPアドレス設定
GWMAC=84:af:ec:f5:36:9f
GWIP=192.168.11.1

# srcdst-${SYMD}.txt
# IPアドレスのsrc/dst組み合わせ確認（データ量の降順ソート済み）
# srcmac srcip srcport > dstmac dstip dstport packet_num packet_size
# <srcport/dstportについて>
#  - : TCPポート番号のないプロトコルの場合
#  * : TCPポート番号が5桁の場合(クライアント側とみなす)
## 内容確認
less ${ADIR}/srcdst-${SYMD}.txt
## インターネット向けパケット一覧
cat ${ADIR}/srcdst-${SYMD}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$5==mac && $6!=ip' | less
## インターネット受信/送信パケットサイズ
cat ${ADIR}/srcdst-${SYMD}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$1==mac && $2!=ip{a+=$9} $5==mac && $6!=ip{b+=$9} END{print a,b;}'
### 一覧
for SYMD in 200919 200920 200921 200922 200923 200924 200925 200926 200927 200928; do
echo -n "$SYMD "; cat ${ADIR}/srcdst-${SYMD}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$1==mac && $2!=ip{a+=$9} $5==mac && $6!=ip{b+=$9} END{print a,b;}';
done
### ファイルからループで日付取得
echo $(for f in $(ls srcdst-*.txt); do SYMD=${f//[^0-9]/}; echo $SYMD; done)
## 特定のMACアドレスのインターネット送信データ量
### 上位MACアドレス確認
cat ${ADIR}/srcdst-${SYMD}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$5==mac && $6!=ip' | head
### データ量確認の例(awk の $1 の比較対象を変更する)
cat ${ADIR}/srcdst-${SYMD}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$5==mac && $6!=ip' | awk '$1=="d4:38:9c:7d:3a:5d"{a+=$9} END{print a}'
cat ${ADIR}/srcdst-${SYMD}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$5==mac && $6!=ip' | awk '$1=="b4:f7:a1:8c:67:e8"{a+=$9} END{print a}'

# macsrcdst-${SYMD}.txt
# MACアドレスのsrc/dst組み合わせ確認（データ量の降順ソート済み）
# srcmac > dstmac packet_num packet_size
## 内容確認
less ${ADIR}/macsrcdst-${SYMD}.txt

# ipmac-${SYMD}.txt
# IPアドレス、ポート番号、MACアドレスの組み合わせ毎のデータ通信量確認
# mac ip port src_packet_num dst_packet_num src_packet_size dst_packet_size
# <portについて>
#  - : TCPポート番号のないプロトコルの場合
#  * : TCPポート番号が5桁の場合(クライアント側とみなす)
## srcデータ量で降順ソート
sort -k 6,6nr ${ADIR}/ipmac-${SYMD}.txt | head
## dstデータ量で降順ソート
sort -k 7,7nr ${ADIR}/ipmac-${SYMD}.txt | head
## src/dstデータ量の合計
cat ${ADIR}/ipmac-${SYMD}.txt | awk '{a+=$6; b+=$7} END{print a, b;}'
## src/dstデータ量の合計(MACアドレス限定)
cat ${ADIR}/ipmac-${SYMD}.txt | grep ${GWMAC} | awk '{a+=$6; b+=$7} END{print a, b;}'

# mac-${SYMD}.txt
# MACアドレス毎のデータ通信量確認
# mac src_packet_num dst_packet_num src_packet_size dst_packet_size
## srcデータ量で降順ソート
sort -k 4,4nr ${ADIR}/mac-${SYMD}.txt | head
## dstデータ量で降順ソート
sort -k 5,5nr ${ADIR}/mac-${SYMD}.txt | head
## src/dstデータ量の合計
cat ${ADIR}/mac-${SYMD}.txt | awk '{a+=$4; b+=$5} END{print a, b;}'
## src/dstデータ量の合計(MACアドレス限定)
cat ${ADIR}/mac-${SYMD}.txt | grep ${GWMAC} | awk '{a+=$4; b+=$5} END{print a, b;}'

# IPアドレス検索
JPNIC
https://www.nic.ad.jp/ja/application.html
APNIC
http://wq.apnic.net/static/search.html

# crontab
10 0 * * * /home/pi/npsanalyzer/aggregate.sh
10 1 * * * /home/pi/npsanalyzer/delete.sh
