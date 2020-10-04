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
time npsanalyzer/srcdst.sh fmtcap/netdump-*-${DAY}_*.cap.txt > srcdst-${DAY}.txt
time npsanalyzer/macsrcdst.sh fmtcap/netdump-*-${DAY}_*.cap.txt > macsrcdst-${DAY}.txt
time npsanalyzer/ipmac.sh fmtcap/netdump-*-${DAY}_*.cap.txt > ipmac-${DAY}.txt
time npsanalyzer/mac.sh fmtcap/netdump-*-${DAY}_*.cap.txt > mac-${DAY}.txt

# IPアドレス、ポート番号、MACアドレスの組み合わせ毎のデータ通信量確認
sort -k 6,6nr ipmac-${DAY}.txt | head
sort -k 7,7nr ipmac-${DAY}.txt | head
cat ipmac-${DAY}.txt | awk '{a+=$6; b+=$7} END{print a, b;}'

# MACアドレス毎のデータ通信量確認
sort -k 4,4nr mac-${DAY}.txt | head
sort -k 5,5nr mac-${DAY}.txt | head
cat mac-${DAY}.txt | awk '{a+=$4} END{print a;}'
cat mac-${DAY}.txt | awk '{a+=$5} END{print a;}'

# IPアドレス検索
JPNIC
https://www.nic.ad.jp/ja/application.html
APNIC
http://wq.apnic.net/static/search.html
