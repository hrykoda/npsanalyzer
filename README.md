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
DAY=YYMMDD
(
echo '# fmtcap/netdump-*-'${DAY}'_*.cap.txt '$(ls fmtcap/netdump-*-${DAY}_*.cap.txt | wc -l)
echo -n "## srcdst-${DAY}.txt"
time npsanalyzer/srcdst.sh fmtcap/netdump-*-${DAY}_*.cap.txt > srcdst-${DAY}.txt
echo -n "## macsrcdst-${DAY}.txt"
time npsanalyzer/macsrcdst.sh fmtcap/netdump-*-${DAY}_*.cap.txt > macsrcdst-${DAY}.txt
echo -n "## ipmac-${DAY}.txt"
time npsanalyzer/ipmac.sh fmtcap/netdump-*-${DAY}_*.cap.txt > ipmac-${DAY}.txt
echo -n "## mac-${DAY}.txt"
time npsanalyzer/mac.sh fmtcap/netdump-*-${DAY}_*.cap.txt > mac-${DAY}.txt
)

# GWのMACアドレス, IPアドレス設定
GWMAC=f8:b7:97:0f:97:0c
GWIP=192.168.0.1

# srcdst-${DAY}.txt
# IPアドレスのsrc/dst組み合わせ確認（データ量の降順ソート済み）
# srcmac srcip srcport > dstmac dstip dstport packet_num packet_size
# <srcport/dstportについて>
#  - : TCPポート番号のないプロトコルの場合
#  * : TCPポート番号が5桁の場合(クライアント側とみなす)
## 内容確認
less srcdst-${DAY}.txt
## インターネット向けパケット一覧
cat srcdst-${DAY}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$5==mac && $6!=ip' | less
## インターネット受信/送信パケットサイズ
cat srcdst-${DAY}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$1==mac && $2!=ip{a+=$9} $5==mac && $6!=ip{b+=$9} END{print a,b;}'
### 一覧
for DAY in 200919 200920 200921 200922 200923 200924 200925 200926 200927 200928; do
echo -n "$DAY "; cat srcdst-${DAY}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$1==mac && $2!=ip{a+=$9} $5==mac && $6!=ip{b+=$9} END{print a,b;}';
done
### ファイルからループで日付取得
echo $(for f in $(ls srcdst-*.txt); do DAY=${f//[^0-9]/}; echo $DAY; done)
## 特定のMACアドレスのインターネット送信データ量
### 上位MACアドレス確認
cat srcdst-${DAY}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$5==mac && $6!=ip' | head
### データ量確認の例(awk の $1 の比較対象を変更する)
cat srcdst-${DAY}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$5==mac && $6!=ip' | awk '$1=="d4:38:9c:7d:3a:5d"{a+=$9} END{print a}'
cat srcdst-${DAY}.txt | awk -v mac=${GWMAC} -v ip=${GWIP} '$5==mac && $6!=ip' | awk '$1=="b4:f7:a1:8c:67:e8"{a+=$9} END{print a}'

# macsrcdst-${DAY}.txt
# MACアドレスのsrc/dst組み合わせ確認（データ量の降順ソート済み）
# srcmac > dstmac packet_num packet_size
## 内容確認
less macsrcdst-${DAY}.txt

# ipmac-${DAY}.txt
# IPアドレス、ポート番号、MACアドレスの組み合わせ毎のデータ通信量確認
# mac ip port src_packet_num dst_packet_num src_packet_size dst_packet_size
# <portについて>
#  - : TCPポート番号のないプロトコルの場合
#  * : TCPポート番号が5桁の場合(クライアント側とみなす)
## srcデータ量で降順ソート
sort -k 6,6nr ipmac-${DAY}.txt | head
## dstデータ量で降順ソート
sort -k 7,7nr ipmac-${DAY}.txt | head
## src/dstデータ量の合計
cat ipmac-${DAY}.txt | awk '{a+=$6; b+=$7} END{print a, b;}'
## src/dstデータ量の合計(MACアドレス限定)
cat ipmac-${DAY}.txt | grep ${GWMAC} | awk '{a+=$6; b+=$7} END{print a, b;}'

# mac-${DAY}.txt
# MACアドレス毎のデータ通信量確認
# mac src_packet_num dst_packet_num src_packet_size dst_packet_size
## srcデータ量で降順ソート
sort -k 4,4nr mac-${DAY}.txt | head
## dstデータ量で降順ソート
sort -k 5,5nr mac-${DAY}.txt | head
## src/dstデータ量の合計
cat mac-${DAY}.txt | awk '{a+=$4; b+=$5} END{print a, b;}'
## src/dstデータ量の合計(MACアドレス限定)
cat mac-${DAY}.txt | grep ${GWMAC} | awk '{a+=$4; b+=$5} END{print a, b;}'

# IPアドレス検索
JPNIC
https://www.nic.ad.jp/ja/application.html
APNIC
http://wq.apnic.net/static/search.html
