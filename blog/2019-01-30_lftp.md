---
layout: layouts/blog.njk
title: lftp 覚え書き
tags:
  - blog
categories:
  - lftp
  - ftp
---

lftp を使った ftp サーバーへ接続するときのメモ

## Fatal error: Certificate verification: Not trusted

証明書が信頼出来ないというエラーらしく、

```shell
$ lftp
> set ssl:verify-certificate no
> open SITE -u USER[,PASSWD]
```

`set ssl:verify-certificate no` この一文を入れると証明書を無視してくれるらしい

## 501 Not Owner → Waiting for data connection...

`open` コマンドの前に、

```shell
set ftp:ssl-allow no
```

この一文を入れると解決

## 501 Not Owner → Delaying before reconnect

上記で基本的に解決するのだけど、 `Delaying before reconnect` で30秒ほど待たされる

``` shell
set net:reconnect-interval-base 4
```

これを書くと待ち時間が4秒に短縮されるので、待ち時間をお好みで設定すれば良い

## まとめ

正直信頼出来ない証明書を無視して接続するとか、どうなん？って感じはする

上記をまとめて一文で書くなら、

```shell
$ lftp -e "set ssl:verify-certificate no; set ftp:ssl-allow no; set net:reconnect-interval-base 4" -u USER[,PASSWD] SITE
```
