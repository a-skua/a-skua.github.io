---
layout: layouts/blog.njk
title: "Linuxで始めるOS自作入門: 3日目"
tags:
  - blog
categories:
  - OS自作入門
---

1日目・2日目に比べて濃い内容でした。

1. フロッピーディスクを意識した読み込み
1. 画面モードの切り替え
1. C言語

今回は2箇所躓いたポイントがあります。

## Bootに失敗する

```shell
$ qemu-system-i386 helloos.img
```

この記述でBootに失敗するようになりました。

何度もソース読み直したんですが、 わけがわからず・・・

2日目までの内容との違いなのですが、 3日目の記述は **フロッピーディスク**
の仕組みを意識したデータの読み込みをおこなっているんですよね。

```text
Booting from Hard Disk...
```

おわかりいただけただろうか・・・

もう一度ご覧いただこう・・・

```text
Booting from Hard Disk...
```

はい。

ハードディスクからの読み込みって書いてある・・・

ここをフロッピーディスクからの読み込みに直せないだろうか？？ と調べたところ、
[こちら](https://qemu.weilnetz.de/doc/qemu-doc.html#Block-device-options)
にありました。

```shell
$ qemu-system-i386 -fda helloos.img

Booting from Hard Disk...
Boot failed: could not read the boot disk

Boot from Floppy...
```

`-fda` オプションを付けることによって、無事読み込みに成功しました。

## copy /B a+b c

これ、Windowsのコマンドなんですよね。\
**aとbを結合してcを作る** という処理を行っています。

```shell
$ cat a b > c
```

Linuxの場合はこう書きます。

今回は前回までに比べてソースが長く、
真面目に書いて写していたのでかなり時間をかけてしまいましたorz
