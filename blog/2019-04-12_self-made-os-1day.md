---
layout: layouts/blog.njk
title: "Linuxで始めるOS自作入門: 1日目"
tags:
  - blog
categories:
  - OS自作入門
---

Hello, world をbootしてみようといった内容でした。

## vimを使ったバイナリファイル編集

今回、バイナリファイルをvimで編集したかったのでその方法を記載。  
[こちら](https://vi.stackexchange.com/questions/343/how-to-edit-binary-files-with-vim)
のサイトを参考にしています。

### 新規作成

```shell
$ xxd | vim -
```

### ファイルを開く

```shell
$ xxd file-path | vim -
```

vimで開いた後に
`:%!xxd`
でも開けるのですが、
シェルからのコマンド実行の方がおすすめです。  
vimを開いてからの場合、なぜか最後の行に改行コードが入っていました。

### 保存

```
:%!xxd -r > new-file
```

既存ファイルに上書きしないように、
tmp1, tmp2, ...
といったようにファイルを作成していきました。
(一度上書き失敗してファイルが壊れたため)

### バイナリファイルの書き方

```
00000000: eb4e 9048 454c 4c4f 4950 4c00 0201 0100  .N.HELLOIPL.....
00000010: 02e0 0040 0bf0 0900 1200 0200 0000 0000  ...@............
...略...
000000e0: 0000 0000 0000 0000 0000 0000 0000 0000  ...............
000000f0: 0000 0000 0000 0000 0000 0000 0000 0000  ...............
...略...
```

バイナリファイルをvimで開くとこのような羅列が出てきます。
左から行番号、値、値の表示内容です。  

このファイルを編集するときなのですが、
行番号と値だけを編集すれば問題ないです。  
値の表示内容は触る必要はなく、
新規に行を追加する場合は、
連番になるように行番号を書き、値を記述するだけです。

```
00000020: 0000 0000 0000 0000 0000 0000 0000 0000
```

行番号を自動で入力してくれるものがあれば良いのですが、
見つけられていません。  
連番なので、作ろうと思えば作れそうではありますが…

## QEMU

```shell
$ sudo apt-get install qemu-kvm
```

このコマンドでインストール可能です。

```shell
$ qemu-system-i386 helloos.img
```

実行はこのコマンドだけで実行できます。  
[qemu-doc](https://qemu.weilnetz.de/doc/qemu-doc.html#pcsys_005fquickstart)
を参照してください。

## アセンブラコンパイル

付属のCD-ROMにWindows版のコンパイラが入っていますが、
Linux版は
[著者のサイト](http://hrb.osask.jp/)
から入手可能です。  

```shell
$ ../z_tools/nask.exe helloos.nas helloos.img
```

書籍の解説通りに配置し、
上記のコマンドをで実行できます。  
が、ここで一つ罠があります。

今回、Linux環境は64bitsなのですが、
こちらのファイルは32bits版なので、
**そのようなファイルは存在しない**
と怒られます。  
今回は、
[こちら](https://askubuntu.com/questions/454253/how-to-run-32-bit-app-in-ubuntu-64-bit)
を参考に、32bitsアーキテクチャを追加することで32bits版を実行できるようにしています。  
(正直これが正しいのかどうかはわかりません)

```shell
$ sudo dpkg --add-architecture -386
$ sudo apt-get update
$ sudo apt-get installl libc6:i386 libncurses5:i386 libstdc++6:i386
```

これで無事実行できました。
