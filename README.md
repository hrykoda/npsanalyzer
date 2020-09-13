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


### 参考URL ###
【Linuxのサービス依存関係と順序関係】systemctl list-dependencies と systemd-analyze の見方 
https://milestone-of-se.nesuke.com/sv-basic/linux-basic/systemctl-list-dependencies/ 
 systemctl list-dependencies nodered --after
 
systemdで確実にネットワークの起動後にサービスを起動させたい場合のメモ 
https://kernhack.hatenablog.com/entry/2014/09/20/110938 
 sudo systemctl enable systemd-networkd-wait-online
 
ネットワークの開始後にスクリプトを実行しますか？ 
https://qastack.jp/unix/126009/cause-a-script-to-execute-after-networking-has-started 
 sudo vi /lib/systemd/system/nodered.service
 [Unit]
 Wants=network-online.target
 After=network-online.target
