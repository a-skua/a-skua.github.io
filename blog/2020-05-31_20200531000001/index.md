---
layout: layouts/blog.njk
title: "Linuxで始めるOS自作入門: 9日目"
tags:
  - blog
categories:
  - OS自作入門
---

## 9日目の内容

1. コード整理
1. メモリ管理

## コード整理

1ファイルにいろいろ書きすぎたので、ファイル分割しようねーという内容

完

## メモリ管理

プロセスを作っていくにあたって、割り当てるメモリを管理しようと言った内容

個人的には興味がある内容だったのでなかなか楽しめた

2種類のメモリ管理の方法を紹介していたので気になる方は買って読んでどうぞって感じ

前にLinuxに関する書籍でLinuxのメモリ管理の解説を読んだのだけど、
それとはまた異なる内容だった

おそらくこの辺はいくつかの手法があるんだと思う

## 成果物

![OSの画面](os-9day.png)

## 追記(6/7)

現在のqemuはデフォルトでメモリが128MBあるらしく、
この書籍が書かれた当時(32MB)とは大きく乖離している

メモリが128MBでも問題はなさそうなのだけど、
ここが異なって居ることで後日躓くのも嫌なので、 qemuのメモリ変更方法が下記になる

```shell
$ qemu-system-i386 -fda haribote.img -m 32M
```

`-m 32M`でメモリサイズ32MBを指定している (`-fda`については過去に記載あり)
