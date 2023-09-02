---
layout: layouts/blog.njk
title: RaspberryPiからWi-Fi(EAP-TLS)に接続する
tags:
  - blog
categories:
  - "RaspberryPi"
  - "Linux"
---

RaspberryPiからWi-Fiに接続しようとして試行錯誤していたのでそのメモ．

Linux(Debian)から，Wi-Fiに接続するために必要なサービス:
- `networking.service`
- `dhcpcd.service`
- `wpa_supplicant.service`

`NetworkManager.service`という便利なものもあるよう．
これは`nmcli device wifi list`といったWi-Fiの状態を確認できたりする便利なコマンドを提供してくれてはいるが，
今回は使わず．
```
~ $ systemctl is-active NetworkManager wpa_supplicant networking dhcpcd
inactive
active
active
active
```

## Wi-Fiを利用するために必要なこと
おそらく次の2つ
1. Wi-Fiデバイスを有効にする
2. Wi-Fiの接続設定を行う
3. Wi-Fiデバイスのインターフェースを起動する

### Wi-Fiデバイスを有効にする
Wi-Fiデバイスが有効になっているかどうかは`rfkill`コマンドを利用して確認可能．
```
~ $ rfkill list
0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no
```
もし， `Soft blocked: yes`となっているようであれば，`sudo rfkill unblock wifi`を実行することでブロックを解除できる．

### Wi-Fiの接続設定を行う
`/etc/wpa_supplicant/wpa_supplicant.conf`に次のように記載．
```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=JP

network={
	ssid="my-network"
	scan_ssid=1
	key_mgmt=WPA-EAP
	eap=TLS
	identity="me"
	ca_cert="/etc/cert/ca.pem"
	client_cert="/etc/cert/my.pem"
	private_key="/etc/cert/my.prv"
	private_key_passwd="******"
}
```
SSID非通知なので，`scan_ssid=1`を設定，
EAL-TLSを利用するので， `key_mgmt=WPA-EAP`と`eap=TLS`を設定．
家のWi-Fi APはWPA3-EAPに対応しているが，RaspberryPi上で認識できていなかったのでWPA2-EAPを用意している．
パスワードは`private_key_passwd="hash:foo"`と書けるらしいが，今回は割愛．

### Wi-Fiデバイスのインターフェースを起動する
Wi-Fiデバイスのインターフェースは， `wlan0`として認識されているはず．
```
~ $ ip addr show dev wlan0
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether *** brd ff:ff:ff:ff:ff:ff
    inet ***
    inet6 ***
```
起動していれば，大体こんな感じで割り振られているIPアドレスなどが見えているはず．
が，もし `state DOWN`となっているようであれば，インターフェースを起動してあげる必要がある．

`/etc/network/interfaces`に次の設定を追記
```
auto wlan0
allow-hotplug wlan0
iface wlan0 inet manual
	wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
```
もっとシンプルな設定にできる気もするが，今回はこれでうまくいったのでこのままに．
`inet dhcp`がなぜかうまくいかず，諦めてこんな感じに．
`sudo systemctl restart networking`で再起動できるが，おそらく初回は再起動必須なので`sudo reboot`を実行して再起動．

再起動して， `wlan0`が`state UP`になり，IPアドレスを取得できていればOK．
